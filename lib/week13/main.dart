import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

const doge =
    'https://i.kym-cdn.com/entries/icons/facebook/000/013/564/doge.jpg';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const LottieAnim(),
        '/home': (context) => const AnimationPage(),
      },
    );
  }
}

class LottieAnim extends StatefulWidget {
  const LottieAnim({Key? key}) : super(key: key);

  @override
  State<LottieAnim> createState() => _LottieAnimState();
}

class _LottieAnimState extends State<LottieAnim> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/loading.json');
  }
}

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  bool show = false;

  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  late final AnimationController _controller2 = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));

  late final AnimationController _controller3 = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 5000))
    ..repeat();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _heightAnimation = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: _heightAnimation.value,
              width: 150,
              child: Image.network(doge),
            ),
            ElevatedButton(
              onPressed: () {
                if (!show) {
                  _controller.forward();
                  _controller2.forward();
                } else {
                  _controller.reverse();
                  _controller2.reverse();
                }
                show = !show;
              },
              child: Text(show ? 'Hide Guest' : 'Show Guest'),
            ),
            AnimatedBuilder(
              animation: _controller2,
              builder: (_, child) => Transform.rotate(
                angle: _controller2.value * math.pi,
                child: child,
              ),
              child: const Icon(
                Icons.arrow_drop_down,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: _controller3,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _controller3.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: const FlutterLogo(size: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
