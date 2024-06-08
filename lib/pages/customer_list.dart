import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kompressor/controller/cek_blacklist_controller.dart';
import 'package:kompressor/routes/route_names.dart';

class DaftarPenyewa extends StatelessWidget {
  final CekBlacklistController customerC = Get.put(CekBlacklistController());
  DaftarPenyewa({super.key});

  @override
  Widget build(BuildContext context) {
    customerC.takeData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Penyewa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 69, 108, 141),
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              customerC.dataResponse.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: customerC.dataResponse.length,
                      itemBuilder: (context, index) {
                        var key = customerC.dataResponse.keys.elementAt(index);
                        var value = customerC.dataResponse[key];
                        return ListTile(
                            title: Text(value['nik']),
                            subtitle: Text(value['nama']),
                            trailing: Text(
                              value['blacklist']
                                  ? 'Blacklist'
                                  : 'Tidak Blacklist',
                              style: TextStyle(
                                color: value['blacklist']
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () => Get.toNamed(
                                  RouteName.detailPenyewa,
                                  arguments: value,
                                ));
                      },
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
      ),
      //  body: Obx(() {
      //   if (customerC.dataResponse.isEmpty) {
      //     return const Center(child: CircularProgressIndicator());
      //   }

      //   return SingleChildScrollView(
      //     child: ListView.builder(
      //       itemCount: customerC.dataResponse.length,
      //       itemBuilder: (context, index) {
      //         var key = customerC.dataResponse.keys.elementAt(index);
      //         var value = customerC.dataResponse[key];
      //         return ListTile(
      //           title: Text(value['nik']),
      //           subtitle: Text(value['nama']),
      //           trailing: Text(value['blacklist'] ? 'Blacklist' : 'Tidak Blacklist'),
      //         );
      //       },
      //     ),
      //   );
      // }),
    );
  }
}
