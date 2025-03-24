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
import 'package:minha_agenda/src/modules/contacts/usecases/do_update_contact.dart';
import 'package:minha_agenda/src/modules/splash/usecases/get_location_permission.dart';

class ContactStore extends ChangeNotifier {
  final DoCreateContact doCreateContact;
  final DoUpdateContact doUpdateContact;
  final DoFindAllContacts doFindAllContacts;
  final DoDeleteContact doDeleteContact;
  final GetLocationPermission getLocationPermission;
  final DoFindCep doFindCep;

  ContactStore({
    required this.doCreateContact,
    required this.doUpdateContact,
    required this.doFindAllContacts,
    required this.doDeleteContact,
    required this.getLocationPermission,
    required this.doFindCep,
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

  Future<void> buscarTodosOsContatos() async {
    _carregando = true;
    notifyListeners();

    await setMapPosition();

    final result = await doFindAllContacts(userId: usuarioAtual!.id);

    result.fold(
      (l) {
        setErro(l);
      },
      (r) {
        contatos = r;
      },
    );

    _carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarUsuario() async {
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
      },
      (r) {
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
    _buscandoCep = true;
    notifyListeners();

    final result = await doFindCep(cep.replaceAll('.', '').replaceAll('-', ''));

    result.fold(
      (l) {
        setErro(l);
      },
      (r) {
        final endereco = r;
        logradouroController.text = endereco.logradouro;
        unidadeController.text = endereco.unidade;
        bairroController.text = endereco.bairro;
        localidadeController.text = endereco.localidade;
        ufController.text = endereco.uf;
      },
    );

    _buscandoCep = false;
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
}
