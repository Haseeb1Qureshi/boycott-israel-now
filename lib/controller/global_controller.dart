import 'dart:convert';
import 'package:boycott_app/model/json_data.dart';
import 'package:boycott_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class GlobalController extends GetxController {
  var categories = <Categoryy>[].obs;
  var filteredCategories = <Categoryy>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;
  var barcode = ''.obs;
  TextEditingController categorySearchController = TextEditingController();
  TextEditingController productSearchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    categorySearchController.addListener(filterCategories);
    productSearchController.addListener(() {
      filterProductsBySearchText();
    });
    Future.delayed(const Duration(seconds: 4), () async {
      Get.off(HomeScreen(), transition: Transition.rightToLeft);
      await showInitialDialogIfFirstTime();
    });
  }

  // Fetch categories from remote JSON file hosted on GitHub

  void fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://raw.githubusercontent.com/Haseeb1Qureshi/boycott-israel-now/main/assets/json/data.json',
        ),
        headers: {
          'Cache-Control': 'no-cache', // Prevents caching of the response
          'Pragma': 'no-cache', // HTTP 1.0 backward compatibility
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        categories.value = data
            .map((item) => Categoryy.fromJson(item as Map<String, dynamic>))
            .toList();
        filteredCategories.value = categories;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load data from GitHub.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("failed to load data: " '$e');
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterCategories() {
    if (categorySearchController.text.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) => category.category
              .toLowerCase()
              .contains(categorySearchController.text.toLowerCase()))
          .toList();
    }
  }

  void filterProducts(Categoryy category) {
    filteredProducts.value = category.products;
  }

  void filterProductsBySearchText() {
    if (productSearchController.text.isEmpty) {
      filteredProducts.value = categories
          .firstWhere((category) => category.products == filteredProducts)
          .products;
    } else {
      filteredProducts.value = categories
          .expand((category) => category.products)
          .where((product) => product.productName
              .toLowerCase()
              .contains(productSearchController.text.toLowerCase()))
          .toList();
    }
  }

  Future<void> showInitialDialogIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime');

    if (isFirstTime == null || isFirstTime) {
      showInitialDialog();
      await prefs.setBool('isFirstTime', false);
    }
  }

  Future<void> scanBarcode() async {
    try {
      String scannedBarcode = await FlutterBarcodeScanner.scanBarcode(
          '#149954', 'Cancel', true, ScanMode.BARCODE);

      if (scannedBarcode != '-1') {
        barcode.value = scannedBarcode;

        Get.dialog(
          AlertDialog(
            title: const Text(
              'Scanned Barcode',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'HindFont'),
            ),
            content: Text(
              'Barcode: $scannedBarcode',
              style: const TextStyle(
                fontFamily: 'HindFont',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: scannedBarcode));
                  Get.back();
                  Get.snackbar(
                    '',
                    '',
                    titleText: const Text(
                      'Copied',
                      style: TextStyle(
                        fontFamily: 'HindFont',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    messageText: const Text(
                      'Barcode copied to clipboard.',
                      style: TextStyle(
                        fontFamily: 'HindFont',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0XFF149954).withOpacity(0.7),
                    borderRadius: 20,
                    margin: const EdgeInsets.all(10),
                    colorText: Colors.white,
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                    snackStyle: SnackStyle.FLOATING,
                    boxShadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                  );
                },
                child: const Text(
                  'Copy to Clipboard',
                  style: TextStyle(
                      fontFamily: 'HindFont', color: Color(0XFF149954)),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'HindFont', color: Color(0XFF149954)),
                ),
              ),
            ],
          ),
        );
      } else {
        barcode.value = 'Failed to get barcode';
        Get.snackbar('Error', 'Failed to scan barcode or scan was canceled.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      barcode.value = 'Failed to get barcode';
      Get.snackbar('Error', 'Failed to scan barcode: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

void showInitialDialog() {
  Get.dialog(
    AlertDialog(
      backgroundColor: const Color(0xffFFFFFF),
      title: Image.asset('assets/images/boycott_israel logo.png'),
      content: const Text(
        'So you have decided to boycott Israeli products?',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'HindFont', fontSize: 16),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Get.width * 0.09),
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0XFF149954))),
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'I am with Palestine',
                style: TextStyle(fontFamily: 'HindFont', color: Colors.white),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(right: Get.width * 0.11),
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0XFFE4312b))),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('I am with Israel',
                  style:
                      TextStyle(fontFamily: 'HindFont', color: Colors.white))),
        ),
      ],
    ),
  );
}
