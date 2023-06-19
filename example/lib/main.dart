import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // EXAMPLE #1 of showAlertBanner()
              // You can alter its MANY fields, too
              TextButton(
                onPressed: () => showAlertBanner(
                  context,
                  () => print("TAPPED"),
                  const ExampleAlertBannerChild(),
                  alertBannerLocation: AlertBannerLocation.top,
                  // .. EDIT MORE FIELDS HERE ...
                ),
                child: const Text("Show top alert"),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "🔥 Use with your own custom child widget.\n\n🔥 Adjust every field, such as child, durations, anim curves, safe areas, etc.\n\n🔥 Easy to call.\n\n🔥 Dismissible.\n\n🔥 Callback for onTap.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // EXAMPLE #2 of showAlertBanner()
              // You can alter its MANY fields, too
              TextButton(
                onPressed: () => showAlertBanner(
                  context,
                  () => print("TAPPED"),
                  const ExampleAlertBannerChild(),
                  alertBannerLocation: AlertBannerLocation.startButtom,
                ),
                child: const Text("Show bottom alert"),
                // .. EDIT MORE FIELDS HERE ...
              ),
            ],
          ),
        ));
  }
}

// Example child of alert banner
class ExampleAlertBannerChild extends StatelessWidget {
  const ExampleAlertBannerChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Text(
            "This is an example notification. It looks awesome!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
