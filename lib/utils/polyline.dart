import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<List<LatLng>> getRoutesBetweenPoints(
  LatLng start,
  LatLng end, [
  List<LatLng> waypoints = const [],
]) async {
  final List<LatLng> vertices = [];
  final request = {
    "origin": {
      "location": {
        "latLng": {"latitude": start.latitude, "longitude": start.longitude}
      }
    },
    "destination": {
      "location": {
        "latLng": {"latitude": end.latitude, "longitude": end.longitude}
      }
    },
    "travelMode": "DRIVE",
    "polylineEncoding": "GEO_JSON_LINESTRING"
  };
  if (waypoints.isNotEmpty) {
    request['intermediates'] = waypoints.map(
      (point) => {
        "location": {
          "latLng": {
            "latitude": point.latitude,
            "longitude": point.longitude,
          }
        }
      },
    );
  }
  final res = await http.post(
    Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes'),
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': 'AIzaSyABRE0-D5OnLtJNsA0XHv7rA3eu-tyEs28',
      'X-Goog-FieldMask': 'routes.legs.polyline',
    },
    body: jsonEncode(request),
  );
  final Map<String, dynamic> obj = jsonDecode(res.body);
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
    LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    poly.add(p);
  }
  return poly;
}
