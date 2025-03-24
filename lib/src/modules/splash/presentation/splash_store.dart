import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/splash/usecases/get_location_permission.dart';

class SplashStore extends ChangeNotifier {
  final GetLocationPermission getLocationPermission;

  SplashStore({required this.getLocationPermission});
}
