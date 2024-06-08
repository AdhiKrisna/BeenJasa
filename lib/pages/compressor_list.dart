import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kompressor/controller/kompressor_controller.dart';
import 'package:kompressor/routes/route_names.dart';

// ignore: must_be_immutable
class DaftarKompresor extends StatelessWidget {
  final KompressorController kompresorC = Get.put(KompressorController());
  final RxString selectedKompressor = ''.obs;
  final RxString statusServis = ''.obs;
  final RxString statusServisText = ''.obs;
  final RxBool isService = false.obs;

  DaftarKompresor({super.key});

  dynamic keyCompressor = '';
  @override
  Widget build(BuildContext context) {
    kompresorC.takeData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kompresor',
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
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //make some text field
          children: [
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                hint: const Text('Pilih Jenis Kompresor'),
                value: selectedKompressor.value.isEmpty
                    ? null
                    : selectedKompressor.value,
                items: kompresorC.allKompressor
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedKompressor.value = value ?? '';
                  cekServis();
                },
              ),
            ),
            const SizedBox(width: 20),
            Obx(
              () => Text(
                "Status Servis : $statusServisText",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: isService.value ? Colors.green : Colors.yellow[900],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(() {
              if (selectedKompressor.value.isEmpty) {
                return const SizedBox();
              }
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                value: statusServis.value,
                items: ['Sudah diservis', 'Belum diservis']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  statusServis.value = value ?? '';
                  print(statusServis.value);
                },
              );
            }),
            //button ubah
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 69, 108, 141),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  foregroundColor: Colors.white),
              onPressed: () {
                if (selectedKompressor.value.isEmpty) {
                  if (!Get.isSnackbarOpen) {
                    Get.snackbar(
                      'Peringatan',
                      'Pilih jenis kompresor terlebih dahulu',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1),
                    );
                  }
                } else {
                  Get.defaultDialog(
                    title: 'Konfirmasi',
                    middleText:
                        'Apakah anda yakin ingin mengganti status kompresor ?',
                    textConfirm: 'Ya',
                    textCancel: 'Tidak',
                    confirmTextColor: Colors.white,
                    buttonColor: const Color.fromARGB(255, 69, 108, 141),
                    cancelTextColor: Colors.red,
                    onConfirm: () {
                      print("STATUS SERVIS: ${statusServis.value}");
                      kompresorC.updateServis(keyCompressor, statusServis.value);
                      Get.snackbar(
                        'Berhasil',
                        'Status servis berhasil diubah',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1),
                      );
                      Get.offAllNamed(RouteName.home);
                    },
                  );
                }
              },
              child: const Text('Ubah Status Servis'),
            ),
          ],
        ),
      ),
    );
  }

  cekServis() {
    kompresorC.dataKompressor.forEach((key, value) {
      if (value['jenis'] == selectedKompressor.value) {
        isService.value = value['servis'];
        statusServis.value =
            isService.value ? 'Sudah diservis' : 'Belum diservis';
          statusServisText.value = statusServis.value;
        keyCompressor = key;
      }
    });
  }
}
