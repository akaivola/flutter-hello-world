import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: MultiMap(title: 'Multimap'),
    );
  }
}

class MultiMap extends StatefulWidget {
  MultiMap({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State createState() => _MultiMapState();
}

class _MultiMapState extends State<MultiMap> {
  @override
  Widget build(BuildContext context) {
    final MapboxMap map = MapboxMap(
      styleString: "mapbox://styles/akaivola/ck0v64jdp0eet1cqu0lpfq38g",
      zoomGesturesEnabled: true,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-33.852, 151.211),
        zoom: 11.0,
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.my_location),
        label: const Text('GPS'),
        backgroundColor: Colors.blue,
        onPressed: () async {
          final location = Location();
          final hasPermissions = await location.serviceEnabled() && await location.hasPermission();
          if (!hasPermissions) {
            await location.requestPermission();
          }
          location.changeSettings(
            accuracy: LocationAccuracy.HIGH,
            interval: 1000,
            distanceFilter: 1
          );
          location.onLocationChanged().listen((LocationData currentLocation) {
            if (currentLocation.accuracy > 10) {
              location.changeSettings(
                accuracy: LocationAccuracy.HIGH,
                interval: 1000,
                distanceFilter: currentLocation.accuracy + 2
              );
            }
            print(currentLocation.accuracy);
            print(currentLocation.latitude);
            print(currentLocation.longitude);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: map,
    );
  }
}
