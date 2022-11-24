import 'package:latlong2/latlong.dart';

class JetuMapState {
  final LatLng mapCenter;
  final String currentAddress;
  final LatLng currentLocation;
  final Map<String, dynamic>? variables;
  final bool mapPanningStart;
  final List<LatLng> points;
  final List<LatLng> route;

  const JetuMapState({
    required this.mapCenter,
    required this.currentAddress,
    required this.currentLocation,
    required this.variables,
    required this.mapPanningStart,
    required this.points,
    required this.route,
  });

  factory JetuMapState.initial() => JetuMapState(
        mapCenter: LatLng(0.0, 0.0),
        currentAddress: '',
        currentLocation: LatLng(0.0, 0.0),
        variables: {},
        mapPanningStart: false,
        points: [],
        route: [],
      );

  JetuMapState copyWith({
    LatLng? mapCenter,
    String? currentAddress,
    LatLng? currentLocation,
    Map<String, dynamic>? variables,
    bool? mapPanningStart,
    List<LatLng>? points,
    List<LatLng>? route,
  }) =>
      JetuMapState(
        mapCenter: mapCenter ?? this.mapCenter,
        currentAddress: currentAddress ?? this.currentAddress,
        currentLocation: currentLocation ?? this.currentLocation,
        variables: variables ?? this.variables,
        mapPanningStart: mapPanningStart ?? this.mapPanningStart,
        points: points ?? this.points,
        route: route ?? this.route,
      );
}
