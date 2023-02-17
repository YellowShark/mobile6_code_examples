import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_helper.dart';

const url =
    "https://us-central1-ulyana-34cd8.cloudfunctions.net/stripePaymentIntentRequest";

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool hasSub = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    observeSubscriptionState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Demo App"),
      ),
      body: loading
          ? const CircularProgressIndicator()
          : hasSub
              ? fullScreen
              : subScreen,
    );
  }

  Widget get fullScreen => Column(
        children: [
          TextField(),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () => write(),
            child: const Text(
              'test',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );

  Widget get subScreen => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => initPaymentSheet(context,
                  email: "example@gmail.com", amount: 200000),
              child: const Text(
                'Buy Honey for all my Money!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  Future write() async {
    await FirebaseHelper.completeSubscription(false);
  }

  Future<void> initPaymentSheet(context,
      {required String email, required int amount}) async {
    try {
      // 1. create payment intent on the server
      final response = await http.post(
          Uri.parse(
            url,
          ),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      //2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed!')),
      );

      await FirebaseHelper.completeSubscription(true);
    } catch (e) {
      log(e.toString());
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future observeSubscriptionState() async {
    await Future.delayed(const Duration(seconds: 1));
    FirebaseHelper.subscriptionState().listen((event) {
      final state = event.snapshot.value;
      if (state == null) return;
      final success = (state as bool?);
      if (success == null) return;
      setState(() {
        hasSub = success;
        loading = false;
      });
    });
  }
}
