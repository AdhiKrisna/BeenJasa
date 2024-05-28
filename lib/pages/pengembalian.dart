import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kompressor/controller/pengembalian_controller.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Pengembalian extends StatelessWidget {
  Pengembalian({super.key});

  final PengembalianController pengembalianC = Get.put(PengembalianController());
  final RxString jenisKompressor = ''.obs;
  final TextEditingController tanggalKembali = TextEditingController();
  final RxInt harga = 0.obs, totalHarga = 0.obs;
  final RxString namaPenyewa = ''.obs;
  dynamic keyCompressor = '';

  Future <void> onInit() async {
    await pengembalianC.cekUnavailable();
    print('Unavailable Kompressors: ${pengembalianC.unAvailableKompressor.length}');

  }

  @override
  Widget build(BuildContext context) {
    onInit();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'Jenis Kompresor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () {
                        if (pengembalianC.unAvailableKompressor.isEmpty) {
                          return const Text('Belum ada kompresor yang disewa');
                        } else {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            hint: const Text('Pilih Jenis Kompresor'),
                            value: jenisKompressor.value.isEmpty
                                ? null
                                : jenisKompressor.value,
                            items: pengembalianC.unAvailableKompressor
                                .map((jenis) => DropdownMenuItem(
                                      value: jenis,
                                      child: Text(jenis),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              jenisKompressor.value = value ?? '';
                              print(jenisKompressor.value);
                              cekHarga();
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tanggal Kembali',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: tanggalKembali,
                      readOnly: true,
                      onTap: () async {
                        await selectDate(context);
                        cekHarga();
                      },
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Tanggal Kembali',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Text(
                          "Nama Penyewa : $namaPenyewa",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: Colors.green,
                          ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => Text(
                          "Total Harga Sewa : Rp. $totalHarga",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: Colors.green,
                          ),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      //2 button, 1 untuk lunas dan 1 untuk kembali
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: const Text('Kembali tidak lunas'),
                          onPressed: () {
                            if (jenisKompressor.value.isEmpty) {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar(
                                  'Peringatan',
                                  'Pilih jenis kompresor yang ingin dikembalikan terlebih dahulu',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 1),
                                );
                              }
                            } else if (tanggalKembali.text.isEmpty) {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar(
                                  'Peringatan',
                                  'Pilih tanggal pengembalian terlebih dahulu',
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
                                    'Apakah anda yakin ingin kompresor sudah kembali?',
                                textConfirm: 'Ya',
                                textCancel: 'Tidak',
                                confirmTextColor: Colors.white,
                                buttonColor:
                                    const Color.fromARGB(255, 69, 108, 141),
                                cancelTextColor: Colors.red,
                                onConfirm: () {
                                  pengembalianC.kembaliNgutang(
                                    keyCompressor,
                                    jenisKompressor.value,
                                    tanggalKembali.text,
                                  );
                                  // Get.toNamed(RouteName.home);
                                },
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Kembali lunas'),
                          onPressed: () {
                            if (jenisKompressor.value.isEmpty) {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar(
                                  'Peringatan',
                                  'Pilih jenis kompresor yang ingin dikembalikan terlebih dahulu',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 1),
                                );
                              }
                            } else if (tanggalKembali.text.isEmpty) {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar(
                                  'Peringatan',
                                  'Pilih tanggal pengembalian terlebih dahulu',
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
                                    'Apakah anda yakin ingin kompresor sudah kembali dan sudah lunas ?',
                                textConfirm: 'Ya',
                                textCancel: 'Tidak',
                                confirmTextColor: Colors.white,
                                buttonColor:
                                    const Color.fromARGB(255, 69, 108, 141),
                                cancelTextColor: Colors.red,
                                onConfirm: () {
                                  pengembalianC.kembaliLunas(
                                    keyCompressor,
                                    jenisKompressor.value,
                                    tanggalKembali.text,
                                  );
                                  // Get.toNamed(RouteName.home);
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future cekHarga() async {

    //ambil harga dari database kompresor
    try {
      await pengembalianC.takeData();
      pengembalianC.dataKompressor.forEach((key, value) {
        if (value['jenis'] == jenisKompressor.value) {
          harga.value = value['biaya'];
          keyCompressor = key;
        }
      });
    } catch (error) {
      print(error);
    }
    //cek lama sewa
    try {
      Uri uriTrans;
      if (jenisKompressor.value.isEmpty || tanggalKembali.text.isEmpty)
        return; //cek jenis kompresor kosong atau tidak
      else {
        uriTrans = Uri.parse(
            "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Transaksi.json");
      }
      final response = await http.get(uriTrans);
      if (response.statusCode == 200) {
        var dataTransaksi = json.decode(response.body) as Map<String, dynamic>;
        dataTransaksi.forEach((key, value) {
          if (value['jenis'] == jenisKompressor.value &&
              value['kembali'] == false) {
            namaPenyewa.value = value['nama'];
            DateTime tanggalSewa = DateTime.parse(value['tanggal_sewa']);
            int lamaSewa = DateTime.parse(tanggalKembali.text)
                .difference(tanggalSewa)
                .inHours;
            totalHarga.value = lamaSewa < 4
                ? harga.value
                : (lamaSewa / 24).floor() * harga.value +
                    (lamaSewa % 24 > 3 ? harga.value : 0);
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    try {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final DateTime pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          tanggalKembali.text = pickedDateTime.toString().substring(0, 16);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
