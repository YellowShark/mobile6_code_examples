import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

const _colors = [
  Colors.indigo,
  Colors.green,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.deepPurple,
  Colors.lightBlue
];

class YandexMapPage extends StatefulWidget {
  const YandexMapPage({Key? key}) : super(key: key);

  @override
  State<YandexMapPage> createState() => _YandexMapPageState();
}

class _YandexMapPageState extends State<YandexMapPage> {
  final _location = Location();
  final List<MapObject> _mapObjects = [];
  final _selectedPoints = <Point>[];
  late YandexMapController _controller;
  final MapObjectId _startMapObjectId = const MapObjectId('start_placemark');
  final MapObjectId _endMapObjectId = const MapObjectId('end_placemark');
  final MapObjectId _polylineMapObjectId = const MapObjectId('polyline');
  late final Uint8List _placemarkIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yandex Map page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              // Виджет для отрисовки Яндекс карты
              child: YandexMap(
                mapObjects: _mapObjects,
                // объекты, которые будут на карте
                onMapCreated: _onMapCreated,
                // метод, который вызывает при создании. через него мы получаем контроллер
                onMapTap: _addMarker, // обработчик нажатия на карту
                onCameraPositionChanged: (position, reason, finished) async {
                  if (reason != CameraUpdateReason.gestures) return;
                  if (!finished) return;

                  final point = position.target;

                  final results = await YandexSuggest.getSuggestions(
                    text: 'Ресторан',
                    boundingBox: BoundingBox(
                      northEast: Point(latitude: point.latitude - 1, longitude: point.longitude - 1),
                      southWest: Point(latitude: point.latitude + 1, longitude: point.longitude + 1),
                    ),
                    suggestOptions: SuggestOptions(
                      suggestType: SuggestType.unspecified,
                      suggestWords: true,
                      userPosition: point,
                    ),
                  ).result;

                  final item = results.items?.first;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('${item?.displayText ?? ' '} ${item?.title ?? ' '} ${item?.subtitle ?? ' '} ${item?.props ?? ' '}')));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _mapObjects.clear();
            _selectedPoints.clear();
          });
        },
        child: const Text("Сброс"),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMapCreated(YandexMapController controller) {
    _controller = controller;
    _checkLocationPermission();
  }

  _checkLocationPermission() async {
    bool locationServiceEnabled = await _location.serviceEnabled();
    if (!locationServiceEnabled) {
      locationServiceEnabled = await _location.requestService();
      if (!locationServiceEnabled) {
        return;
      }
    }

    PermissionStatus locationForAppStatus = await _location.hasPermission();
    if (locationForAppStatus == PermissionStatus.denied) {
      await _location.requestPermission();
      locationForAppStatus = await _location.hasPermission();
      if (locationForAppStatus != PermissionStatus.granted) {
        return;
      }
    }
    // Получаем текущую локацию
    LocationData locationData = await _location.getLocation();
    // Рисуем точку для отметки на карте
    _placemarkIcon = await _rawPlacemarkImage();
    // Определяем точку с текущей позицией
    final point = Point(
        latitude: locationData.latitude!, longitude: locationData.longitude!);
    // Добавляем маркер
    await _addMarker(point);

    // final results = await YandexSearch.searchByPoint(
    //   point: Point(latitude: 59, longitude: 30), searchOptions: SearchOptions(),
    // ).result;
    //
    // final result = results.items?.first.geometry.first.point;
    // if (result != null) {
    //   await _addMarker(result);
    // }
  }

  Future _addMarker(Point point) async {
    // Если нет ни одной отметки, то просто ставим отметку на карте
    if (_selectedPoints.isEmpty) {
      _mapObjects.add(
        // PlacemarkMapObject означает отметку на карте в виде обычной точки
        PlacemarkMapObject(
          mapId: _startMapObjectId,
          point: point,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromBytes(_placemarkIcon),
            ),
          ),
        ),
      );
    } else {
      // Если хотя бы 2 отметки на карте, то стороим между ними маршрут

      // Сначала отметим на карте конечную точку
      _mapObjects.add(
        PlacemarkMapObject(
          mapId: _endMapObjectId,
          point: point,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromBytes(_placemarkIcon),
            ),
          ),
        ),
      );

      // Теперь рассчитаем путь
      /// Объект `YandexDriving` предназначен для построения маршрута. В его метод `requestRoutes()`
      /// мы передаем точки, которые преобразуем в точки для построения маршрута, где в `requestPointType` мы указываем,
      /// что это точки нашего пути. `DrivingOptions` оставляем по умолчанию. В результате нам приходит список
      /// с несколькими путями, но из него мы выбираем самый первый и наносим точку на карту.
      final result = await YandexDriving.requestRoutes(
        points: [_selectedPoints.first, point]
            .map(
              (p) => RequestPoint(
                point: p,
                requestPointType: RequestPointType.wayPoint,
              ),
            )
            .toList(),
        drivingOptions: DrivingOptions(),
      ).result;

      var index = 0;
      result.routes?.forEach(
        (route) {
          // Добавим на карту кривую с полным путём
          _mapObjects.add(
            // PolylineMapObject означает отметку на карте в виде кривой со множеством точек
            PolylineMapObject(
              mapId: MapObjectId('polyline$index'),
              polyline: Polyline(
                points: result.routes?[index].geometry ?? [],
              ),
              strokeColor: _colors[index % 7],
              strokeWidth: 7.5,
              outlineColor: Colors.yellow[200]!,
              outlineWidth: 2.0,
            ),
          );
          index++;
        },
      );
    }

    // Обновляем экран
    setState(() {
      _selectedPoints.add(point);
    });

    // Двигаем карту к точке
    await _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: point),
        ),
        // Плавные переход к точке
        animation: const MapAnimation(
          duration: 1,
          type: MapAnimationType.smooth,
        ));
  }

  Future<Uint8List> _rawPlacemarkImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(50, 50);
    final fillPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const radius = 20.0;

    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
