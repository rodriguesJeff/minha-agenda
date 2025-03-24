import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
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
    WidgetsBinding.instance.addPersistentFrameCallback((x) async {
      final store = context.read<ContactStore>();
      await store.setMapPosition();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    MapController mapController = MapController();

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
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ContatoWidget(adjustedIndex: 0, header: true);
                        } else {
                          final adjustedIndex = index - 1;
                          return ContatoWidget(adjustedIndex: adjustedIndex);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child:
                      store.currentLatLng == null
                          ? Center(
                            child: ElevatedButton(
                              onPressed: () => store.setMapPosition(),
                              child: Text("Permitir localização"),
                            ),
                          )
                          : FlutterMap(
                            mapController: mapController,
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
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
