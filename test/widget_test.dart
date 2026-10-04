import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toko_thrifting_baju/main.dart';
import 'package:toko_thrifting_baju/cart_page.dart';
import 'package:toko_thrifting_baju/checkout_success_page.dart';

void main() {
  testWidgets('Homepage toko thrifting tampil dengan benar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lapak Thrift'), findsOneWidget);
    expect(find.text('Kemeja Flanel Kotak'), findsOneWidget);
    expect(find.text('Masukkan Keranjang'), findsWidgets);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets(
    'Tombol "Masukkan Keranjang" nonaktif otomatis saat stok produk habis',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Hoodie sengaja diberi stock: 2 di data awal supaya cepat habis.
      final tombolHoodie = find.ancestor(
        of: find.text('Masukkan Keranjang').last,
        matching: find.byType(ElevatedButton),
      );

      await tester.tap(tombolHoodie);
      await tester.pump();
      await tester.tap(tombolHoodie);
      await tester.pump();

      // Setelah 2x ditekan, stok habis -> label berubah & tombol nonaktif.
      expect(find.text('Stok Habis'), findsOneWidget);

      final ElevatedButton button = tester.widget(tombolHoodie);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets('Tambah produk ke keranjang lalu buka Cart Page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Masukkan Keranjang').first);
    await tester.pump();

    // Badge jumlah di nav bawah muncul.
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.byKey(const Key('nav_keranjang')));
    await tester.pumpAndSettle();

    expect(find.byType(CartPage), findsOneWidget);
    expect(find.text('Kemeja Flanel Kotak'), findsOneWidget);
  });

  testWidgets('Checkout: isi keranjang, bayar, lalu kembali ke Beranda', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Masukkan Keranjang').first);
    await tester.pump();

    await tester.tap(find.byKey(const Key('nav_keranjang')));
    await tester.pumpAndSettle();

    // Tombol checkout aktif karena total > 0.
    final tombolCheckout = find.widgetWithText(ElevatedButton, 'Checkout');
    expect(tester.widget<ElevatedButton>(tombolCheckout).onPressed, isNotNull);

    await tester.tap(tombolCheckout);
    await tester.pumpAndSettle();

    expect(find.byType(CheckoutSuccessPage), findsOneWidget);
    expect(find.text('Rp65.000'), findsOneWidget);

    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();

    // Kembali ke Beranda, bukan ke Cart Page, dan keranjang sudah kosong.
    expect(find.text('Lapak Thrift'), findsOneWidget);
    expect(find.byType(CartPage), findsNothing);
    expect(find.byType(CheckoutSuccessPage), findsNothing);
  });
}