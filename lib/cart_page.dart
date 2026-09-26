import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

// ---------------------------------------------------------------------------
// Halaman Keranjang (Cart Page)
// Studi kasus Modul 3: slicing Cart Page + navigasi antar halaman.
// Dibuka lewat Navigator.push dari HomePage, dan kembali lewat Navigator.pop.
// ---------------------------------------------------------------------------
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaper,
      appBar: AppBar(
        backgroundColor: kPaper,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kInk),
          // Navigator.pop mengembalikan ke halaman sebelumnya (HomePage)
          // dengan menghapus CartPage dari navigation stack.
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kInk,
          ),
        ),
      ),
      // Stack menumpuk daftar produk (di belakang) dengan bar total & checkout
      // yang mengambang di bawah (di depan).
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                // Padding bawah 90 memberi ruang supaya item terakhir tidak
                // tertutup oleh BarTotal yang mengambang.
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const KolomCari(),
                      const SizedBox(height: 16),
                      for (final produk in daftarProduk)
                        KartuKeranjang(produk: produk),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Positioned menempelkan BarTotal ke sisi kiri, kanan, dan bawah Stack.
          const Positioned(left: 0, right: 0, bottom: 0, child: BarTotal()),
        ],
      ),
      bottomNavigationBar: NavBawah(
        activeIndex: 1,
        onTap: (index) {
          // index 0 = Beranda -> kembali ke HomePage dengan Navigator.pop
          if (index == 0) {
            Navigator.pop(context);
          }
          // index 1 = Keranjang (sudah di halaman ini)
          // index 2 = Profil, belum ada halamannya
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Satu baris item keranjang: foto produk + info + input jumlah (angka saja)
// ---------------------------------------------------------------------------
class KartuKeranjang extends StatelessWidget {
  final Produk produk;

  const KartuKeranjang({super.key, required this.produk});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FotoProduk(produk: produk, ukuran: 80),
          const SizedBox(width: 12),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const InputJumlah(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TextField dengan pembatasan input: hanya boleh angka.
// keyboardType.number memunculkan keypad angka, inputFormatters memblokir
// karakter selain digit meskipun pengguna memakai keyboard fisik/eksternal.
// ---------------------------------------------------------------------------
class InputJumlah extends StatelessWidget {
  const InputJumlah({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: '1'),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: kBorder),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bar total + tombol checkout, mengambang di bawah dengan BoxShadow
// persis seperti contoh BoxShadow pada Modul 3 (offset negatif = bayangan
// ke arah atas, karena bar ini menempel di dasar layar).
// ---------------------------------------------------------------------------
class BarTotal extends StatelessWidget {
  const BarTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total', style: TextStyle(fontSize: 12, color: kMuted)),
                Text(
                  'Rp12.000.000',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: kInk,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Masukkan Keranjang',
                    style: TextStyle(fontSize: 12, color: Colors.white),
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