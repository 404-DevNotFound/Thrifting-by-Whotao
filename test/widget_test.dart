import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toko_thrifting_baju/main.dart';

void main() {
  testWidgets('Homepage toko thrifting tampil dengan benar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // AppBar, kolom cari, dan produk
    expect(find.text('Lapak Thrift'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Kemeja Flanel Kotak'), findsOneWidget);
    expect(find.text('Masukkan Keranjang'), findsWidgets);

    // Navigasi bawah
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}