import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kompressor/controller/cek_blacklist_controller.dart';
import 'package:kompressor/controller/kompressor_controller.dart';
import 'package:kompressor/controller/transaksi_controller.dart';
import 'package:path/path.dart' as path;

class FixSewa extends StatefulWidget {
  const FixSewa({
    super.key,
  });
  @override
  State<FixSewa> createState() => _FixSewaState();
}

class _FixSewaState extends State<FixSewa> {
  final KompressorController kompressorC = Get.put(KompressorController());
  final TransaksiController transaksiC = Get.put(TransaksiController());
  final CekBlacklistController cekBlacklistC =
      Get.put(CekBlacklistController());

  final RxString selectedKompressor = ''.obs;
  final statusServis = ''.obs;
  final RxBool isService = false.obs;

  final String nikPenyewa = Get.arguments ?? '';
  XFile? file;
  final RxString fileName = ''.obs;

  final TextEditingController namaPenyewa = TextEditingController();
  final TextEditingController nomorHpPenyewa = TextEditingController();
  final TextEditingController alamatPenyewa = TextEditingController();
  final TextEditingController lamaSewa = TextEditingController();
  final TextEditingController tanggalSewa = TextEditingController();

  final RxBool isRegistered = false.obs;
  @override
  void initState() {
    super.initState();
    dataRegistered();
    kompressorC.cekStokKompressor();
    kompressorC.cekServiceKompressor();
    if (isRegistered.value == true) {
      transaksiC.setImgUrl(nikPenyewa);
    }
  }

