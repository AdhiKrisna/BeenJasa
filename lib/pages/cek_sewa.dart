import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kompressor/controller/cek_blacklist_controller.dart';

class CekSewa extends StatelessWidget {
  CekSewa({super.key});
  final TextEditingController nikPenyewa = TextEditingController();
  final CekBlacklistController cekBlacklistC = Get.put(CekBlacklistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'BeenJasa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 69, 108, 141),
          foregroundColor: Colors.white,
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'NIK Penyewa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'NIK Penyewa',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: nikPenyewa,
                    onChanged: (value) => cekBlacklistC.setNIKPenyewa(value),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 69, 108, 141),
                  ),
                  onPressed: () {
                    cekBlacklistC.setNIKPenyewa(nikPenyewa.text);
                    cekBlacklistC.cekBlacklist();
                  },
                  child: const Text(
                    'Cek Data Penyewa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
