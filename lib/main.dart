import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map/location.dart';
import "package:latlong2/latlong.dart";
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String address = '';
  String name = '';
  String streetAddress = '';

  Future<void> _getAddrress(double latitude, double longitude) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);
    print(newPlace[0]);
    Placemark placeMark = newPlace[0];
    name = placeMark.name!;
    String? locality = placeMark.locality;
    streetAddress = placeMark.street!;

    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    address = "$name, $locality, $postalCode, $country";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: acquireCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng?> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(snapshot.data!.latitude);
            return FlutterMap(
              options: MapOptions(
                center:
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/aivankum/ckrusiaw57nch17w9vkwnki1e/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWl2YW5rdW0iLCJhIjoiY2tyamJ3bzR5MDEwdzJ2cGNxaXNha3M0ZyJ9.Z9T5-SYG3_-hfv3LezwZEQ",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiYWl2YW5rdW0iLCJhIjoiY2tyamJ3bzR5MDEwdzJ2cGNxaXNha3M0ZyJ9.Z9T5-SYG3_-hfv3LezwZEQ',
                      'id': 'mapbox.mapbox-streets-v8',
                    }),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 120.0,
                      height: 120.0,
                      point: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      builder: (ctx) => Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.location_on,
                            size: 30,
                          ),
                          onPressed: () async {
                            await _getAddrress(snapshot.data!.latitude,
                                snapshot.data!.longitude);
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    height: 150,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(bottom: 2),
                                            color: Colors.blue[700],
                                            child: ListTile(
                                              trailing: Container(
                                                padding: EdgeInsets.all(2),
                                                height: 80,
                                                width: 80,
                                                margin:
                                                    EdgeInsets.only(bottom: 0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Icon(Icons.location_on,
                                                    color: Colors.blue[700],
                                                    size: 35),
                                              ),
                                              title: Text(
                                                "Address",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                address,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )),
                                        // ListTile(
                                        //   title: Text('Address'),
                                        //   subtitle: Text(address),
                                        // ),
                                        SizedBox(),
                                        Container(
                                            height: 45,
                                            width: 150,
                                            padding: EdgeInsets.all(0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .red))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            )),
                                        SizedBox()
                                      ],
                                    ),
                                  );
                                });
                          },
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
//IN Raised Button we will call Navigation.pop(context) to store the address and navigate to other location