import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_quote_app/logic/shake_cubit.dart';
import 'package:shake_quote_app/screens/qoute_home.dart';

void main() {
  runApp(const ShakeApp());
}

class ShakeApp extends StatelessWidget {
  const ShakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake Quote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1929),
      ),
      home: BlocProvider(
        create: (context) => ShakeCubit()..startListening(),
        child: const ShakeHomePage(),
      ),
    );
  }
}
