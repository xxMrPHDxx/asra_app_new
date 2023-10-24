import 'package:asra_app_new/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<LatLng>> getRoutesBetweenPoints(
  String token,
  LatLng start,
  LatLng finish, [
  List<LatLng> waypoints = const [],
]) async {
  final List<LatLng> vertices = [];
  final Map<String, dynamic> request = {
    "start": {
      "latitude": start.latitude,
      "longitude": start.longitude,
    },
    "finish": {
      "latitude": finish.latitude,
      "longitude": finish.longitude,
    },
  };
  if (waypoints.isNotEmpty) request['waypoints'] = waypoints;
  final obj = await Api.json.post('/route', request, {
    'Authorization': 'Bearer $token',
  });
  if (!obj['success']) throw Exception(obj['message']);
  if (!obj.containsKey('routes')) throw Exception('Failed to get route!');
  final List<dynamic> routes = obj['routes'];
  if (routes.isEmpty) {
    throw Exception('Failed to find route for given coordinates!');
  }
  final List<dynamic> legs = routes[0]['legs'];
  if (legs.isEmpty) {
    throw Exception('Failed to find route for given coordinates!');
  }
  final List<dynamic> polylines =
      legs[0]['polyline']['geoJsonLinestring']['coordinates'];
  for (final List<dynamic> pos in polylines) {
    vertices.add(LatLng(pos[1], pos[0]));
  }
  return vertices;
}

List<LatLng> decodeEncodedPolyline(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    poly.add(p);
  }
  return poly;
}
