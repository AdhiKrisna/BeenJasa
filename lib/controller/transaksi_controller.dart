import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kompressor/controller/cek_blacklist_controller.dart';
import 'package:kompressor/controller/kompressor_controller.dart';
import 'package:kompressor/routes/route_names.dart';

class TransaksiController extends GetxController {
  bool isValid = true;
  KompressorController kompressorC = Get.put(KompressorController());
  RxString imgUrl = ''.obs;
  CekBlacklistController blackListC = Get.put(CekBlacklistController());

  @override
  void onInit() {
    blackListC.takeData();
    super.onInit();
  }

  //cek imgUrl ada atau tidak
  void setImgUrl(String nikPenyewa) {
    blackListC.dataResponse.forEach((key, valueNIK) {
      if (valueNIK['nik'] == nikPenyewa) {
        imgUrl.value = valueNIK['ktp'] ?? ''; //got it
      }
    });
  }

  String getImgUrl() {
    print('getImgUrl + $imgUrl');
    return imgUrl.value;
  }

  Future<void> uploadImage(XFile? image, String nikPenyewa) async {
    String fileName = nikPenyewa;
    Reference ref = FirebaseStorage.instance.ref().child('ktp').child(fileName);
    try {
      await ref.putFile(File(image?.path.toString() ?? ''));
      imgUrl.value = await ref.getDownloadURL();
      print(imgUrl);
      print('Upload Success');
    } catch (e) {
      print(e);
    }
    // cek apakah data pelanggan sudah ada atau belum, dan ambil keynya
    dynamic link, keyPenyewa;
    bool isRegistered = false;
    blackListC.takeData();
    blackListC.dataResponse.forEach((key, valueNIK) {
      if (valueNIK['nik'] == nikPenyewa) {
        keyPenyewa = key;
        isRegistered = true;
      }
    });

    if (isRegistered) {
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan/$keyPenyewa.json";
      Uri uri = Uri.parse(link);
      http
          .patch(uri,
              body: json.encode({
                'ktp': imgUrl.value,
              }))
          .then((value) {
        Get.snackbar(
          'Informasi',
          'Foto KTP Berhasil Di-Update',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }).catchError((error) {
        print(error);
      });
    }
    //jika data pelanggan belum ada, maka tambahkan data pelanggan beserta foto KTP nya
    else {
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan.json";
      print(link);
      Uri uri = Uri.parse(link);
      http
          .post(uri,
              body: json.encode({
                'nik': nikPenyewa,
                'ktp': imgUrl.value,
                'blacklist': false,
                'nama': '',
                'no_hp': '',
                'alamat': '',
              }))
          .then((value) {
        Get.snackbar(
          'Informasi',
          'Foto KTP Berhasil Di-Upload',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }).catchError((error) {
        print(error);
      });
    }
    setImgUrl(nikPenyewa);
    print('Upload + $imgUrl');
  }

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

  bool isImageUploaded(String imgUrl) {
    if (imgUrl == '') {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Informasi',
          'Foto KTP belum di-upload',
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
      selectedKompressor, lamaSewa, tanggalSewa, imgUrl) {
    isValid = true;
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
    if (!isImageUploaded(imgUrl)) {
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
    //cek apakah data pelanggan sudah ada atau belum, dan ambil keynya
    dynamic link, keyPenyewa, keyCompressor;
    bool isRegistered = false;
    blackListC.takeData();
    blackListC.dataResponse.forEach((key, valueNIK) {
      if (valueNIK['nik'] == nikPenyewa) {
        print("test + $nikPenyewa");
        keyPenyewa = key;
        isRegistered = true;
      }
    });
    //
    if (isRegistered) {
      print('data pelanggan sudah ada');
      print(keyPenyewa);
      // ubah data pelanggan yang sudah ada menggunakan patch key nya
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan/$keyPenyewa.json";
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
    } 
    else {
      print('data pelanggan belum ada');
      print(keyPenyewa);
      // tambahkan data pelanggan yang belum ada
      link =
          "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Pelanggan/$keyPenyewa.json";
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
        Get.offAllNamed(RouteName.home);
      }).catchError((error) {
        print(error);
      });
    }).catchError((error) {
      print(error);
    });
  }
}