  void dataRegistered() {
    cekBlacklistC.takeData();
    cekBlacklistC.dataResponse.forEach((key, value) {
      if (value['nik'] == nikPenyewa) {
        namaPenyewa.text = value['nama'] ?? '';
        nomorHpPenyewa.text = value['no_hp'] ?? '';
        alamatPenyewa.text = value['alamat'] ?? '';
        isRegistered.value = true;
      }
    });
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'Nama Penyewa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    TextFormField(
                      // jika nik penyewa sudah terdaftar, maka nama, no hp, alamat akan terisi otomatis, jika tidak maka akan kosong
                      controller: namaPenyewa,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Nama Penyewa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nomor HP Penyewa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    TextFormField(
                      // jika nik penyewa sudah terdaftar, maka nama, no hp, alamat akan terisi otomatis, jika tidak maka akan kosong
                      controller: nomorHpPenyewa,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Nomor HP Penyewa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Alamat Penyewa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    TextFormField(
                      // jika nik penyewa sudah terdaftar, maka nama, no hp, alamat akan terisi otomatis, jika tidak maka akan kosong
                      controller: alamatPenyewa,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Alamat Penyewa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jenis Kompresor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Obx(
                      () {
                        if (kompressorC.availableKompressor.isEmpty) {
                          return const Text('SEMUA KOMPRESOR SEDANG DISEWA');
                        } else {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            hint: const Text('Pilih Jenis Kompresor'),
                            value: selectedKompressor.value.isEmpty
                                ? null
                                : selectedKompressor.value,
                            items: kompressorC.availableKompressor
                                .map((jenis) => DropdownMenuItem(
                                      value: jenis,
                                      child: Text(jenis),
                                    ))
                                .toList(),
                            onChanged: (value) async {
                              selectedKompressor.value = value ?? '';
                              await cekServis();
                            },
                          );
                        }
                      },
                    ),
                    Obx(() => Text(
                          "Status Servis : $statusServis",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: isService.value
                                ? Colors.green
                                : Colors.yellow[900],
                          ),
                        )),
                    const SizedBox(height: 20),
                    const Text(
                      'Lama Sewa (hari)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Lama Sewa',
                        border: OutlineInputBorder(),
                      ),
                      controller: lamaSewa,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tanggal Sewa', //hari ini
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Tanggal Sewa',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      //default value = hari ini
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                      controller: tanggalSewa,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Foto KTP', //hari ini
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // tampilkan foto KTP yang sudah diupload
                    if (transaksiC.getImgUrl() != '')
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Obx(
                          () => Image.network(
                            transaksiC.getImgUrl(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    //button take image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            //take image from camera,  and save it into file variable
                            ImagePicker imgPicker = ImagePicker();
                            file = await imgPicker.pickImage(
                              source: ImageSource.camera,
                            );
                            if (file == null) {
                              Get.snackbar(
                                'Informasi',
                                'Foto KTP belum diambil',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 1),
                              );
                              return;
                            }
                            fileName.value = path.basename(file!.path);
                            print(fileName.value);
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          ),
                          label: const Text(
                            'Kamera',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 69, 108, 141),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            //take image from galery,  and save it into file variable
                            ImagePicker imgPicker = ImagePicker();
                            file = await imgPicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (file == null) {
                              Get.snackbar(
                                'Informasi',
                                'Foto KTP belum diambil',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 1),
                              );
                              return;
                            }
                            fileName.value = path.basename(file!.path);
                            print(fileName.value);
                          },
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 15,
                          ),
                          label: const Text(
                            'Galery',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 69, 108, 141),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Text(
                          "$fileName ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: Colors.green,
                          ),
                        )),
                    //button upload image
                    ElevatedButton.icon(
                      onPressed: () {
                        // check if file is null
                        if (file == null) {
                          Get.snackbar(
                            'Informasi',
                            'Foto KTP belum diambil',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 1),
                          );
                          return;
                        }
                        Get.defaultDialog(
                          title: 'Konfirmasi Upload',
                          middleText:
                              'Apakah anda yakin ingin upload foto KTP?',
                          textConfirm: 'Ya',
                          textCancel: 'Tidak',
                          confirmTextColor: Colors.white,
                          buttonColor: const Color.fromARGB(255, 69, 108, 141),
                          cancelTextColor: Colors.red,
                          onConfirm: () async {
                            // upload image to firebase storage
                            // ANIMASI LOADING SELAMA PROSES UPLOAD
                            Get.dialog(const Center(
                              child: CircularProgressIndicator(),
                            ));
                            await transaksiC.uploadImage(file!, nikPenyewa);
                            Get.back();
                            Get.back();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.upload,
                        color: Colors.white,
                        size: 15,
                      ),
                      label: const Text(
                        'Upload Foto KTP',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 69, 108, 141),
                      ),
                    ),

                    //jika sudah terdaftar, maka tidak perlu upload foto KTP
                    if (isRegistered.value == true)
                      const Text(
                        'Pelanggan sudah terdaftar, tidak perlu upload foto KTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 69, 108, 141),
                    ),
                    onPressed: () {
                      transaksiC.isTransaksi(
                        nikPenyewa,
                        namaPenyewa.text,
                        nomorHpPenyewa.text,
                        alamatPenyewa.text,
                        selectedKompressor.value,
                        lamaSewa.text == '' ? 0 : int.parse(lamaSewa.text),
                        tanggalSewa.text,
                      );
                      if (transaksiC.isValid) {
                        // confirm transaksi
                        Get.defaultDialog(
                          title: 'Konfirmasi',
                          middleText:
                              'Apakah anda yakin ingin melakukan transaksi?',
                          textConfirm: 'Ya',
                          textCancel: 'Tidak',
                          confirmTextColor: Colors.white,
                          buttonColor: const Color.fromARGB(255, 69, 108, 141),
                          onConfirm: () {
                            Get.dialog(const Center(
                              child: CircularProgressIndicator(),
                            ));
                            transaksiC.addTransaksi(
                              nikPenyewa,
                              namaPenyewa.text,
                              nomorHpPenyewa.text,
                              alamatPenyewa.text,
                              selectedKompressor.value,
                              lamaSewa.text == ''
                                  ? 0
                                  : int.parse(lamaSewa.text),
                              tanggalSewa.text,
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Transaksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future cekServis() async {
    await kompressorC.takeData();
    kompressorC.dataKompressor.forEach((key, value) {
      if (value['jenis'] == selectedKompressor.value) {
        isService.value = value['servis'];
        statusServis.value =
            isService.value == true ? 'Sudah diservis' : 'Belum diservis';
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        tanggalSewa.text = pickedDateTime.toString().substring(0, 16);
      }
    }
  }
}
