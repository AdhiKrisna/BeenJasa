import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kompressor/routes/route_names.dart';
import 'package:http/http.dart' as http;

class CekBlacklistController extends GetxController {
  RxString nikPenyewa = ''.obs;
  var dataResponse = {}.obs;

  void setNIKPenyewa(String value) {
    nikPenyewa.value = value;
  }

  Future takeData() async {
    Uri uri = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan.json");
    return http.get(uri).then((value) {
      dataResponse.value = json.decode(value.body) as Map<String, dynamic>;
    }).catchError((error) {
      print(error);
    });
  }
  
  void cekBlacklist() async {
    await takeData();
    //cek apakah nik penyewa ada atau tidak
    RxBool isBlacklist = false.obs;
    RxBool isRegistered = false.obs;
    dataResponse.forEach((key, valueNIK) {
      if (valueNIK['nik'] == nikPenyewa.value &&
          valueNIK['blacklist'] == true) {
        isBlacklist.value = true;
        if (!Get.isSnackbarOpen) {
          Get.snackbar(
            'Informasi',
            'Penyewa dalam blacklist',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 1),
          );
        }
      }
      if (valueNIK['nik'] == nikPenyewa.value) {
        isRegistered.value = true;
      }
    });

    if (!isBlacklist.value) {
      //jika penyewa tidak dalam daftar blacklist, namun sudah terdaftar, maka akan diarahkan ke halaman fix sewa, de
      if (isRegistered.value) {
        Get.snackbar(
          'Informasi',
          'Penyewa terdaftar dan tidak blacklist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      //jika penyewa tidak terdaftar di database, maka akan diarahkan ke halaman fix sewa dengan membawa data nik penyewa
      else {
        if (nikPenyewa.value == '') {
          if (!Get.isSnackbarOpen) {
            Get.snackbar(
              'Informasi',
              'NIK tidak boleh kosong',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 1),
            );
          }
          return;
        }
        Get.snackbar(
          'Informasi',
          'Penyewa belum terdaftar, akan otomatis terdaftar ke database saat melakukan sewa kompresor',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
      Get.toNamed(RouteName.fixSewa, arguments: nikPenyewa.value);
    }
  }
}
