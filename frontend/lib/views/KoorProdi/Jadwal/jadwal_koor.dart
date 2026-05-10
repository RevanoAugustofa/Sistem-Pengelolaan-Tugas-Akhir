import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'jadwal_bimbingan.dart';
import 'jadwal_proposal.dart';
import 'jadwal_sidang.dart';

class JadwalKoorPage extends StatefulWidget {
  const JadwalKoorPage({super.key});

  @override
  State<JadwalKoorPage> createState() => _JadwalKoorPageState();
}

class _JadwalKoorPageState extends State<JadwalKoorPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedTab = "Bimbingan";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 149, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Jadwal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // TAB BAR
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF7E89AC),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTabItem("Bimbingan"),
                _buildTabItem("Proposal"),
                _buildTabItem("Sidang"),
              ],
            ),
          ),

          // 1. Search Bar
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Container(
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(8),
          //       border: Border.all(color: Colors.grey.shade400),
          //     ),
          //     child: TextField(
          //       controller: searchController,
          //       onChanged: (value) {
          //         setState(() {
          //           searchQuery = value;
          //         });
          //       },
          //       decoration: const InputDecoration(
          //         hintText: "Cari Mahasiswa",
          //         hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          //         suffixIcon: Icon(Icons.tune, color: Colors.blue),
          //         contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),

          // const Padding(
          //   padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       "Filter - All",
          //       style: TextStyle(color: Colors.grey, fontSize: 13),
          //     ),
          //   ),
          // ),

          // TABLE AREA
          Expanded(
            child: buildTable(),
          ),
        ],
      ),
    );
  }

  // TAB BUTTON
  Widget _buildTabItem(String title) {
    bool isActive = selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E3475) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // SWITCH TABLE
  Widget buildTable() {
    if (selectedTab == "Bimbingan") {
      return const BimbinganTable();
    } else if (selectedTab == "Proposal") {
      return const ProposalTable();
    } else {
      return const SidangTable();
    }
  }
}
