import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

abstract class LocationEvent {}

class InitializeEvent extends LocationEvent {}

class LocationState {
  final Location _location;

  LocationState({
    required Location location,
  }) : _location = location;

  Future<Location?> get location async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return _location;
  }
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState(location: Location()));
}
