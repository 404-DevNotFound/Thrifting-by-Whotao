import 'package:flutter/material.dart';

import 'models.dart';

class CartProvider extends ChangeNotifier {
  List<Produk> _products = List.of(daftarProdukAwal);
  List<ItemKeranjang> _cart = [];

  // Getter read-only (List.unmodifiable) supaya widget di luar class ini
  // tidak bisa mengubah list secara langsung tanpa lewat notifyListeners().
  List<Produk> get products => List.unmodifiable(_products);
  List<ItemKeranjang> get cart => List.unmodifiable(_cart);

  int get jumlahItemKeranjang =>
      _cart.fold(0, (total, item) => total + item.jumlah);

  int get grandTotal => _cart.fold(0, (total, item) => total + item.subtotal);

  // Dipanggil dari tombol "Masukkan Keranjang" di KartuProduk.
  void tambahKeKeranjang(Produk produk) {
    final idxProduk = _products.indexWhere((p) => p.id == produk.id);
    if (idxProduk == -1 || _products[idxProduk].stock <= 0) return;

    _products[idxProduk] =
        _products[idxProduk].copyWith(stock: _products[idxProduk].stock - 1);

    final idxCart = _cart.indexWhere((item) => item.produk.id == produk.id);
    if (idxCart == -1) {
      _cart = [..._cart, ItemKeranjang(produk: produk, jumlah: 1)];
    } else {
      _cart[idxCart] =
          _cart[idxCart].copyWith(jumlah: _cart[idxCart].jumlah + 1);
    }

    notifyListeners();
  }

  // Dipanggil dari CartProductCard saat jumlah di keranjang diubah lewat
  // TextField (lihat updateQuantity di cart_page.dart).
  void ubahJumlah(String produkId, int jumlahBaru) {
    final idxCart = _cart.indexWhere((item) => item.produk.id == produkId);
    final idxProduk = _products.indexWhere((p) => p.id == produkId);
    if (idxCart == -1 || idxProduk == -1) return;

    final selisih = jumlahBaru - _cart[idxCart].jumlah;
    // selisih positif = menambah (stok berkurang), negatif = mengurangi
    // (stok kembali). CartProductCard sudah membatasi lewat maxQuantity,
    // baris ini cuma jaga-jaga tambahan.
    if (selisih > 0 && _products[idxProduk].stock < selisih) return;

    _products[idxProduk] = _products[idxProduk]
        .copyWith(stock: _products[idxProduk].stock - selisih);
    _cart[idxCart] = _cart[idxCart].copyWith(jumlah: jumlahBaru);

    notifyListeners();
  }

  // Dipanggil dari ikon hapus di CartProductCard: stok dikembalikan penuh,
  // item dibuang dari keranjang.
  void hapusDariKeranjang(String produkId) {
    final idxCart = _cart.indexWhere((item) => item.produk.id == produkId);
    if (idxCart == -1) return;
    final item = _cart[idxCart];
    final idxProduk = _products.indexWhere((p) => p.id == produkId);

    if (idxProduk != -1) {
      _products[idxProduk] = _products[idxProduk]
          .copyWith(stock: _products[idxProduk].stock + item.jumlah);
    }
    _cart = List.of(_cart)..removeAt(idxCart);

    notifyListeners();
  }

  // Dipanggil dari tombol "Checkout" di BarTotal. Mengosongkan keranjang
  // dan mengembalikan grand total supaya bisa ditampilkan di
  // CheckoutSuccessPage (navigasinya tetap dilakukan di CartPage, bukan
  // di sini, karena provider tidak punya BuildContext untuk Navigator).
  int checkout() {
    final total = grandTotal;
    _cart = [];
    notifyListeners();
    return total;
  }
}