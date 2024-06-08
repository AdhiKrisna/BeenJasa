import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kompressor/routes/route_names.dart';

class PengembalianController extends GetxController {
  int harga = 0, totalHarga = 0;
  DateTime tanggalSewa = DateTime.now();
  int lamaSewa = 0;
  var dataKompressor = {}.obs;
  var unAvailableKompressor = <String>[].obs;
  
  // data kompressor yang sedang disewa
  Future<void> takeData() async {
    Uri uri = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Kompresor.json");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        dataKompressor.value =
            json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> cekUnavailable() async {
    unAvailableKompressor = <String>[].obs;
    await takeData();
    dataKompressor.forEach((key, valueStok) {
      if (valueStok['kembali'] == false) {
        unAvailableKompressor.add(valueStok['jenis']);
      }
    });
  }

  void kembaliNgutang(
      String key, String jenisKompressor, String tanggalKembali) async {
    // logic untuk mengembalikan kompressor yang masih diutang dan post ke database untuk mengubah status kompressor menjadi kembali
    Uri uriKomp = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Kompresor/$key.json");
    try {
      final response = await http.get(uriKomp);
      if (response.statusCode == 200) {
        var dataKompressor = json.decode(response.body) as Map<String, dynamic>;
        harga = dataKompressor['biaya'];
        dataKompressor['servis'] = false;
        dataKompressor['kembali'] = true;
        await http.patch(uriKomp, body: json.encode(dataKompressor));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
    Uri uriTrans = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Transaksi.json");
    try {
      final response = await http.get(uriTrans);
      if (response.statusCode == 200) {
        var dataTransaksi = json.decode(response.body) as Map<String, dynamic>;
        dataTransaksi.forEach((key, value) {
          if (value['jenis'] == jenisKompressor && value['kembali'] == false) {
            tanggalSewa = DateTime.parse(value['tanggal_sewa']);
            lamaSewa =
                DateTime.parse(tanggalKembali).difference(tanggalSewa).inHours;
            totalHarga = lamaSewa < 4
                ? harga
                : (lamaSewa / 24).floor() * harga +
                    (lamaSewa % 24 > 3 ? harga : 0);
            value['kembali'] = true;
            value['tanggal_kembali'] = tanggalKembali;
            value['total_harga'] = totalHarga;
            http.patch(uriTrans, body: json.encode(dataTransaksi));
          }
        });
        Get.snackbar(
          'Informasi',
          'Kompressor telah dikembalikan dan belum dilunasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        Get.offAllNamed(RouteName.home);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  void kembaliLunas(String key, String jenisKompressor, String tanggalKembali) async {
    Uri uriKomp = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Kompresor/$key.json");
    try {
      final response = await http.get(uriKomp);
      if (response.statusCode == 200) {
        var dataKompressor = json.decode(response.body) as Map<String, dynamic>;
        harga = dataKompressor['biaya'];
        dataKompressor['servis'] = false;
        dataKompressor['kembali'] = true;
        await http.patch(uriKomp, body: json.encode(dataKompressor));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
    Uri uriTrans = Uri.parse(
        "https://beenjasa-d237c-default-rtdb.asia-southeast1.firebasedatabase.app/Transaksi.json");
    try {
      final response = await http.get(uriTrans);
      if (response.statusCode == 200) {
        var dataTransaksi = json.decode(response.body) as Map<String, dynamic>;
        dataTransaksi.forEach((key, value) {
          if (value['jenis'] == jenisKompressor && value['kembali'] == false) {
            tanggalSewa = DateTime.parse(value['tanggal_sewa']);
            lamaSewa =
                DateTime.parse(tanggalKembali).difference(tanggalSewa).inHours;
            totalHarga = lamaSewa < 4
                ? harga
                : (lamaSewa / 24).floor() * harga +
                    (lamaSewa % 24 > 3 ? harga : 0);
            value['kembali'] = true;
            value['tanggal_kembali'] = tanggalKembali;
            value['total_harga'] = totalHarga;
            value['lunas'] = true;
            http.patch(uriTrans, body: json.encode(dataTransaksi));
          }
        });
        Get.snackbar(
          'Informasi',
          'Kompressor telah dikembalikan dan sudah dilunasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        Get.offNamed(RouteName.home);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }
}
