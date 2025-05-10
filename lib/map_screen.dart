import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MapScreen();
  }
}

class _MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<_MapScreen> {
  late GoogleMapController _mapController;
  final LatLng _origin = LatLng(-19.9191, -43.9937); // Coordinates for the origin address
  LatLng? _destinationCoordinates;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  double? _estimatedTime; // Store the estimated time for the BottomSheet
  final String apiUrl = 'http://192.168.0.19:4242'; // Alterado para HTTP para evitar problemas de handshake

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _fetchOrderDetails();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // Handle permission denial
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/last-order'));

      if (response.statusCode == 200) {
        final orderDetails = jsonDecode(response.body);

        setState(() {
          // Obtém o endereço de entrega do JSON retornado
          final deliveryAddress = orderDetails['lastOrder']['delivery_address'];

          // Usa o Geocoding para converter o endereço em coordenadas
          _getCoordinatesFromAddress(deliveryAddress).then((coordinates) {
            _destinationCoordinates = coordinates;
            _addMarkers();
            _drawRoute();
          });

          _estimatedTime = 15.0; // Exemplo de tempo estimado
        });
      } else {
        print('Erro ao buscar detalhes do pedido: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar detalhes do pedido: ${response.body}')),
        );
      }
    } catch (e) {
      print('Erro ao buscar detalhes do pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar detalhes do pedido: $e')),
      );
    }
  }

  Future<LatLng> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        throw Exception('Endereço não encontrado.');
      }
    } catch (e) {
      print('Erro ao converter endereço em coordenadas: $e');
      throw Exception('Erro ao converter endereço em coordenadas.');
    }
  }

  void _addMarkers() {
    _markers.add(Marker(
      markerId: MarkerId('origin'),
      position: _origin,
      infoWindow: InfoWindow(title: 'Origin'),
    ));

    if (_destinationCoordinates != null) {
      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: _destinationCoordinates!,
        infoWindow: InfoWindow(title: 'Destination'),
      ));
    }
  }

  Future<void> _drawRoute() async {
    if (_destinationCoordinates == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_origin.latitude, _origin.longitude),
        destination: PointLatLng(_destinationCoordinates!.latitude, _destinationCoordinates!.longitude),
        mode: TravelMode.driving, // Specify the travel mode (e.g., driving, walking, etc.)
      ),
      googleApiKey: 'AIzaSyD-VlAZARwmuOHjipfmIN_dE4vmWTu31Ek', // Replace with your Google Maps API Key
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });

      // Adjust the camera to fit the route
      LatLngBounds bounds = _getLatLngBounds(polylineCoordinates);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      // Calculate and store the estimated travel time
      double totalDistance = _calculateTotalDistance(polylineCoordinates);
      double averageSpeed = 40.0; // Average speed in km/h
      double estimatedTime = totalDistance / averageSpeed * 60; // Time in minutes

      setState(() {
        _estimatedTime = estimatedTime; // Store the estimated time
      });
    }
  }

  LatLngBounds _getLatLngBounds(List<LatLng> coordinates) {
    double southWestLat = coordinates.map((c) => c.latitude).reduce((a, b) => a < b ? a : b);
    double southWestLng = coordinates.map((c) => c.longitude).reduce((a, b) => a < b ? a : b);
    double northEastLat = coordinates.map((c) => c.latitude).reduce((a, b) => a > b ? a : b);
    double northEastLng = coordinates.map((c) => c.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  double _calculateTotalDistance(List<LatLng> coordinates) {
    double totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += _calculateDistance(
        coordinates[i].latitude,
        coordinates[i].longitude,
        coordinates[i + 1].latitude,
        coordinates[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Route'),
      ),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _origin,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          _buildSmoothBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildSmoothBottomSheet(BuildContext context) {
    return FlexibleBottomSheet(
      minHeight: 0.2,
      initHeight: 0.4,
      maxHeight: 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context, scrollController, bottomSheetOffset) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Detalhes do Pedido',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (_estimatedTime != null)
                  Text(
                    'Tempo estimado de entrega: ${_estimatedTime!.toStringAsFixed(1)} minutos',
                    style: TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 16),
                Image.asset(
                  'lib/assets/images/calabresa.jpg',
                  height: 150,
                ),
                SizedBox(height: 16),
                Text(
                  'Endereço de entrega:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_destinationCoordinates != null)
                  Text(
                    '${_destinationCoordinates!.latitude}, ${_destinationCoordinates!.longitude}',
                    style: TextStyle(fontSize: 14),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                      content: Text('Entrega confirmada!'),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('Confirmar Entrega'),
                ),
              ],
            ),
          ),
        );
      },
      anchors: [0.2, 0.4, 0.8],
    );
  }
}