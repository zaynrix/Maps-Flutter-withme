import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.white),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _initialPosition = const CameraPosition(
      target: LatLng(31.477157832309437, 34.405053122885384), zoom: 11.5);

  GoogleMapController? _googleMapController;

  @override
  void dispose() {
    _googleMapController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.center_focus_strong,
          color: Colors.black,
        ),
        onPressed: () => _googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(_initialPosition)),
      ),
      body: GoogleMap(
          onMapCreated: (controller) => _googleMapController = controller,
          initialCameraPosition: _initialPosition,
          myLocationButtonEnabled: false,
          myLocationEnabled: false),
    );
  }
}
