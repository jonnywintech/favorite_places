import 'dart:convert';
import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    final lat = _pickedLocation?.latitude;
    final lng = _pickedLocation?.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=$googleMapsApiKey';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey',
    );
    final response = await http.get(url);
    final resData = jsonDecode(response.body);

    // debugPrint('Geocode response status: ${resData['status']}');

    final results = resData['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) {
      setState(() {
        _isGettingLocation = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resData['error_message']?.toString() ??
                'Could not fetch address for current location.',
          ),
        ),
      );
      return;
    }

    final address = results[0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat!,
        longitude: lng!,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location Chosen",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    if (_isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          alignment: Alignment.center,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text("Select on Map"),
            ),
          ],
        ),
      ],
    );
  }
}
