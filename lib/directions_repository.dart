import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions_model.dart';

class DirectionRepo {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio? _dio;

  DirectionRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio!.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': "AIzaSyCtFTKLDioQYDHZRAmIsL6iksSLvTTzoYQ",
      },
    );

    print("This is origion , dest '${origin.latitude},${origin.longitude}");
    print("'destination': '${destination.latitude},${destination.longitude}'");
    // Check if response is successful
    if (response.statusCode == 200) {
      print("This is response ${response.data.toString()}");
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
