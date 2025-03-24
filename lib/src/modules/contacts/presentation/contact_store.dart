import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:minha_agenda/src/models/contato_model.dart';
import 'package:minha_agenda/src/models/endereco_model.dart';
import 'package:minha_agenda/src/models/usuario_model.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_create_contact.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_delete_contact.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_all_contacts.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_cep.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_find_coordinates.dart';
import 'package:minha_agenda/src/modules/contacts/usecases/do_update_contact.dart';
import 'package:minha_agenda/src/modules/global/usecases/get_logged_user.dart';
import 'package:minha_agenda/src/modules/splash/usecases/get_location_permission.dart';

class ContactStore extends ChangeNotifier {
  final DoCreateContact doCreateContact;
  final DoUpdateContact doUpdateContact;
  final DoFindAllContacts doFindAllContacts;
  final DoDeleteContact doDeleteContact;
  final GetLocationPermission getLocationPermission;
  final DoFindCep doFindCep;
  final DoFindCoordinates doFindCoordinates;
  final GetLoggedUser getLoggedUser;

  ContactStore({
    required this.doCreateContact,
    required this.doUpdateContact,
    required this.doFindAllContacts,
    required this.doDeleteContact,
    required this.getLocationPermission,
    required this.doFindCep,
    required this.doFindCoordinates,
    required this.getLoggedUser,
  });

  UsuarioModel? usuarioAtual;
  List<ContatoModel> contatos = [];
  bool _carregando = false;
  bool _buscandoCep = false;
  String _erro = "";
  late ContatoModel? contatoSelecionado;
  LatLng? currentLatLng;

  bool get carregando => _carregando;
  String get erro => _erro;
  bool get buscandoCep => _buscandoCep;

  void inicializarTarefas() async {
    await iniciarUsuarioLogado();
    await setMapPosition();
    await buscarTodosOsContatos();
    setCepError(null);
    setErro('');
    setLocalizationErro(null);
  }

  Future<void> buscarTodosOsContatos() async {
    if (usuarioAtual == null) {
      setErro("Usuário não carregado");
      return;
    }

    _carregando = true;
    notifyListeners();

    final result = await doFindAllContacts(userId: usuarioAtual!.id);

    result.fold(
      (l) {
        setErro(l);
        debugPrint(l);
      },
      (r) {
        debugPrint(r.toString());
        contatos = r;
      },
    );

    _carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarContato() async {
    _carregando = true;
    notifyListeners();

    final novoContato = ContatoModel(
      userId: usuarioAtual!.id,
      id: '',
      nome: nomeController.text,
      cpf: cpfController.text,
      telefone: telefoneController.text,
      endereco: EnderecoModel(
        cep: cepController.text,
        logradouro: logradouroController.text,
        unidade: unidadeController.text,
        bairro: bairroController.text,
        localidade: localidadeController.text,
        uf: ufController.text,
      ),
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
    );

    final result = await doCreateContact(contato: novoContato);

    result.fold(
      (l) {
        setErro(l);
        debugPrint(l);
      },
      (r) {
        setErro('');
        buscarTodosOsContatos();
      },
    );

    _carregando = false;
    notifyListeners();
  }

  Future<void> editarContato() async {
    _carregando = true;
    notifyListeners();

    final contatoAEditar = ContatoModel(
      userId: usuarioAtual!.id,
      id: '',
      nome: nomeController.text,
      cpf: cpfController.text,
      telefone: telefoneController.text,
      endereco: EnderecoModel(
        cep: cepController.text,
        logradouro: logradouroController.text,
        unidade: unidadeController.text,
        bairro: bairroController.text,
        localidade: localidadeController.text,
        uf: ufController.text,
      ),
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
    );

    final result = await doUpdateContact(contato: contatoAEditar);

    result.fold(
      (l) {
        setErro(l);
      },
      (r) {
        final index = contatos.indexWhere((e) => e.id == contatoAEditar.id);
        contatos.insert(index, contatoAEditar);
      },
    );

    _carregando = false;
    notifyListeners();
  }

  Future<void> apagarContato(String id) async {
    _carregando = true;
    notifyListeners();

    final result = await doDeleteContact(userId: usuarioAtual!.id, id: id);

    result.fold(
      (l) {
        setErro(l);
      },
      (r) {
        contatos.removeWhere((e) => e.id == id);
      },
    );

    _carregando = false;
    notifyListeners();
  }

  void setErro(String e) {
    _erro = e;
  }

  Future<void> setMapPosition() async {
    final result = await getLocationPermission();
    final position = result.fold((l) => null, (r) => r as Position?);

    currentLatLng = LatLng(position!.latitude, position.longitude);
    notifyListeners();
  }

  Future<void> buscarEndereco(String cep) async {
    if (jaBuscouCep) return;

    _buscandoCep = true;
    notifyListeners();

    final result = await doFindCep(cep.replaceAll('.', '').replaceAll('-', ''));

    result.fold(
      (l) {
        setErro(l);
        setCepError("Erro na obtenção do endereço");
      },
      (r) async {
        final enderecoFormatado = '${r.logradouro} ${r.bairro}';
        debugPrint(enderecoFormatado);
        final resultCoordinates = await doFindCoordinates(
          endereco: enderecoFormatado,
        );

        resultCoordinates.fold(
          (l) {
            setErro(l);
            setLocalizationErro("Erro na obtenção das coordenadas");
          },
          (c) {
            setLocalizationErro(null);
            final latLng = c;
            latitudeController.text = latLng.latitude.toString();
            longitudeController.text = latLng.longitude.toString();
          },
        );

        final endereco = r;
        logradouroController.text = endereco.logradouro;
        unidadeController.text = endereco.unidade;
        bairroController.text = endereco.bairro;
        localidadeController.text = endereco.localidade;
        ufController.text = endereco.uf;
        estadoController.text = endereco.estado ?? '';
      },
    );

    jaBuscouCep = true;

    _buscandoCep = false;
    notifyListeners();
  }

  Future<void> iniciarUsuarioLogado() async {
    _carregando = true;
    notifyListeners();

    final result = await getLoggedUser();
    result.fold((l) {}, (r) {
      usuarioAtual = r;
    });

    _carregando = false;
    notifyListeners();
  }

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final cepController = TextEditingController();
  final logradouroController = TextEditingController();
  final unidadeController = TextEditingController();
  final bairroController = TextEditingController();
  final localidadeController = TextEditingController();
  final ufController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();
  final estadoController = TextEditingController();

  String? _localizationErro;
  String? get localizationErro => _localizationErro;

  void setLocalizationErro(String? e) {
    _localizationErro = e;
  }

  String? _cepError;
  String? get cepErro => _cepError;

  void setCepError(String? e) {
    _cepError = e;
  }

  bool jaBuscouCep = false;

  void resetarBuscaCep() {
    jaBuscouCep = false;
  }
}
