import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Produk: sekarang punya `id` (buat mencari produk yang sama) dan `stock`
// (jumlah barang yang masih bisa dibeli). Keduanya dibutuhkan supaya
// MainApp bisa mengelola state keranjang & stok (lihat main.dart).
// ---------------------------------------------------------------------------
class Produk {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga; // dalam rupiah, misalnya 65000
  final Color warna; // fallback kalau Image.asset gagal dimuat
  final String asset;
  final bool diskon;
  final int stock;

  const Produk({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.warna,
    required this.asset,
    this.diskon = false,
    required this.stock,
  });

  // copyWith supaya gampang bikin salinan Produk dengan stock baru tanpa
  // menulis ulang semua field. Produk tetap immutable (field final);
  // yang berubah adalah OBJEK-nya diganti baru, bukan field-nya ditimpa.
  Produk copyWith({int? stock}) {
    return Produk(
      id: id,
      nama: nama,
      deskripsi: deskripsi,
      harga: harga,
      warna: warna,
      asset: asset,
      diskon: diskon,
      stock: stock ?? this.stock,
    );
  }
}

// ---------------------------------------------------------------------------
// Satu baris di keranjang: produk + berapa banyak diambil.
// ---------------------------------------------------------------------------
class ItemKeranjang {
  final Produk produk;
  final int jumlah;

  const ItemKeranjang({required this.produk, required this.jumlah});

  ItemKeranjang copyWith({int? jumlah}) {
    return ItemKeranjang(produk: produk, jumlah: jumlah ?? this.jumlah);
  }

  int get subtotal => produk.harga * jumlah;
}

const List<String> daftarKategori = [
  'Semua',
  'Kemeja',
  'Jaket',
  'Kaos',
  'Celana',
  'Hoodie',
];

// Data awal. Disalin ke List biasa (bukan dipakai langsung sebagai const)
// di MainApp supaya stock-nya bisa berubah seiring interaksi pengguna.
const List<Produk> daftarProdukAwal = [
  Produk(
    id: 'kemeja',
    nama: 'Kemeja Flanel Kotak',
    deskripsi: 'Size L, kondisi 9/10',
    harga: 65000,
    warna: Color(0xFFC9B79C),
    asset: 'image/bajuflanel.jpeg',
    stock: 5,
  ),
  Produk(
    id: 'jaket',
    nama: 'Jaket Denim Oversize',
    deskripsi: 'Size XL, kondisi 8/10',
    harga: 185000,
    warna: Color(0xFF9DB4C9),
    asset: 'image/jaketdenim.jpg',
    diskon: true,
    stock: 3,
  ),
  Produk(
    id: 'kaos',
    nama: 'Kaos Band Vintage 90an',
    deskripsi: 'Size M, kondisi 8/10',
    harga: 95000,
    warna: Color(0xFFB98E86),
    asset: 'image/kaosband.jpg',
    stock: 4,
  ),
  Produk(
    id: 'celana',
    nama: 'Celana Cargo Baggy',
    deskripsi: 'Size 32, kondisi 9/10',
    harga: 120000,
    warna: Color(0xFF8FA58E),
    asset: 'image/celanacargo.jpeg',
    stock: 6,
  ),
  Produk(
    id: 'hoodie',
    nama: 'Hoodie Crewneck Polos',
    deskripsi: 'Size L, kondisi 9/10',
    harga: 110000,
    warna: Color(0xFF7E8AA6),
    asset: 'image/hoodiecrewneck.jpeg',
    stock: 2,
  ),
];

// Format angka ke "Rp185.000". Pakai RegExp bawaan Dart (bukan paket intl),
// supaya tidak perlu menambah dependency baru di pubspec.yaml.
String formatRupiah(int angka) {
  final str = angka.toString();
  final withDots = str.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );
  return 'Rp$withDots';
}
