import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapswithme/directions_repository.dart';

import 'directions_model.dart';

void main() {
  runApp(const MyApp());
}
//
//

//
//
//
//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapper',
      theme: ThemeData(primaryColor: Colors.white),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _initialPosition = const CameraPosition(
      target: LatLng(31.527813010097805, 34.437822266016674), zoom: 16.5);
  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Distance Calculator",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (_origin != null)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 25.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              child: const Text(
                "ORIGIN",
              ),
            ),
          if (_destination != null)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 20,
                    target: _destination!.position,
                    zoom: 25.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              child: Text(
                "DESTNation".toUpperCase(),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            circles: {
              if (_destination != null)
                Circle(
                  circleId: const CircleId('currentCircle'),
                  center: LatLng(
                      _origin!.position.latitude, _origin!.position.longitude),
                  radius: 500,
                  fillColor: Colors.blue.shade100.withOpacity(0.5),
                  strokeColor: Colors.blue.shade100.withOpacity(0.4),
                ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: const Color(0xFF7B61FF),
                  width: 6,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              bottom: 40.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(_info!.startAddres),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(_info!.endAddress),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // child: Card(
              //   child: Container(
              //     padding: const EdgeInsets.all(8.0),
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.white,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Text(
              //           "From :${_info!.startAddres}",
              //           style: const TextStyle(
              //             fontSize: 18.0,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //         Text(
              //           "To :${_info!.endAddress}",
              //           style: const TextStyle(
              //             fontSize: 18.0,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
        ],
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionRepo()
          .getDirections(origin: _origin!.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
