import 'package:flutter/material.dart';
import 'package:minha_agenda/src/modules/splash/usecases/check_logged_user.dart';
import 'package:minha_agenda/src/modules/splash/usecases/get_location_permission.dart';

class SplashStore extends ChangeNotifier {
  final GetLocationPermission getLocationPermission;
  final CheckLoggedUser checkLoggedUser;

  SplashStore({
    required this.getLocationPermission,
    required this.checkLoggedUser,
  });

  bool _carregando = false;
  bool _estaLogado = false;

  bool get carregando => _carregando;
  bool get estaLogado => _estaLogado;

  Future<void> iniciarServicos() async {
    _carregando = true;
    notifyListeners();

    if (!(await checkLoggedUser())) {
      _estaLogado = false;
    } else {
      _estaLogado = true;
      await getLocationPermission();
    }

    _carregando = false;
    notifyListeners();
  }
}
