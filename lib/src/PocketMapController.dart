import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapData.dart';
import 'package:pocket_map/src/PocketMapUtility.dart';

class PocketMapController implements GoogleMapController {
  GoogleMapController _basicController;
  GoogleMapController get basicController => _basicController;
  set basicController(GoogleMapController basicController) {
    assert(basicController != null);
    _basicController = basicController;
  }

  final VoidCallback _viewUpdater;
  PocketMapData _data;

  PocketMapController(
    this._viewUpdater, {
    PocketMapData data: const PocketMapData(),
  }) : this._data = data;

  void updateData({
    MapType mapType,
    Set<Marker> markers,
    Set<Polyline> polylines,
    Set<Circle> circles,
  }) {
    data = _data.copyWith(
      mapType: mapType,
      markers: markers,
      polylines: polylines,
      circles: circles,
    );
  }

  PocketMapData get data => _data;
  set data(PocketMapData data) {
    this.data = data ?? const PocketMapData();
    _viewUpdater();
  }

  @visibleForTesting
  // ignore: invalid_use_of_visible_for_testing_member
  MethodChannel get channel => _basicController.channel;
  Future<void> animateCamera(CameraUpdate cameraUpdate) async =>
      await _basicController.animateCamera(cameraUpdate);
  Future<void> moveCamera(CameraUpdate cameraUpdate) async =>
      await _basicController.moveCamera(cameraUpdate);
  Future<LatLngBounds> getVisibleRegion() async => await _basicController.getVisibleRegion();

  Future<void> animateToCenter(Iterable<LatLng> positions, {padding: 48.0}) async {
    await animateCamera(CameraUpdate.newLatLngBounds(
        PocketMapUtility.squarePos(data.markers.map((m) => m.position)), padding));
  }

  @override
  Future<void> setMapStyle(String mapStyle) {
    // TODO: implement setMapStyle
    return null;
  }

  void dispose() {
    _basicController = null;
  }
}
