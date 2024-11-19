import 'package:flutter/material.dart';
import 'login.dart'; // Import halaman login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Berita Latihan Responsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(onTap: () {
        // Fungsi kosong untuk memenuhi parameter onTap
      }), // Memanggil LoginPage dengan fungsi onTap
    );
  }
}