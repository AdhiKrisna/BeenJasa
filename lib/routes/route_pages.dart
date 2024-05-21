import 'package:get/get.dart';
import 'package:kompressor/pages/cek_sewa.dart';
import 'package:kompressor/pages/fix_sewa.dart';
import 'package:kompressor/pages/home.dart';
import 'package:kompressor/pages/pengembalian.dart'; // Import the necessary package

class RoutePages {
  List<GetPage<dynamic>> routes = [
    // Use the correct type 'GetPage' instead of 'GetPages'
    GetPage(
      name: '/',
      page: () => const Home(),
    ),
    GetPage(
      name: '/cekSewa',
      page: () =>  CekSewa(),
    ),
    GetPage(
      name: '/fixSewa',
      page: () =>  FixSewa(),
    ),
    GetPage(
      name: '/pengembalian',
      page: () =>  Pengembalian(),
    ),
  ];
}
