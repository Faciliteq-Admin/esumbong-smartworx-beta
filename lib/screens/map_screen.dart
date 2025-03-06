// ignore_for_file: must_be_immutable, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';

class MapScreen extends StatefulWidget {
  double lat;
  double long;
  MapScreen({
    required this.lat,
    required this.long,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static LatLng? _center;
  final Set<Marker> _markers = {};
  late LatLng _lastMapPosition;
  final MapType _currentMapType = MapType.normal;
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.lat, widget.long);
    _lastMapPosition = _center!;
    lat = widget.lat;
    long = widget.long;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('1'),
        position: _center!,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: darkRedColor,
        centerTitle: false,
        title: textLabel(
          text: 'Location',
          color: whiteColor,
          size: 18,
        ),
      ),
      body: GoogleMap(
        mapToolbarEnabled: false,
        zoomControlsEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center!, zoom: 15.0),
        markers: _markers,
        mapType: _currentMapType,
        onCameraMove: _onCameraMove,
        circles: {
          Circle(
            circleId: const CircleId('currentCircle'),
            center: LatLng(widget.lat, widget.long),
            radius: 500,
            fillColor: darkRedColor.withValues(alpha: 0.3),
            strokeColor: darkRedColor.withValues(alpha: 0.1),
          ),
        },
      ),
    );
  }
}
