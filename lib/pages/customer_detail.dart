import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPenyewa extends StatelessWidget {
  DetailPenyewa({super.key});
  final dynamic dataPenyewa = Get.arguments;
  @override
  Widget build(BuildContext context) {
    String nik = dataPenyewa['nik'];
    String nama = dataPenyewa['nama'];
    String alamat = dataPenyewa['alamat'];
    String noTelp = dataPenyewa['no_hp'];
    bool blackList = dataPenyewa['blacklist'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Penyewa',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "NIK : $nik",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            //make a loading animation while loading image
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.network(
                dataPenyewa['ktp'],
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Nama : $nama",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Alamat : $alamat",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Telp : $noTelp",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Status : ${blackList ? 'Blacklist' : 'Tidak Blacklist'}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackList ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 69, 108, 141),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
