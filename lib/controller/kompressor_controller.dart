import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class KompressorController extends GetxController {
  var dataKompressor = {}.obs;
  var availableKompressor = <String>[].obs;
  var isServiceCompressor = <bool>[].obs;

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

  void cekStokKompressor() async {
    availableKompressor = <String>[].obs;
    await takeData();
    //cek apakah stok kompressor ada atau tidak, lalu return value yang ada untuk ditampilkan di dropdown
    dataKompressor.forEach((key, valueStok) {
      if (valueStok['kembali'] == true) {
        availableKompressor.add(valueStok['jenis']);
      }
    });
  }

  void cekServiceKompressor() async {
    await takeData();
    //cek apakah kompressor sedang service atau tidak, lalu return value yang ada untuk ditampilkan di dropdown
    //cek apakah kompressor sudah pernah dilakukan service atau belum
    dataKompressor.forEach((key, value) {
      if (value['servis'] == true) {
        isServiceCompressor.add(true);
        // print('Selected Kompressosssr: $value');
      } else {
        isServiceCompressor.add(false);
        // print('Selected Kompressorr: $value');
      }
    });
  }
}
