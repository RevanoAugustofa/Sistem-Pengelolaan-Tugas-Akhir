import 'package:flutter/material.dart';

class JadwalSemproList extends StatelessWidget {
  const JadwalSemproList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3, 
      itemBuilder: (context, index) {
        return _buildJadwalCard("Revano Augustofa", "Jum'at 20, Februari 2026", "08.30.00 - 09.45.00 WIB");
      },
    );
  }

  Widget _buildJadwalCard(String nama, String tanggal, String jam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nama,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF283D70), fontSize: 15),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
              Text(tanggal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              Text(jam, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
