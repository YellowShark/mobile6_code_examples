import 'package:flutter/material.dart';
import 'package:mobile6_examples/week17/extended_point.dart';

class PlacemarksPage extends StatefulWidget {
  const PlacemarksPage({Key? key}) : super(key: key);

  @override
  State<PlacemarksPage> createState() => _PlacemarksPageState();
}

class _PlacemarksPageState extends State<PlacemarksPage> {
  final List<ExtendedPoint> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placemarks'),
      ),
      body: ListView.builder(
          itemCount: _points.length,
          itemBuilder: (_, i) {
            return ListTile(
              title: Text(_points[i].name),
              subtitle: Text('${_points[i].latitude} ${_points[i].longitude}'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/detail');
          if (result == null) return;
          final point = result as ExtendedPoint;
          setState(() {
            _points.add(point);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
