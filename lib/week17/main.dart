import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const googleApiKey = "AIzaSyBLR3iEOULZSNtuNNhhGLIpTASvwxvVLg4";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/map',
      routes: {
        //'/home' : (_) => const HomePage(),
        '/map' : (_) => const MapPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (_, i) => ListTile(
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/map', arguments: LatLng(0, 0));
            if (result != null && result is LatLng) {
                final coordinates = result;
                // list.add(coordinates)
                // setState(() {});
            }
          },
        ),
        itemCount: 0,
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location location = Location();
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map page"),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(50.45, 30.52),
          zoom: 15,
        ),
        myLocationEnabled: false,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        markers: markers,
        polylines: Set.of(polylines.values),
        onTap: _addMarker,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() {
          //   markers.clear();
          //   polylines.clear();
          // });
          Navigator.pop(context, LatLng(0, 0));
        },
        child: const Text("Save"),
      ),
    );
  }

  void _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
    _mapController = mapController;
  }

  _checkLocationPermission() async {
    bool locationServiceEnabled = await location.serviceEnabled();
    if (!locationServiceEnabled) {
      locationServiceEnabled = await location.requestService();
      if (!locationServiceEnabled) {
        return;
      }
    }

    PermissionStatus locationForAppStatus = await location.hasPermission();
    if (locationForAppStatus == PermissionStatus.denied) {
      await location.requestPermission();
      locationForAppStatus = await location.hasPermission();
      if (locationForAppStatus != PermissionStatus.granted) {
        return;
      }
    }

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is LatLng) {
      final coordinates = args;
      _addMarker(coordinates);
    } else {
      LocationData locationData = await location.getLocation();
      _addMarker(LatLng(locationData.latitude!, locationData.longitude!));
    }
  }

  void _addMarker(LatLng position) async {
    //if (markers.isEmpty) {
    markers.add(Marker(
        markerId: const MarkerId("start"),
        infoWindow: const InfoWindow(title: "Start"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: position));

    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
    // } else {
    //   markers.add(Marker(
    //       markerId: const MarkerId("finish"),
    //       infoWindow: const InfoWindow(title: "Finish"),
    //       icon:
    //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //       position: position));
    //   final points = PolylinePoints();
    //   final start = PointLatLng(
    //       markers.first.position.latitude, markers.first.position.longitude);
    //   final finish = PointLatLng(
    //       markers.last.position.latitude, markers.last.position.longitude);
    //
    //   final result = await points.getRouteBetweenCoordinates(
    //       googleApiKey, start, finish,
    //       optimizeWaypoints: true);
    //   polylineCoordinates.clear();
    //
    //   if (result.points.isNotEmpty) {
    //     result.points.forEach((point) {
    //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //     });
    //   }
    //   _addPolyLine();
    // }
    setState(() {});
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }
}
