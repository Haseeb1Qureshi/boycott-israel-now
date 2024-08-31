import 'package:boycott_app/controller/global_controller.dart';
import 'package:boycott_app/model/json_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProductsListScreen extends StatelessWidget {
  ProductsListScreen({super.key, required this.category});
  final GlobalController gc = Get.put(GlobalController());

  final Categoryy category;

  @override
  Widget build(BuildContext context) {
    gc.filterProducts(category);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        width: Get.width * 0.45,
        child: FloatingActionButton(
          backgroundColor: const Color(0XFF149954),
          onPressed: () {
            showAlternativesBottomSheet(context);
          },
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/alternative products.png',
                color: Colors.white,
              ),
              const Text(
                "See Alternatives",
                style: TextStyle(
                  fontFamily: 'HindFont',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            title: const Text(
              'Products',
              style: TextStyle(fontFamily: 'HindFont', color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Color(0XFF149954)),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFFFFFFFF),
                    Color(0XFF000000),
                    Color(0XFFE4312b),
                    Color(0XFF149954),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Get.height * 0.09),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: gc.productSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search Products',
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      color: Color(0XFF149954),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (gc.filteredProducts.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(fontSize: 18, fontFamily: 'HindFont'),
                  ),
                ),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = gc.filteredProducts[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Halt!',
                                message: 'Avoid Israeli Products!',
                                messageFontSize: 17,
                                contentType: ContentType.warning,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                          leading: Hero(
                            tag: 'hero-${product.productName}',
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.asset(product.productImage),
                            ),
                          ),
                          title: Text(
                            product.productName,
                            style: const TextStyle(fontFamily: 'HindFont'),
                          ),
                        ),
                        if (index != gc.filteredProducts.length - 1)
                          const Divider(),
                      ],
                    );
                  },
                  childCount: gc.filteredProducts.length,
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  void showAlternativesBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFFFFFFFF),
              Color(0XFF000000),
              Color(0XFFE4312b),
              Color(0XFF149954),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.014, bottom: Get.height * 0.016),
              child: const Text(
                'Alternative Products',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: 'HindFont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)),
              height: Get.height * 0.4,
              width: double.infinity,
              child: ListView.separated(
                itemCount: category.alternatives.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final alternative = category.alternatives[index];
                  return Padding(
                    padding: EdgeInsets.only(top: Get.height * 0.02),
                    child: ListTile(
                      title: Text(
                        alternative.alternativeName,
                        style: const TextStyle(
                          fontFamily: 'HindFont',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Image.asset(alternative.alternativeImage),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: Get.width * 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Get.height * 0.012,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0XFF149954),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'HindFont',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
