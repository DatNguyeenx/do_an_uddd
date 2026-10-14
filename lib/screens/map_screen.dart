import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  // 1. Để trống TextField mặc định
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  String _selectedMode = 'car';
  String _selectingField = 'origin'; // Mặc định mở lên sẽ ưu tiên chọn điểm đi trước

  // 2. Chuyển thành Nullable (có thể rỗng) vì lúc đầu chưa có điểm nào
  LatLng? _currentOrigin;
  LatLng? _currentDestination;
  
  // Tọa độ trung tâm mặc định khi vừa mở map (Ví dụ: Trung tâm TP.HCM)
  final LatLng _defaultCenter = const LatLng(10.8061, 106.6262); 

  List<LatLng> _routePoints = [];
  bool _isLoading = false;

  String _distanceInfo = '';
  String _durationInfo = '';

  @override
  void initState() {
    super.initState();
    // 3. XÓA hàm _fetchRoutePolyline() 
  }

  String _getRoutingServerProfile() {
    switch (_selectedMode) {
      case 'walking':
        return 'routed-foot';
      case 'motorcycle':
        return 'routed-bike';
      case 'driving':
      default:
        return 'routed-car';
    }
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${point.latitude}&lon=${point.longitude}');
    try {
      final response = await http.get(url, headers: {'User-Agent': 'com.vietdighep.app'});
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String displayName = data['display_name'] ?? '';
        
        if (displayName.isNotEmpty) {
          List<String> parts = displayName.split(', ');
          return parts.take(3).join(', ');
        }
      }
    } catch (e) {
      debugPrint('Lỗi Geocoding: $e');
    }
    return '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
  }

  Future<void> _fetchRoutePolyline() async {
    // 4. CẤM gọi API nếu 1 trong 2 điểm chưa được chọn
    if (_currentOrigin == null || _currentDestination == null) return;

    setState(() => _isLoading = true);
    final serverProfile = _getRoutingServerProfile();
    
    final url = Uri.parse(
      'https://routing.openstreetmap.de/$serverProfile/route/v1/driving/'
      '${_currentOrigin!.longitude},${_currentOrigin!.latitude};'
      '${_currentDestination!.longitude},${_currentDestination!.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url, headers: {'User-Agent': 'com.vietdighep.app'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          
          final coordinates = route['geometry']['coordinates'] as List;
          final points = coordinates.map((coord) {
            return LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());
          }).toList();

          final double distanceMeters = route['distance'].toDouble();
          final double durationSeconds = route['duration'].toDouble();

          setState(() {
            _routePoints = points;
            _distanceInfo = '${(distanceMeters / 1000).toStringAsFixed(1)} km';
            
            int minutes = (durationSeconds / 60).round();
            if (minutes >= 60) {
              _durationInfo = '${minutes ~/ 60}h ${minutes % 60}p';
            } else {
              _durationInfo = '${minutes} phút';
            }
          });

          _fitRoute();
        }
      }
    } catch (e) {
      debugPrint('Lỗi Routing: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _fitRoute() {
    // Nếu chưa đủ 2 điểm thì không zoom bao quát
    if (_currentOrigin == null || _currentDestination == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bounds = LatLngBounds.fromPoints([_currentOrigin!, _currentDestination!]);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.only(top: 250, bottom: 50, left: 50, right: 50),
        ),
      );
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) async {
    final isOrigin = _selectingField == 'origin';

    setState(() {
      if (isOrigin) {
        _currentOrigin = point;
        _originController.text = 'Đang tìm địa chỉ...';
        // Sau khi chấm điểm đi, tự động chuyển sang trạng thái chờ chấm điểm đến
        if (_currentDestination == null) {
           _selectingField = 'destination'; 
        }
      } else {
        _currentDestination = point;
        _destinationController.text = 'Đang tìm địa chỉ...';
      }
    });

    // Chỉ gọi vẽ đường khi ĐÃ CÓ ĐỦ cả điểm đi và điểm đến
    if (_currentOrigin != null && _currentDestination != null) {
      _fetchRoutePolyline();
    }

    final address = await _getAddressFromLatLng(point);
    if (mounted) {
      setState(() {
        if (isOrigin) {
          _originController.text = address;
        } else {
          _destinationController.text = address;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultCenter, // Hiển thị trung tâm mặc định
              initialZoom: 13.0,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.vietdighep.app',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: const Color(0xFF0F766E),
                      strokeWidth: 5.0,
                      pattern: _selectedMode == 'walking'
                          ? StrokePattern.dashed(segments: [10, 8])
                          : const StrokePattern.solid(),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  // Kiểm tra nếu khác null mới vẽ Marker lên map
                  if (_currentOrigin != null)
                    Marker(
                      point: _currentOrigin!,
                      width: 50,
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                  if (_currentDestination != null)
                    Marker(
                      point: _currentDestination!,
                      width: 50,
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                ],
              ),
            ],
          ),

          if (_isLoading)
            const Positioned(
              top: 0, left: 0, right: 0,
              child: LinearProgressIndicator(color: Color(0xFF0F766E)),
            ),

          Positioned(
            right: 16,
            bottom: 40,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () => _animatedMapMove(_mapController.camera.center, _mapController.camera.zoom + 1.2),
                  child: const Icon(Icons.add, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () => _animatedMapMove(_mapController.camera.center, _mapController.camera.zoom - 1.2),
                  child: const Icon(Icons.remove, color: Colors.black87),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const Text('Chỉ đường', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTransportButton('driving', Icons.directions_car),
                            _buildTransportButton('motorcycle', Icons.two_wheeler),
                            _buildTransportButton('walking', Icons.directions_walk),
                          ],
                        ),
                      ),
                      const Divider(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
                                Container(width: 2, height: 36, color: Colors.grey.shade300),
                                const Icon(Icons.location_on, color: Colors.red, size: 16),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _selectingField = 'origin'),
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _originController,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Chọn điểm đi',
                                          filled: true,
                                          fillColor: _selectingField == 'origin' ? Colors.blue.shade50 : Colors.grey.shade100,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: _selectingField == 'origin' ? const BorderSide(color: Colors.blue, width: 1.5) : BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () => setState(() => _selectingField = 'destination'),
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _destinationController,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'Chọn điểm đến',
                                          filled: true,
                                          fillColor: _selectingField == 'destination' ? Colors.red.shade50 : Colors.grey.shade100,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: _selectingField == 'destination' ? const BorderSide(color: Colors.red, width: 1.5) : BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.swap_vert, size: 28),
                              onPressed: () {
                                String tempText = _originController.text;
                                _originController.text = _destinationController.text;
                                _destinationController.text = tempText;

                                LatLng? tempLatLng = _currentOrigin;
                                _currentOrigin = _currentDestination;
                                _currentDestination = tempLatLng;

                                if (_currentOrigin != null && _currentDestination != null) {
                                  _fetchRoutePolyline();
                                } else {
                                  // Nếu hoán đổi mà bị khuyết 1 điểm thì xóa đường đi cũ
                                  setState(() {
                                    _routePoints.clear();
                                    _distanceInfo = '';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      if (_distanceInfo.isNotEmpty) ...[
                        const Divider(height: 1),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.route, color: Color(0xFF0F766E), size: 20),
                              const SizedBox(width: 6),
                              Text(_distanceInfo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F766E))),
                              const SizedBox(width: 24),
                              const Icon(Icons.access_time_filled, color: Color(0xFF0F766E), size: 20),
                              const SizedBox(width: 6),
                              Text(_durationInfo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F766E))),
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
        ],
      ),
    );
  }

  Widget _buildTransportButton(String mode, IconData icon) {
    bool isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        if (_selectedMode != mode) {
          setState(() => _selectedMode = mode);
          if (_currentOrigin != null && _currentDestination != null) {
            _fetchRoutePolyline();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F766E).withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0F766E) : Colors.grey.shade600,
          size: 26,
        ),
      ),
    );
  }
}