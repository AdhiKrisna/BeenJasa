import 'package:flutter/material.dart';
import 'package:kompressor/routes/route_names.dart';
import 'package:get/get.dart'; // Import the necessary package

class Home extends StatelessWidget {
  const Home({super.key});

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/comp.png',
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteName.cekSewa);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 108, 141)),
                      child: const Text(
                        'Sewa Kompressor',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteName.pengembalian);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 108, 141)),
                      child: const Text(
                        'Pengembalian Kompressor',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //garis pembatas
                  Container(
                    height: 5,
                    color: const Color.fromARGB(255, 69, 108, 141),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteName.daftarPenyewa);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 108, 141)),
                      child: const Text(
                        'Daftar Penyewa',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RouteName.daftarKompresor);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 69, 108, 141)),
                      child: const Text(
                        'Daftar Kompresor',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
