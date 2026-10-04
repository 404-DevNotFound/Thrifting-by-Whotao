import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

// ---------------------------------------------------------------------------
// TextField + Icon + Padding
// onChanged bersifat opsional: di HomePage dipakai untuk mencari produk,
// di CartPage dibiarkan kosong (cuma dekoratif, mengikuti tampilan mockup).
// ---------------------------------------------------------------------------
class KolomCari extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const KolomCari({
    super.key,
    this.onChanged,
    this.hintText = 'Cari baju thrift',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
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
      height: 40,
      padding: const EdgeInsets.all(4),
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
// Foto produk: Image + Stack + Positioned (label diskon & label habis)
// Dipakai bersama oleh HomePage dan CartPage.
// ---------------------------------------------------------------------------
class FotoProduk extends StatelessWidget {
  final Produk produk;
  final double ukuran;
  final bool tampilkanLabelHabis;

  const FotoProduk({
    super.key,
    required this.produk,
    this.ukuran = 110,
    this.tampilkanLabelHabis = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      // Stack menumpuk foto produk (belakang) dengan label diskon/habis (depan).
      child: Stack(
        children: [
          // Image.asset menampilkan gambar dari folder assets/products.
          // errorBuilder jadi jaring pengaman: kalau file gambar belum
          // ditambahkan ke pubspec.yaml, tampilan tetap rapi (kotak warna + ikon)
          // alih-alih aplikasi crash.
          Image.asset(
            produk.asset,
            width: ukuran,
            height: ukuran,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: ukuran,
              height: ukuran,
              color: produk.warna,
              alignment: Alignment.center,
              child: Icon(
                Icons.checkroom,
                size: ukuran * 0.4,
                color: Colors.white,
                semanticLabel: 'Foto ${produk.nama}',
              ),
            ),
          ),
          // Positioned menempatkan label "Diskon" di pojok kiri atas foto.
          if (produk.diskon)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                color: kAlert,
                child: const Text(
                  'Diskon',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Overlay gelap + teks "Habis" kalau stock produk sudah 0.
          // Dibungkus Positioned.fill supaya menutupi seluruh area foto.
          if (tampilkanLabelHabis)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: const Text(
                  'Habis',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigasi bawah: Container + SafeArea + Padding + Row + Expanded
// Dipakai bersama oleh HomePage, CartPage, dan CheckoutSuccessPage.
// jumlahKeranjang menampilkan badge kecil di atas ikon "Keranjang".
// ---------------------------------------------------------------------------
class NavBawah extends StatelessWidget {
  final int activeIndex;
  final int jumlahKeranjang;
  final ValueChanged<int> onTap;

  const NavBawah({
    super.key,
    required this.activeIndex,
    this.jumlahKeranjang = 0,
    required this.onTap,
  });

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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  key: const Key('nav_beranda'),
                  onTap: () => onTap(0),
                  child: ItemNav(
                    icon: Icons.home,
                    label: 'Beranda',
                    aktif: activeIndex == 0,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  key: const Key('nav_keranjang'),
                  onTap: () => onTap(1),
                  child: ItemNav(
                    icon: Icons.shopping_cart,
                    label: 'Keranjang',
                    aktif: activeIndex == 1,
                    jumlahBadge: jumlahKeranjang,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  key: const Key('nav_profil'),
                  onTap: () => onTap(2),
                  child: ItemNav(
                    icon: Icons.person,
                    label: 'Profil',
                    aktif: activeIndex == 2,
                  ),
                ),
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
  final int jumlahBadge;

  const ItemNav({
    super.key,
    required this.icon,
    required this.label,
    this.aktif = false,
    this.jumlahBadge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? kInk : kMuted;

    return Column(
      // min: kalau tidak, Column akan meninggikan diri sampai penuh layar
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stack + Positioned dipakai lagi di sini untuk menaruh badge jumlah
        // keranjang di pojok kanan atas ikon.
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 24, color: warna),
            if (jumlahBadge > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: kAlert,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$jumlahBadge',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
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
