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

  void _startTracking() {
    if (!_isTracking) {
      setState(() {
        _isTracking = true;
        if (_currentPosition != null) {
          _locationHistory.add(_currentPosition!);
        }
      });

      _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(Duration(seconds: 5));
          setState(() {
            _currentPosition = position;
            _locationHistory.add(position);
            if (_locationHistory.length > 50) {
              _locationHistory.removeAt(0);
            }
            _updateMarker(position);
            _centerMap(position);
          });
          _getAddressFromLatLng(position);
        } catch (e) {
          print("Error updating location: $e");
        }
      });
    }
  }

  void _stopTracking() {
    if (_isTracking) {
      _locationTimer?.cancel();
      setState(() {
        _isTracking = false;
      });
    }
  }

  void _clearTracking() {
    _stopTracking();
    setState(() {
      _locationHistory.clear();
    });
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
    return 'Accuracy: ${position.accuracy.toStringAsFixed(1)} meters';
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
                        'My Location',
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
                              'Current Address:',
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
                              'Coordinates:',
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
                            _isTracking ? 'Stop' : 'Track',
                            _isTracking ? Icons.stop : Icons.play_arrow,
                            _isTracking ? _stopTracking : _startTracking,
                            _isTracking ? Colors.orange : Colors.green,
                          ),
                          _buildControlButton(
                            'Refresh',
                            Icons.my_location,
                            _getCurrentLocation,
                            Colors.blue,
                          ),
                          _buildControlButton(
                            'Clear',
                            Icons.delete,
                            _clearTracking,
                            Colors.red,
                            disabled: _locationHistory.isEmpty,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      if (_locationHistory.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Location History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: _locationHistory.length > 4 ? 200 : (_locationHistory.length * 50.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: _locationHistory.length,
                                  itemBuilder: (context, index) {
                                    final reverseIndex = _locationHistory.length - 1 - index;
                                    final position = _locationHistory[reverseIndex];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0 ? Colors.blue[50] : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Point ${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          Text(
                                            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _currentPosition == null ? null : () => _centerMap(_currentPosition!),
          backgroundColor: Colors.blue,
          child: const Icon(Icons.center_focus_strong, color: Colors.white),
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