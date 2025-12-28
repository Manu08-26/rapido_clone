import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';

class RideBookingScreen extends StatefulWidget {
  final String? pickupLocation;
  final String? dropLocation;

  const RideBookingScreen({
    super.key,
    this.pickupLocation,
    this.dropLocation,
  });

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  final AppTheme _appTheme = AppTheme();
  GoogleMapController? _mapController;
  String _selectedRideType = 'Bike'; // Bike, Auto, Cab
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _appTheme.addListener(_onThemeChanged);
    _initializeMap();
  }

  @override
  void dispose() {
    _appTheme.removeListener(_onThemeChanged);
    _mapController?.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  void _initializeMap() {
    // Initialize map with route polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          const LatLng(17.3850, 78.4867), // Pickup location (Hyderabad)
          const LatLng(17.4500, 78.5000), // Drop location
        ],
        color: _appTheme.textColor,
        width: 4,
      ),
    );

    // Add markers for pickup and drop
    _markers.addAll({
      Marker(
        markerId: const MarkerId('pickup'),
        position: const LatLng(17.3850, 78.4867),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: const LatLng(17.4500, 78.5000),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Drop Location'),
      ),
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Fit bounds to show both pickup and drop locations
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: const LatLng(17.3850, 78.4867),
          northeast: const LatLng(17.4500, 78.5000),
        ),
        100,
      ),
    );
  }

  Map<String, dynamic> _getRideDetails(String rideType) {
    switch (rideType) {
      case 'Bike':
        return {
          'image': 'assets/bike1.png',
          'time': '2 Min',
          'baseFare': '1₹',
          'price': '₹65',
          'icon': Icons.two_wheeler,
        };
      case 'Auto':
        return {
          'image': 'assets/auto1.png',
          'time': '2 Min',
          'baseFare': '3₹',
          'price': '₹90',
          'icon': Icons.airport_shuttle,
          'tagline': 'Ride Easy. Book Fast.',
        };
      case 'Cab':
        return {
          'image': 'assets/car1.png',
          'time': '2 Min',
          'baseFare': '4₹',
          'price': '₹180',
          'icon': Icons.directions_car,
        };
      default:
        return {
          'image': 'assets/bike1.png',
          'time': '2 Min',
          'baseFare': '1₹',
          'price': '₹65',
          'icon': Icons.two_wheeler,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: _appTheme.textDirection,
      child: Scaffold(
        backgroundColor: _appTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: _appTheme.cardColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              _appTheme.rtlEnabled ? Icons.arrow_forward : Icons.arrow_back,
              color: _appTheme.textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.pickupLocation ?? 'Pikkar',
            style: TextStyle(
              color: _appTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: _appTheme.textColor),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            // Map View
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(17.4175, 78.4934), // Center between pickup and drop
                zoom: 14.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              compassEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: false,
              mapToolbarEnabled: false,
            ),

            // My Location Button
            Positioned(
              bottom: 400,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: _appTheme.cardColor,
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      const LatLng(17.4175, 78.4934),
                      14.0,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.my_location, color: _appTheme.textColor, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      'My Location',
                      style: TextStyle(
                        fontSize: 8,
                        color: _appTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Ride Options Panel
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: _appTheme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _appTheme.textGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Location Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.pickupLocation ?? 'Pikkar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _appTheme.textColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ride Options List
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _buildRideOption('Bike'),
                            const SizedBox(height: 12),
                            _buildRideOption('Auto'),
                            const SizedBox(height: 12),
                            _buildRideOption('Cab'),
                            const SizedBox(height: 20),

                            // Promotional Banner
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Transparent fares and zero hidden charges - only on Pikkar.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Payment Method
                            Row(
                              children: [
                                Icon(Icons.money, color: _appTheme.textColor, size: 20),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cash',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _appTheme.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Direct pay to Driver',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _appTheme.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Book Ride Button
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _appTheme.cardColor,
                          border: Border(
                            top: BorderSide(
                              color: _appTheme.dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: SafeArea(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle book ride
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Booking ${_selectedRideType}...'),
                                    backgroundColor: _appTheme.brandRed,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _appTheme.brandRed,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Book Ride',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideOption(String rideType) {
    final details = _getRideDetails(rideType);
    final isSelected = _selectedRideType == rideType;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRideType = rideType;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _appTheme.brandRed.withOpacity(0.1)
              : _appTheme.iconBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _appTheme.brandRed : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Ride Image/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _appTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  details['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      details['icon'] as IconData,
                      color: _appTheme.brandRed,
                      size: 32,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Ride Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        rideType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _appTheme.textColor,
                        ),
                      ),
                      if (details['tagline'] != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          details['tagline'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: _appTheme.textGrey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${details['time']} | ${details['baseFare']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _appTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Text(
              details['price'] as String,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _appTheme.brandRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

