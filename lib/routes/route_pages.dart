import 'package:get/get.dart';
import 'package:kompressor/pages/cek_sewa.dart';
import 'package:kompressor/pages/compressor_list.dart';
import 'package:kompressor/pages/customer_detail.dart';
import 'package:kompressor/pages/customer_list.dart';
import 'package:kompressor/pages/fix_sewa.dart';
import 'package:kompressor/pages/home.dart';
import 'package:kompressor/pages/pengembalian.dart';
import 'package:kompressor/routes/route_names.dart'; // Import the necessary package

class RoutePages {
  List<GetPage<dynamic>> routes = [
    // Use the correct type 'GetPage' instead of 'GetPages'
    GetPage(
      name: '/',
      page: () => const Home(),
    ),
    GetPage(
      name: RouteName.cekSewa,
      page: () => CekSewa(),
    ),
    GetPage(
      name: RouteName.fixSewa,
      page: () => FixSewa(),
    ),
    GetPage(
      name: RouteName.pengembalian,
      page: () => Pengembalian(),
    ),
    GetPage(
      name: RouteName.daftarPenyewa,
      page: () =>  DaftarPenyewa(),
    ),
    GetPage(
      name: RouteName.detailPenyewa,
      page: () =>  DetailPenyewa(),
    ),
    GetPage(
      name: RouteName.daftarKompresor,
      page: () =>  DaftarKompresor(),
    ),
  ];
}
