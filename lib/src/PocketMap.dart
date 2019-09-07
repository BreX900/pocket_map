import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapController.dart';
import 'package:pocket_map/src/PocketMapData.dart';

class PocketMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final ValueChanged<PocketMapController> onMapCreated;
  final PocketMapData data;

  PocketMap({
    Key key,
    @required this.initialCameraPosition,
    @required this.onMapCreated,
    this.data: const PocketMapData(),
  })  : assert(initialCameraPosition != null),
        assert(onMapCreated != null),
        assert(data != null),
        super(key: key);

  @override
  _GoogleMapExtState createState() => _GoogleMapExtState();
}

class _GoogleMapExtState extends State<PocketMap> {
  PocketMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PocketMapController(_updateView, data: widget.data);
  }

  void _updateView() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: _controller.data.mapType,
      markers: _controller.data.markers,
      polylines: _controller.data.polylines,
      circles: _controller.data.circles,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: (googleController) {
        _controller.basicController = googleController;
        widget.onMapCreated(_controller);
      },
    );
  }
}
