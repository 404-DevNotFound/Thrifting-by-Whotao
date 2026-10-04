import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'checkout_success_page.dart';
import 'home_page.dart';
import 'models.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
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
      home: const MainApp(),
    );
  }
}

// ---------------------------------------------------------------------------
// MainApp: StatefulWidget yang memegang SEMUA state utama aplikasi - daftar
// produk (dengan stok) dan isi keranjang. Diletakkan di sini, di atas
// HomePage & CartPage, supaya kedua halaman berbagi data yang sama. Ini
// persis pola "lifting state up" pada diagram Modul 4:
//
//   ElevatedButton -> onAddToCart -> HomePage -> MainApp.addToCart
//        -> setState() -> Stok dan Keranjang diperbarui
// ---------------------------------------------------------------------------
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Produk> products = List.of(daftarProdukAwal);
  List<ItemKeranjang> cart = [];

  int get jumlahItemKeranjang =>
      cart.fold(0, (total, item) => total + item.jumlah);

  int get grandTotal => cart.fold(0, (total, item) => total + item.subtotal);

  // Dipanggil dari tombol "Masukkan Keranjang" di HomePage (lewat
  // KartuProduk -> HomePage -> callback ini). Stok produk berkurang 1,
  // dan item ditambahkan/ditambah jumlahnya di keranjang.
  void tambahKeKeranjang(Produk produk) {
    final idxProduk = products.indexWhere((p) => p.id == produk.id);
    if (idxProduk == -1 || products[idxProduk].stock <= 0) return;

    setState(() {
      products[idxProduk] =
          products[idxProduk].copyWith(stock: products[idxProduk].stock - 1);

      final idxCart = cart.indexWhere((item) => item.produk.id == produk.id);
      if (idxCart == -1) {
        cart = [...cart, ItemKeranjang(produk: produk, jumlah: 1)];
      } else {
        cart[idxCart] =
            cart[idxCart].copyWith(jumlah: cart[idxCart].jumlah + 1);
      }
    });
  }

  // Dipanggil dari CartProductCard (lewat CartPage) saat jumlah di keranjang
  // diubah lewat TextField. Selisihnya dipakai untuk menyesuaikan stok.
  void ubahJumlah(String produkId, int jumlahBaru) {
    final idxCart = cart.indexWhere((item) => item.produk.id == produkId);
    final idxProduk = products.indexWhere((p) => p.id == produkId);
    if (idxCart == -1 || idxProduk == -1) return;

    final selisih = jumlahBaru - cart[idxCart].jumlah;
    // selisih positif = menambah (stok berkurang), negatif = mengurangi
    // (stok kembali). CartProductCard sudah membatasi lewat maxQuantity,
    // baris ini cuma jaga-jaga tambahan.
    if (selisih > 0 && products[idxProduk].stock < selisih) return;

    setState(() {
      products[idxProduk] = products[idxProduk]
          .copyWith(stock: products[idxProduk].stock - selisih);
      cart[idxCart] = cart[idxCart].copyWith(jumlah: jumlahBaru);
    });
  }

  // Dipanggil dari ikon hapus di CartProductCard: stok dikembalikan penuh,
  // item dibuang dari keranjang.
  void hapusDariKeranjang(String produkId) {
    final idxCart = cart.indexWhere((item) => item.produk.id == produkId);
    if (idxCart == -1) return;
    final item = cart[idxCart];
    final idxProduk = products.indexWhere((p) => p.id == produkId);

    setState(() {
      if (idxProduk != -1) {
        products[idxProduk] = products[idxProduk]
            .copyWith(stock: products[idxProduk].stock + item.jumlah);
      }
      cart = List.of(cart)..removeAt(idxCart);
    });
  }

  void bukaHalamanKeranjang(BuildContext context) {
    // Navigator.push membuka halaman baru (Modul 3).
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cart: cart,
          products: products,
          onQuantityChanged: ubahJumlah,
          onRemove: hapusDariKeranjang,
          onCheckout: () => checkout(context),
        ),
      ),
    );
  }

  void checkout(BuildContext context) {
    final total = grandTotal;
    setState(() {
      cart = [];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutSuccessPage(total: total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      products: products,
      jumlahKeranjang: jumlahItemKeranjang,
      onAddToCart: tambahKeKeranjang,
      onOpenCart: () => bukaHalamanKeranjang(context),
    );
  }
}