import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// API base URL to connect with the Backend
final apiBase =
    kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS
    ? 'http://localhost:4000'
    : 'https://276077cee547.ngrok-free.app';

//--------- OfferWithin mapping----------
//In Backend the GetOfferWithin field is stored as Number because it will help finding the requests which deadline is near
// But in the frontend inside the Banquet&Venue screen we are keeping it usual, so we have to map hours(int) to days and week(string)
const Map<int, String> offerWithinOptions = {
  24: "24 hours",
  48: "2 days",
  72: "3 days",
  168: "1 week",
};

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SsquadVentures',
      debugShowCheckedModeBanner: false, //removing default debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E67F8)),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // setting homescreen as default screen
    );
  }
}
