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
  final LatLng _origin = LatLng(
    -19.9191,
    -43.9937,
  ); // Coordinates for the origin address
  LatLng? _destinationCoordinates;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  double? _estimatedTime; // Store the estimated time for the BottomSheet
  final String apiUrl =
      'http://192.168.40.81:4242'; // Alterado para HTTP para evitar problemas de handshake

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
          SnackBar(
            content: Text(
              'Erro ao buscar detalhes do pedido: ${response.body}',
            ),
          ),
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
    // Marcador da pizzaria (origem)
    _markers.add(
      Marker(
        markerId: MarkerId('origin'),
        position: _origin,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Pizza Rush',
          snippet: 'Pizzaria - Ponto de origem',
        ),
      ),
    );

    // Marcador do destino (cliente)
    if (_destinationCoordinates != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: _destinationCoordinates!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: 'Local de Entrega',
            snippet: 'Destino do pedido',
          ),
        ),
      );
    }
  }

  Future<void> _drawRoute() async {
    if (_destinationCoordinates == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(_origin.latitude, _origin.longitude),
        destination: PointLatLng(
          _destinationCoordinates!.latitude,
          _destinationCoordinates!.longitude,
        ),
        mode:
            TravelMode
                .driving, // Specify the travel mode (e.g., driving, walking, etc.)
      ),
      googleApiKey:
          'AIzaSyD-VlAZARwmuOHjipfmIN_dE4vmWTu31Ek', // Replace with your Google Maps API Key
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates =
          result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.red[600]!,
            width: 6,
          ),
        );
      });

      // Adjust the camera to fit the route
      LatLngBounds bounds = _getLatLngBounds(polylineCoordinates);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      // Calculate and store the estimated travel time
      double totalDistance = _calculateTotalDistance(polylineCoordinates);
      double averageSpeed = 40.0; // Average speed in km/h
      double estimatedTime =
          totalDistance / averageSpeed * 60; // Time in minutes

      setState(() {
        _estimatedTime = estimatedTime; // Store the estimated time
      });
    }
  }

  LatLngBounds _getLatLngBounds(List<LatLng> coordinates) {
    double southWestLat = coordinates
        .map((c) => c.latitude)
        .reduce((a, b) => a < b ? a : b);
    double southWestLng = coordinates
        .map((c) => c.longitude)
        .reduce((a, b) => a < b ? a : b);
    double northEastLat = coordinates
        .map((c) => c.latitude)
        .reduce((a, b) => a > b ? a : b);
    double northEastLng = coordinates
        .map((c) => c.longitude)
        .reduce((a, b) => a > b ? a : b);

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

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Route')),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _origin, zoom: 14),
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
      minHeight: 0.25,
      initHeight: 0.4,
      maxHeight: 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      builder: (context, scrollController, bottomSheetOffset) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Cabeçalho com ícone
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[50]!, Colors.orange[50]!],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red[100]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_pizza,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pizza Rush',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'Seu pedido está a caminho!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Tempo estimado com destaque
                if (_estimatedTime != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.green[700],
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tempo estimado',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_estimatedTime!.toStringAsFixed(0)} minutos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20),

                // Imagem da pizza com frame
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/assets/images/calabresa.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Informações do endereço
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Endereço de entrega',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (_destinationCoordinates != null)
                        Text(
                          'Lat: ${_destinationCoordinates!.latitude.toStringAsFixed(4)}\nLng: ${_destinationCoordinates!.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Botão de confirmar entrega melhorado
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.green[300],
                    ),
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Entrega confirmada com sucesso!'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Confirmar Entrega',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      anchors: [0.25, 0.4, 0.8],
    );
  }
}
