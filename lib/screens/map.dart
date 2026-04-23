import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '1600 Amphitheatre Parkway, Mountain View, CA 94043, USA',
    ),
    this.isSelected = true,
  });
  final PlaceLocation location;
  final bool isSelected;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelected ? "Select Location" : "Your Location",
        ),
        actions: [
          if (widget.isSelected)
            IconButton(
              onPressed: () {
                if (_pickedLocation != null) {
                  Navigator.of(context).pop(_pickedLocation);
                }
              },
              icon: const Icon(Icons.save, color: Colors.white),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        // SET data type, new data type is Set<Marker> instead of List<Marker>  duplicates are not allowed in Set, but they are in List
        markers: (_pickedLocation == null && widget.isSelected)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId("m1"),
                  position:
                      _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
