import 'package:dance_chaos/firebase/repo/firestore_profile_repository.dart';
import 'package:dance_chaos/models/location_info.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web;
//import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class FireMap extends StatefulWidget {
  final Profile profile;
  final LocationInfo locationInfo;

  FireMap({this.profile, this.locationInfo, Key key}) : super(key: key);

  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  GoogleMapController mapController;

  FirebaseFirestore firestore = FirestoreProfileRepository.firestore();
  Geoflutterfire geo = Geoflutterfire();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  // Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
  Stream<dynamic> query;

  CameraPosition currentCameraPosition;
  double currentZoom = 17;

  final defaultLocation = LatLng(53.814167, -3.050278);

  // Location radius Subscription
  StreamSubscription subscription;

  @override
  void initState() {
    // Move map to new location
    if (currentCameraPosition == null) {
      currentCameraPosition = CameraPosition(
        target: _getTargetCameraPosition(),
        zoom: currentZoom,
      );  // Default location is user's home or global default
    }

    super.initState();
  }

  build(context) {
    _checkCameraPosition();
    return Stack(children: [
    GoogleMap(
          initialCameraPosition: currentCameraPosition,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          compassEnabled: true,
          markers: Set<Marker>.of(markers.values),
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
      ),
     Positioned(
          bottom: 50,
          right: 10,
          child:
          FlatButton(
            child: Icon(Icons.pin_drop, color: Colors.white),
            color: Colors.green,
            onPressed: _addGeoPoint
          )
      ),
      Positioned(
        bottom: 50,
        left: 10,
        child: Slider(
          min: 100.0,
          max: 500.0,
          divisions: 4,
          value: radius.value,
          label: 'Radius ${radius.value}km',
          activeColor: Colors.green,
          inactiveColor: Colors.green.withOpacity(0.2),
          onChanged: _updateQuery,
        )
      )
    ]);
  }

  void _onCameraMove(CameraPosition position) {
      currentCameraPosition = position;
  }

  void _onCameraIdle() {
    _startQuery();
  }

  // Map Created Lifecycle Hook
  _onMapCreated(GoogleMapController controller) {
    _startQuery();
    setState(() {
      mapController = controller;
    });
  }

  LatLng _getTargetCameraPosition() {
    return widget.locationInfo?.location != null ? LatLng(
        widget.locationInfo.location.latitude,
        widget.locationInfo.location.longitude) :
    widget.profile.homeLocation != null ? LatLng(
        widget.profile.homeLocation.latitude,
        widget.profile.homeLocation.longitude) : defaultLocation;
  }

    bool _checkCameraPosition() {

      LatLng newLocation = _getTargetCameraPosition();

      _checkIfAnimateNeeded(newLocation);

    return false; // No change
  }

  void _checkIfAnimateNeeded(LatLng newLocation) {
//    double distance = geo.point(latitude: currentCameraPosition.target.latitude, longitude: currentCameraPosition.target.longitude).distance(lat: newLocation.latitude, lng: newLocation.longitude);
    if (mapController != null) {
      mapController.getScreenCoordinate(newLocation).then((coordinate) {
        double screenWidth = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio;
        double screenHeight = MediaQuery.of(context).size.height *
            MediaQuery.of(context).devicePixelRatio;

        if (coordinate.x <= 0 || coordinate.y <= 0 || coordinate.x >= screenWidth || coordinate.y >= screenHeight) {
          print('Animating to $newLocation');
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              currentCameraPosition = CameraPosition(
                target: newLocation,
                zoom: currentZoom,
              )
            )
          ); // Default location is user's home or global default
        }
        return coordinate;
      });
    }
  }

  // Set GeoLocation Data
  Future<DocumentReference> _addGeoPoint() async {
    GeoFirePoint point = geo.point(latitude: currentCameraPosition.target.latitude, longitude: currentCameraPosition.target.longitude);
    return firestore.collection('locations').add({
      'position': point.data,
      'displayName': 'Yay I can be queried!'
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data();
        GeoPoint pos = data['position']['geopoint'];
        double distance = data['distance'];
        _addMarker(pos, document.id, data['displayName'], snippet: distance.toString());
    });
  }

  void _addMarker(GeoPoint pos, String markerIdVal, String title, {String snippet}) {
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        pos.latitude,
        pos.longitude,
      ),
      infoWindow: InfoWindow(title: title, snippet: snippet),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
      // icon: BitmapDescriptor.fromAssetImage(asset: 'abc'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  _startQuery() async {
    // Get map location
    double lat = currentCameraPosition.target.latitude;
    double lng = currentCameraPosition.target.longitude;

    // Make a reference to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription?.cancel();
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center,
        radius: rad,
        field: 'position',
        strictMode: true,
      );
    }).listen(_updateMarkers);
  }

  _updateQuery(value) {
      final zoomMap = {
          100.0: 17.0,
          200.0: 15.0,
          300.0: 12.0,
          400.0: 11.0,
          500.0: 10.0
      };
      final zoom = zoomMap[value];
      mapController.moveCamera(CameraUpdate.zoomTo(zoom));
      currentZoom = zoom;

      setState(() {
        radius.add(value);
      });
  }

  @override
  dispose() {
    subscription?.cancel();
    super.dispose();
  }

}