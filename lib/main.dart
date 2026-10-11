import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'home_page.dart';
import 'theme.dart';

void main() {
  runApp(
    // ChangeNotifierProvider menaruh SATU instance CartProvider di atas
    // seluruh widget tree. Semua halaman di bawahnya (Home, Cart, Checkout
    // Success) bisa membaca/memanggil method-nya lewat context.watch /
    // context.read, tanpa perlu dioper manual lewat constructor seperti
    // sebelumnya (MainApp yang menyimpan `products` & `cart` sendiri sudah
    // tidak dipakai lagi - digantikan class ini).
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

// ---------------------------------------------------------------------------
// MaterialApp
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapak Thrift',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: kDenim),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}