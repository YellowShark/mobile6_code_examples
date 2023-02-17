import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile6_examples/firebase_options.dart';
import 'package:mobile6_examples/week19/home_page.dart';
import 'package:mobile6_examples/week19/login_page.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LeF4gIqnS8d6yUMeqB0UewwX83GlmUNNf7E9n6TNka6R4O9S9blN2wap1YJEB8Y1joFtG9Y1v0Jono4HJ2XIqPh00sQWysObI";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    name: 'payment-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginPage(),
        'home': (_) => const PaymentPage(),
      },
    );
  }
}
