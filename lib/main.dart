import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
// Palet warna: nuansa denim dan kain washed khas baju thrift
// ---------------------------------------------------------------------------
const Color kInk = Color(0xFF1F2A37); // teks utama & tombol
const Color kDenim = Color(0xFF2F4B7C); // warna tema / banner
const Color kPaper = Color(0xFFF4F6F8); // background halaman
const Color kBorder = Color(0xFFDDE2E8); // garis tepi card
const Color kMuted = Color(0xFF8A94A0); // teks sekunder

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------
class Produk {
  final String nama;
  final String deskripsi;
  final String harga;
  final String gambar;
  final Color warna; // warna placeholder foto produk

  const Produk({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.warna,
  });
}

const List<String> daftarKategori = [
  'Semua',
  'Kemeja',
  'Jaket',
  'Kaos',
  'Celana',
  'Hoodie',
];

const List<Produk> daftarProduk = [
  Produk(
    nama: 'Kemeja Flanel Kotak',
    deskripsi: 'Size L, kondisi 9/10',
    harga: 'Rp65.000',
    gambar: 'image/bajuflanel.jpeg',
    warna: Color(0xFFC9B79C),
  ),
  Produk(
    nama: 'Jaket Denim Oversize',
    deskripsi: 'Size XL, kondisi 8/10',
    harga: 'Rp185.000',
    gambar: 'image/jaketdenim.jpg',
    warna: Color(0xFF9DB4C9),
  ),
  Produk(
    nama: 'Kaos Band Vintage 90an',
    deskripsi: 'Size M, kondisi 8/10',
    harga: 'Rp95.000',
    gambar: 'image/kaosband.jpg',
    warna: Color(0xFFB98E86),
  ),
  Produk(
    nama: 'Celana Cargo Baggy',
    deskripsi: 'Size 32, kondisi 9/10',
    harga: 'Rp120.000',
    gambar: 'image/celanacargo.jpeg',
    warna: Color(0xFF8FA58E),
  ),
  Produk(
    nama: 'Hoodie Crewneck Polos',
    deskripsi: 'Size L, kondisi 9/10',
    harga: 'Rp110.000',
    gambar: 'image/hoodiecrewneck.jpeg',
    warna: Color(0xFF7E8AA6),
  ),
];

// ---------------------------------------------------------------------------
// MaterialApp
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrifting by Whotao',
      theme: ThemeData(
        // Font 'Inter' dari modul. Kalau font belum didaftarkan di pubspec.yaml,
        // Flutter otomatis memakai font bawaan (tidak error).
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: kDenim),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Halaman Beranda
// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaper,
      appBar: AppBar(
        backgroundColor: kPaper,
        scrolledUnderElevation: 0,
        title: const Text(
          'Thrifting by Whotao',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kInk,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const KolomCari(),
                const SizedBox(height: 16),
                const BannerPromo(),
                const SizedBox(height: 16),

                // Kategori: scroll ke samping
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final kategori in daftarKategori)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: KategoriChip(
                            label: kategori,
                            aktif: kategori == 'Semua',
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Judul bagian
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Baru masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kInk,
                      ),
                    ),
                    Text(
                      'Lihat semua',
                      style: TextStyle(fontSize: 12, color: kMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Daftar produk
                for (final produk in daftarProduk) KartuProduk(produk: produk),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBawah(),
    );
  }
}

// ---------------------------------------------------------------------------
// TextField + Icon + Padding
// ---------------------------------------------------------------------------
class KolomCari extends StatelessWidget {
  const KolomCari({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari baju thrift',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.search,
            size: 24,
            color: Colors.grey.shade400,
            semanticLabel: 'Cari',
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kDenim),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Banner promo: Container + Column (MainAxisAlignment.end)
// ---------------------------------------------------------------------------
class BannerPromo extends StatelessWidget {
  const BannerPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kDenim,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.local_offer, size: 16, color: Color(0xFFF2C94C)),
              SizedBox(width: 6),
              Text(
                'Thrift sale minggu ini',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Diskon hingga 50%',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chip kategori: Container + BoxDecoration + Text
// ---------------------------------------------------------------------------
class KategoriChip extends StatelessWidget {
  final String label;
  final bool aktif;

  const KategoriChip({super.key, required this.label, this.aktif = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: aktif ? kInk : Colors.white,
        border: Border.all(color: aktif ? kInk : kBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: aktif ? Colors.white : kInk,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card produk: Container, SizedBox, Row, Expanded, Column, Text, Icon
// ---------------------------------------------------------------------------
class KartuProduk extends StatelessWidget {
  final Produk produk;

  const KartuProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      // SizedBox dipakai sebagai "container" bertinggi tetap supaya
      // spaceBetween di Column sebelah kanan bekerja.
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto produk
            Container(
              width: 110,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: produk.warna,
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                produk.gambar,
                width: 110,
                height: 120,
                fit: BoxFit.cover,
                semanticLabel: 'Foto ${produk.nama}',
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.checkroom,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info produk mengisi sisa lebar
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kInk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        produk.deskripsi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: kMuted),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        produk.harga,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                    ],
                  ),

                  // Tombol "Masukkan Keranjang"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: kInk,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Masukkan Keranjang',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigasi bawah: Container + SafeArea + Padding + Row + Expanded
// ---------------------------------------------------------------------------
class NavBawah extends StatelessWidget {
  const NavBawah({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ItemNav(icon: Icons.home, label: 'Beranda', aktif: true),
              ),
              Expanded(
                child: ItemNav(icon: Icons.shopping_cart, label: 'Keranjang'),
              ),
              Expanded(
                child: ItemNav(icon: Icons.person, label: 'Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool aktif;

  const ItemNav({
    super.key,
    required this.icon,
    required this.label,
    this.aktif = false,
  });

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? kInk : kMuted;

    return Column(
      // min: kalau tidak, Column akan meninggikan diri sampai penuh layar
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: warna),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: aktif ? FontWeight.w600 : FontWeight.w400,
            color: warna,
          ),
        ),
      ],
    );
  }
}