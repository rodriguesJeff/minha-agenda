import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocationPermission {
  Future<Either<String, Position>> call() async {
    final locationPermissionStatus = await Permission.location.status;

    if (!locationPermissionStatus.isGranted) {
      await Geolocator.requestPermission();
    }

    if (locationPermissionStatus.isGranted) {
      final position = await Geolocator.getCurrentPosition();

      return Right(position);
    } else {
      return Left("É necessário dar permissão para obtermos sua localização!");
    }
  }
}
