import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Components/googleMapComponents/google_map_on_the_way_card.dart';
import 'package:deliverylo/Components/googleMapComponents/google_map_order_tracking_bottom_sheet.dart';
import 'package:deliverylo/Commons and Reusables/common_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? _mapController;
  bool _showOnTheWayCard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openOrderTrackingBottomSheet();
    });
  }

  Future<void> _openOrderTrackingBottomSheet() async {
    await showCommonBottomSheet(
      context: context,
      type: 'CUSTOM',
      maxWidth: MediaQuery.of(context).size.width,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      child: const GoogleMapOrderTrackingBottomSheet(),
    );

    if (!mounted) return;
    setState(() {
      _showOnTheWayCard = true;
    });
  }

  Widget _buildArrivalChip() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time,
              size: 18,
              color: Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              'Arriving in 20 mins',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: blackFontColor[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8FAFC'),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.6139, 77.2090), // Example: New Delhi
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          SafeArea(
            child: Column(
              children: [
                _buildArrivalChip(),
                const Spacer(),
                if (_showOnTheWayCard)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: const GoogleMapOnTheWayCard(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}