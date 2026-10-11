import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'cart_provider.dart';
import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

// ---------------------------------------------------------------------------
// Halaman Beranda
// Tetap StatefulWidget, tapi sekarang HANYA untuk satu state lokal: kata
// kunci pencarian (searchQuery). Ini sengaja TIDAK dipindah ke CartProvider,
// karena cuma dipakai di halaman ini saja - bukan data yang perlu dibagi ke
// halaman lain. Data produk & keranjang diambil dari CartProvider.
// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // context.watch<CartProvider>() membuat HomePage otomatis dibangun
    // ulang setiap kali CartProvider memanggil notifyListeners() (misalnya
    // stok produk berubah karena ditambah dari halaman lain). Ini
    // menggantikan cara lama: data dikirim lewat constructor dari MainApp.
    final cartProvider = context.watch<CartProvider>();
    final produkTampil = cartProvider.products.where((produk) {
      return produk.nama.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: kPaper,
      appBar: AppBar(
        backgroundColor: kPaper,
        scrolledUnderElevation: 0,
        title: const Text(
          'Lapak Thrift',
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
                KolomCari(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
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

                if (produkTampil.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(color: kMuted),
                      ),
                    ),
                  )
                else
                  for (final produk in produkTampil) KartuProduk(produk: produk),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBawah(
        activeIndex: 0,
        jumlahKeranjang: cartProvider.jumlahItemKeranjang,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card produk. Tombolnya ElevatedButton, mengikuti pola Modul 4:
// onPressed: produk.stock > 0 ? () => ... : null
// Bedanya dari versi sebelumnya: tidak lagi menerima callback onAddToCart
// lewat constructor - langsung memanggil context.read<CartProvider>() saat
// ditekan.
// ---------------------------------------------------------------------------
class KartuProduk extends StatelessWidget {
  final Produk produk;

  const KartuProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final habis = produk.stock <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 128,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FotoProduk(produk: produk, ukuran: 110, tampilkanLabelHabis: habis),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(produk.harga),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                      Text(
                        habis ? 'Stok habis' : 'Stok: ${produk.stock}',
                        style: TextStyle(
                          fontSize: 10,
                          color: habis ? kAlert : kMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      // State pada ElevatedButton (Modul 4, hal. 2):
                      // onPressed bernilai null saat stok habis -> tombol
                      // otomatis nonaktif.
                      //
                      // context.read<CartProvider>() dipakai (bukan watch)
                      // karena ini di dalam callback, bukan di build():
                      // read tidak membuat widget ini ikut "berlangganan"
                      // perubahan, cukup mengambil instance-nya sekali saat
                      // ditekan.
                      onPressed: produk.stock > 0
                          ? () => context
                              .read<CartProvider>()
                              .tambahKeKeranjang(produk)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kInk,
                        disabledBackgroundColor: kBorder,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: kMuted,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_cart, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            habis ? 'Stok Habis' : 'Masukkan Keranjang',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
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