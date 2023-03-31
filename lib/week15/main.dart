import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (_, constraints) => Scaffold(
        appBar: AppBar(),
        body: SizerUtil.orientation == Orientation.landscape
            ? landscapeLayout()
            : portraitLayout(),
      ),
    );

  Widget landscapeLayout() =>
      Row(
        children: [
          Text(
            "Text",
            style: TextStyle(
                fontSize: SizerUtil.orientation == Orientation.portrait
                    ? 20.sp
                    : 40.sp),
          ),
          const Text(
            "Text",
            style: TextStyle(fontSize: 20),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.green),
            ),
            width: 100,
            height: 40,
            child: const FittedBox(
              child: Text(
                'This is explanation',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      );

  Widget portraitLayout() =>
      Column(
        children: [
          Text(
            "Text",
            style: TextStyle(
                fontSize: SizerUtil.orientation == Orientation.portrait
                    ? 20.sp
                    : 40.sp),
          ),
          const Text(
            "Text",
            style: TextStyle(fontSize: 20),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.green),
            ),
            width: 100,
            height: 40,
            child: const FittedBox(
              child: Text(
                'This is explanation',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      );
}
