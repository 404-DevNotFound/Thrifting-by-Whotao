import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

// ---------------------------------------------------------------------------
// Halaman ketiga dari studi kasus Modul 3 & 4: konfirmasi checkout berhasil.
// StatelessWidget - cuma menampilkan `total` yang dikirim dari MainApp,
// tidak menyimpan state apa pun sendiri.
// ---------------------------------------------------------------------------
class CheckoutSuccessPage extends StatelessWidget {
  final int total;

  const CheckoutSuccessPage({super.key, required this.total});

  void _kembaliKeBeranda(BuildContext context) {
    // popUntil membuang semua halaman di atas rute pertama (HomePage)
    // sekaligus, supaya pengguna tidak balik ke Cart Page yang sudah
    // kosong setelah checkout. Ini perluasan dari Navigator.pop polos
    // yang diajarkan di Modul 3 (yang cuma membuang satu halaman).
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaper,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: kInk,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              const Text('Total', style: TextStyle(fontSize: 13, color: kMuted)),
              const SizedBox(height: 4),
              Text(
                formatRupiah(total),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _kembaliKeBeranda(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kInk,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Kembali'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBawah(
        activeIndex: 1,
        onTap: (index) {
          if (index == 0) _kembaliKeBeranda(context);
        },
      ),
    );
  }
}