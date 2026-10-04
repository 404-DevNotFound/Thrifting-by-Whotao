import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

// ---------------------------------------------------------------------------
// Halaman Keranjang (Cart Page)
// StatelessWidget: halaman ini sendiri tidak punya state, cuma menampilkan
// data `cart`/`products` yang dikirim dari MainApp dan meneruskan sentuhan
// pengguna lewat callback (onQuantityChanged, onRemove, onCheckout).
// ---------------------------------------------------------------------------
class CartPage extends StatelessWidget {
  final List<ItemKeranjang> cart;
  final List<Produk> products;
  final void Function(String produkId, int jumlahBaru) onQuantityChanged;
  final void Function(String produkId) onRemove;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.products,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onCheckout,
  });

  int get grandTotal => cart.fold(0, (total, item) => total + item.subtotal);

  // Batas atas yang boleh diketik di TextField jumlah: stok produk yang
  // masih tersisa + jumlah yang sudah ada di keranjang untuk produk itu.
  int _stokMaksimum(ItemKeranjang item) {
    final produkAsli = products.firstWhere(
      (p) => p.id == item.produk.id,
      orElse: () => item.produk,
    );
    return produkAsli.stock + item.jumlah;
  }

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
          // dengan menghapus CartPage dari navigation stack (Modul 3).
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
      // Stack menumpuk daftar item (belakang) dengan bar total mengambang
      // di bawah (depan) - sama seperti di Modul 3.
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                child: cart.isEmpty
                    ? const _KeranjangKosong()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const KolomCari(), // dekoratif, mengikuti mockup
                            const SizedBox(height: 16),
                            for (final item in cart)
                              CartProductCard(
                                // ValueKey memastikan Flutter tidak menukar
                                // TextEditingController antar kartu saat urutan
                                // list berubah (mis. ada item yang dihapus).
                                key: ValueKey(item.produk.id),
                                produk: item.produk,
                                quantity: item.jumlah,
                                maxQuantity: _stokMaksimum(item),
                                onQuantityChanged: (jumlahBaru) =>
                                    onQuantityChanged(
                                        item.produk.id, jumlahBaru),
                                onRemove: () => onRemove(item.produk.id),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BarTotal(total: grandTotal, onCheckout: onCheckout),
          ),
        ],
      ),
      bottomNavigationBar: NavBawah(
        activeIndex: 1,
        jumlahKeranjang: cart.fold(0, (total, item) => total + item.jumlah),
        onTap: (index) {
          // index 0 = Beranda -> kembali ke HomePage dengan Navigator.pop
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class _KeranjangKosong extends StatelessWidget {
  const _KeranjangKosong();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.shopping_cart_outlined, size: 40, color: kMuted),
          SizedBox(height: 12),
          Text('Keranjang masih kosong', style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Satu baris item keranjang.
// StatefulWidget karena punya TextEditingController sendiri, persis contoh
// "State pada Input Jumlah di CartProductCard" di Modul 4 (initState,
// didUpdateWidget, dan updateQuantity ditulis sama seperti di modul).
// ---------------------------------------------------------------------------
class CartProductCard extends StatefulWidget {
  final Produk produk;
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartProductCard({
    super.key,
    required this.produk,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    // Dipanggil sekali saja saat kartu ini pertama kali dibuat.
    quantityController = TextEditingController(text: '${widget.quantity}');
  }

  @override
  void didUpdateWidget(covariant CartProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Dipanggil setiap kali CartPage membangun ulang kartu ini dengan
    // quantity baru (misalnya produk yang sama ditambah lagi dari
    // HomePage). Teks di TextField hanya ditimpa kalau benar-benar
    // berbeda, supaya tidak mengganggu saat pengguna sedang mengetik.
    if (oldWidget.quantity != widget.quantity &&
        quantityController.text != '${widget.quantity}') {
      quantityController.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    // Bukan dari Modul 4, tapi praktik standar Flutter: controller wajib
    // di-dispose supaya tidak membebani memori saat kartu dibuang dari tree.
    quantityController.dispose();
    super.dispose();
  }

  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1) return;
    widget.onQuantityChanged(parsed.clamp(1, widget.maxQuantity));
  }

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
          FotoProduk(produk: widget.produk, ukuran: 80),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.produk.nama,
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
                  widget.produk.deskripsi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: kMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(widget.produk.harga),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField dengan pembatasan input: hanya boleh angka.
              // keyboardType.number memunculkan keypad angka,
              // inputFormatters memblokir karakter selain digit
              // walaupun pengguna memakai keyboard fisik/eksternal.
              SizedBox(
                width: 50,
                child: TextField(
                  controller: quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: updateQuantity,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: kBorder),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: widget.onRemove,
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: kMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bar total + tombol checkout, mengambang di bawah dengan BoxShadow
// persis contoh BoxShadow di Modul 3 (offset negatif = bayangan ke arah
// atas, karena bar ini menempel di dasar layar).
// ---------------------------------------------------------------------------
class BarTotal extends StatelessWidget {
  final int total;
  final VoidCallback onCheckout;

  const BarTotal({super.key, required this.total, required this.onCheckout});

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total', style: TextStyle(fontSize: 12, color: kMuted)),
                Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kInk,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              // State pada ElevatedButton (Modul 4, hal. 2): tombol checkout
              // hanya aktif kalau total > 0 - "state turunan" dari isi
              // keranjang, bukan flag isEnabled yang berdiri sendiri.
              onPressed: total > 0 ? onCheckout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kInk,
                disabledBackgroundColor: kBorder,
                foregroundColor: Colors.white,
                disabledForegroundColor: kMuted,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart, size: 16),
                  SizedBox(width: 8),
                  Text('Checkout', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}