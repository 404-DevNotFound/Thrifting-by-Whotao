import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toko_thrifting_baju/main.dart';
import 'package:toko_thrifting_baju/cart_page.dart';

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

  testWidgets('Navigasi ke Cart Page dan kembali ke Beranda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Dari Beranda, tekan ikon "Keranjang" di nav bawah -> Navigator.push
    await tester.tap(find.byKey(const Key('nav_keranjang')));
    await tester.pumpAndSettle();

    expect(find.byType(CartPage), findsOneWidget);
    expect(find.byType(TextField), findsWidgets); // kolom cari + input jumlah

    // Dari Cart Page, tekan ikon "Beranda" di nav bawah -> Navigator.pop
    await tester.tap(find.byKey(const Key('nav_beranda')));
    await tester.pumpAndSettle();

    expect(find.byType(CartPage), findsNothing);
    expect(find.text('Lapak Thrift'), findsOneWidget);
  });
}