import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:servi_pro/features/requests/presentation/providers/map_notifier.dart';

class MapScreen extends ConsumerWidget {
  static const _initialCente = LatLng(1.2136, -77.2811);
  static const _initialZoom = 11.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);

    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: _initialCente,
        initialZoom: _initialZoom,
      ),

      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.servi_pro',
          keepBuffer: 2,
        ),
      ],
    );
  }
}
