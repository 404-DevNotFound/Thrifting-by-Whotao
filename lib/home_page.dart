import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

// ---------------------------------------------------------------------------
// Halaman Beranda
// StatefulWidget karena punya satu state lokal: kata kunci pencarian
// (searchQuery), diperbarui lewat setState setiap kali pengguna mengetik
// di KolomCari - persis contoh "State pada TextField" di Modul 4.
// Data produk & keranjang sendiri TIDAK disimpan di sini, melainkan di
// MainApp (lihat main.dart) lalu dikirim turun lewat constructor.
// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  final List<Produk> products;
  final int jumlahKeranjang;
  final ValueChanged<Produk> onAddToCart;
  final VoidCallback onOpenCart;

  const HomePage({
    super.key,
    required this.products,
    required this.jumlahKeranjang,
    required this.onAddToCart,
    required this.onOpenCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final produkTampil = widget.products.where((produk) {
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
                  for (final produk in produkTampil)
                    KartuProduk(
                      produk: produk,
                      onAddToCart: widget.onAddToCart,
                    ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBawah(
        activeIndex: 0,
        jumlahKeranjang: widget.jumlahKeranjang,
        onTap: (index) {
          // index 1 = Keranjang -> buka halaman baru lewat callback dari MainApp
          if (index == 1) {
            widget.onOpenCart();
          }
          // index 2 = Profil, belum ada halamannya
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card produk. Tombolnya sekarang ElevatedButton sungguhan (bukan sekadar
// Container yang digambar manual), supaya bisa memakai pola Modul 4:
// onPressed: produk.stock > 0 ? () => onAddToCart(produk) : null
// Saat null, Flutter otomatis menampilkannya abu-abu & tidak bisa ditekan.
// ---------------------------------------------------------------------------
class KartuProduk extends StatelessWidget {
  final Produk produk;
  final ValueChanged<Produk> onAddToCart;

  const KartuProduk({
    super.key,
    required this.produk,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final habis = produk.stock <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FotoProduk(produk: produk, ukuran: 36, tampilkanLabelHabis: habis),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produk.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kInk,
                          ),
                        ),
                        Text(
                          formatRupiah(produk.harga),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: kInk,
                          ),
                        ),
                        if (habis)
                          const Text(
                            'Stok Habis',
                            style: TextStyle(
                              fontSize: 8,
                              color: kAlert,
                            ),
                          )
                        else
                          Text(
                            'Stok: ${produk.stock}',
                            style: const TextStyle(
                              fontSize: 8,
                              color: kMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 118,
                    height: 22,
                    child: ElevatedButton(
                      onPressed: produk.stock > 0
                          ? () => onAddToCart(produk)
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
                      child: const Text(
                        'Masukkan Keranjang',
                        style: TextStyle(fontSize: 8.5),
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
