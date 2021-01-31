import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/app/entity/location_info_entity.dart';
import 'package:dance_chaos_data/models/app_state.dart';
import 'package:dance_chaos_data/models/location_info.dart';
import 'package:dance_chaos_data/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web;
//import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class FireMap extends StatefulWidget {
  final Profile profile;
  final LocationInfo locationInfo;

  FireMap({this.profile, this.locationInfo, Key key}) : super(key: key);

  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  CameraPosition currentCameraPosition;
  double currentZoom = LocationInfo.INITIAL_ZOOM;
  double radiusKm = LocationInfo.INITIAL_RADIUS_KM;  // Initial radius

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
          top: 30,
          right: 30,
          child:
          FlatButton(
            child: Icon(Icons.pin_drop, color: Colors.white),
            color: Colors.green,
//            onPressed: _addGeoPoint
          )
      ),
      Positioned(
        top: 30,
        left: 10,
        child: Slider(
          min: 100.0,
          max: 500.0,
          divisions: 4,
          value: radiusKm,
          label: 'Radius ${radiusKm} km',
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
        widget.profile.homeLocation.longitude) : LocationInfo.DEFAULT_LOCATION;
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
    Store<AppState> store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(ListenForMapChangesAction(_updateMarkers));
  }

  void _updateMarkers(List<LocationInfoEntity> documentList) {
    print(documentList);
    markers.clear();
    documentList.forEach((LocationInfoEntity document) {
      _onMapChange(document);
    });
  }

  void _onMapChange(LocationInfoEntity locationInfoEntity) {
    final MarkerId markerId = MarkerId(locationInfoEntity.id);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        locationInfoEntity.location.latitude,
        locationInfoEntity.location.longitude,
      ),
      infoWindow: InfoWindow(title: locationInfoEntity.displayName, snippet: locationInfoEntity.snippet),
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
        radiusKm = value;
      });

      Store<AppState> store = StoreProvider.of<AppState>(context, listen: false);
      store.dispatch(SetRadiusAction(value));
  }

  @override
  dispose() {
    super.dispose();
  }

}