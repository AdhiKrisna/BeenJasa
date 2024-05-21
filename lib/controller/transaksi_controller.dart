import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kompressor/controller/cek_blacklist_controller.dart';
import 'package:kompressor/controller/kompressor_controller.dart';
import 'package:kompressor/routes/route_names.dart';

class TransaksiController extends GetxController {
  bool isValid = true;
  KompressorController kompressorC = Get.put(KompressorController());
  bool isFilledName(String namaPenyewa) {
    if (namaPenyewa == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Nama penyewa tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  bool isFilledPhoneNumber(String nomorHpPenyewa) {
    if (nomorHpPenyewa == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Nomor HP penyewa tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  bool isFilledAddress(String alamatPenyewa) {
    if (alamatPenyewa == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Alamat penyewa tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  bool isFilledLamaSewa(int lamaSewa) {
    if (lamaSewa == 0) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Lama sewa tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  bool isSelectedCompressor(String jenisKompressor) {
    if (jenisKompressor == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Jenis kompressor tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  bool isSelectedDate(String tanggalSewa) {
    if (tanggalSewa == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Tanggal sewa tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
      return false;
    } else {
      return true;
    }
  }

  void isTransaksi(nikPenyewa, namaPenyewa, nomorHpPenyewa, alamatPenyewa,
      selectedKompressor, lamaSewa, tanggalSewa) {
    if (!isFilledName(namaPenyewa)) {
      isValid = false;
    }
    if (!isFilledPhoneNumber(nomorHpPenyewa)) {
      isValid = false;
    }
    if (!isFilledAddress(alamatPenyewa)) {
      isValid = false;
    }
    if (!isSelectedCompressor(selectedKompressor)) {
      isValid = false;
    }
    if (!isFilledLamaSewa(lamaSewa)) {
      isValid = false;
    }
    if (!isSelectedDate(tanggalSewa)) {
      isValid = false;
    }
  }

  // ambil data kompressor dari kontroller kompressor
  void takeData() async {
    await kompressorC.takeData();
    
  }

  void addTransaksi(
    String nikPenyewa,
    String namaPenyewa,
    String nomorHpPenyewa,
    String alamatPenyewa,
    String selectedKompressor,
    int lamaSewa,
    String tanggalSewa,
  ) {
    CekBlacklistController blackListC = Get.put(CekBlacklistController());
    blackListC.takeData();
    // Remove the unused variable 'key'
    dynamic link, keyPenyewa, keyCompressor;
    bool isRegistered = false;
    blackListC.dataResponse.forEach((key, valueNIK) {
      if (valueNIK['nik'] == nikPenyewa) {
        keyPenyewa = key;
        isRegistered = true;
      }
    });
    //
    if (isRegistered) {
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan/$keyPenyewa.json";
      print(link);
      Uri uri = Uri.parse(link);
      http
          .patch(uri,
              body: json.encode({
                'nik': nikPenyewa,
                'nama': namaPenyewa,
                'no_hp': nomorHpPenyewa,
                'alamat': alamatPenyewa,
                'blacklist': false,
              }))
          .then((value) {})
          .catchError((error) {
        print(error);
      });
    } else {
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan.json";
      print(link);
      Uri uri = Uri.parse(link);
      http
          .post(uri,
              body: json.encode({
                'nik': nikPenyewa,
                'nama': namaPenyewa,
                'no_hp': nomorHpPenyewa,
                'alamat': alamatPenyewa,
                'blacklist': false,
              }))
          .then((value) {})
          .catchError((error) {
        print(error);
      });
    }
    //ambil data kompresor yang dipilih
    takeData();
    kompressorC.dataKompressor.forEach((key, value) {
      if (value['jenis'] == selectedKompressor) {
        keyCompressor = key;
      }
    });
    //UBAH STATUS KOMPRESOR MENJADI KEMBALI FALSE
    print(keyCompressor);
    print(selectedKompressor);
    Uri uri2 = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Kompresor/$keyCompressor.json");
    http
        .patch(uri2,
            body: json.encode({
              'kembali': false,
            }))
        .then((value) {
      print('Kompresor berhasil diubah');
      Uri uri1 = Uri.parse(
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Transaksi.json");
      http
          .post(uri1,
              body: json.encode({
                'nik': nikPenyewa,
                'nama': namaPenyewa,
                'no_hp': nomorHpPenyewa,
                'alamat': alamatPenyewa,
                'jenis': selectedKompressor,
                'lama_sewa': lamaSewa,
                'tanggal_sewa': tanggalSewa,
                'kembali': false,
                'lunas': false,
                'tanggal_kembali': null,
                'nota_pembayaran': false,
                'nota_sewa': false,
              }))
          .then((value) {
        Get.snackbar(
          'Informasi',
          'Data Transaksi Berhasil Ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed(RouteName.home);
      }).catchError((error) {
        print(error);
      });
    }).catchError((error) {
      print(error);
    });
  }
}
