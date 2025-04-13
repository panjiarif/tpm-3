import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class LocationApp extends StatefulWidget {
  final VoidCallback onBack;

  const LocationApp({
    super.key,
    required this.onBack,
  });

  @override
  State<LocationApp> createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  String _currentAddress = "Finding location...";
  bool _isLoading = true;
  bool _isTracking = false;
  Timer? _locationTimer;
  List<Position> _locationHistory = [];
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    print("Starting _getCurrentLocation");
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = "Location services are disabled";
          _isLoading = false;
        });
        print("Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print("Permission status: $permission");
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = "Location permission denied";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = "Location permissions permanently denied";
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Location fetch timed out");
      });

      setState(() {
        _currentPosition = position;
        _updateMarker(position);
        _isLoading = false;
      });

      _centerMap(position);
      _getAddressFromLatLng(position);
    } catch (e) {
      print("Error in _getCurrentLocation: $e");
      setState(() {
        _currentAddress = "Error fetching location: $e";
        _isLoading = false;
      });
    }
  }


  void _updateMarker(Position position) {
    _markers = [
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(position.latitude, position.longitude),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue[700],
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _centerMap(Position position) {
    _mapController.move(
      LatLng(position.latitude, position.longitude),
      15.0,
    );
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.street ?? ''}, ${place.subLocality ?? ''}, '
              '${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Unable to fetch address";
      });
    }
  }

  String _formatCoordinates(Position? position) {
    if (position == null) return "Waiting for location...";
    return 'Lat: ${position.latitude.toStringAsFixed(6)}, '
        'Long: ${position.longitude.toStringAsFixed(6)}';
  }

  String _formatAccuracy(Position? position) {
    if (position == null) return "";
    return 'Akurasi: ${position.accuracy.toStringAsFixed(1)} meter';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          widget.onBack();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * (75 / 100),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lokasi Saya',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 33, 177, 243),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _isLoading || _currentPosition == null
                            ? Center(child: CircularProgressIndicator())
                            : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              errorTileCallback: (tile, error, stackTrace) {
                                print("Tile loading error: $error");
                              },
                            ),
                            MarkerLayer(markers: _markers),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi Sekarang:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _currentAddress,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Koordinat:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formatCoordinates(_currentPosition),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formatAccuracy(_currentPosition),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            'Refresh',
                            Icons.my_location,
                            _getCurrentLocation,
                            Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onPressed, Color color, {bool disabled = false}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled ? Colors.grey[300] : color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: disabled ? Colors.grey : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}