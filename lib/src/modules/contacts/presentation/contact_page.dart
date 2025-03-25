import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';
import 'package:minha_agenda/src/modules/contacts/presentation/contact_store.dart';
import 'package:minha_agenda/src/modules/contacts/widgets/contato_widget.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<ContactStore>();
      store.inicializarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Consumer<ContactStore>(
      builder: (context, store, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: width / 7,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: store.contatos.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ContatoWidget(adjustedIndex: 0, header: true);
                        } else {
                          final adjustedIndex = index - 1;
                          return ContatoWidget(
                            adjustedIndex: adjustedIndex,
                            contato: store.contatos[adjustedIndex],
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      store.currentLatLng == null
                          ? Center(
                            child: ElevatedButton(
                              onPressed: () => store.setMapPosition(),
                              child: Text("Permitir localização"),
                            ),
                          )
                          : FlutterMap(
                            mapController: store.mapController,
                            options: MapOptions(
                              initialCenter: LatLng(
                                store.currentLatLng!.latitude,
                                store.currentLatLng!.longitude,
                              ),
                              initialZoom: 15,
                              maxZoom: 18,
                              minZoom: 1,
                            ),

                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                tileProvider: CancellableNetworkTileProvider(),
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 40.0,
                                    height: 40.0,
                                    point: LatLng(
                                      store.currentLatLng!.latitude,
                                      store.currentLatLng!.longitude,
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Bem vindo de volta: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          store.usuarioAtual == null
                                              ? "Carregando usuário..."
                                              : store.usuarioAtual!.nome,

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => Dialog(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 12),
                                                  Text(
                                                    "Tem certeza que deseja sair?",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      localStorage.clear();
                                                      Navigator.pushReplacementNamed(
                                                        context,
                                                        '/splash',
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            Colors.black,
                                                          ),
                                                      shape: WidgetStatePropertyAll<
                                                        RoundedRectangleBorder
                                                      >(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.zero,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                          ),
                                                      child: Text(
                                                        "CONFIRMAR",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: Text("Cancelar"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.black,
                                  ),
                                  shape: WidgetStatePropertyAll<
                                    RoundedRectangleBorder
                                  >(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: Text(
                                    "Sair",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton(
                          onPressed: () {
                            store.resetarControllers();
                            showDialog(
                              context: context,
                              builder:
                                  (_) => Dialog(
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                        width: 700,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 12),
                                              Text(
                                                "Tem certeza que deseja apagar a sua conta?",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Esta ação é irreversível!",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                "Digite sua senha para confirmar",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              TextField(
                                                controller:
                                                    store.senhaController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  labelText: "Senha",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              if (store.erro.isNotEmpty) ...[
                                                Text(
                                                  store.erro,
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],

                                              ElevatedButton(
                                                onPressed: () {
                                                  store.apagarContaDoUsuario();

                                                  if (store.erro.isEmpty) {
                                                    Navigator.pushReplacementNamed(
                                                      context,
                                                      '/splash',
                                                    );
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                        Colors.black,
                                                      ),
                                                  shape: WidgetStatePropertyAll<
                                                    RoundedRectangleBorder
                                                  >(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                      ),
                                                  child: Text(
                                                    "CONFIRMAR",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                child: Text("Cancelar"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Apagar conta",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
