import 'package:boycott_app/controller/global_controller.dart';
import 'package:boycott_app/view/products_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final GlobalController gc = Get.put(GlobalController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF149954),
        onPressed: () => gc.scanBarcode(),
        child: SizedBox(
          height: Get.height * 0.05,
          width: Get.width * 0.1,
          child: Image.asset(
            'assets/images/barcodescanner.gif',
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (gc.isLoading.value) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                title: const Text(
                  'Categories',
                  style: TextStyle(fontFamily: 'HindFont', color: Colors.white),
                ),
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
                      controller: gc.categorySearchController,
                      decoration: InputDecoration(
                        hintText: 'Search Categories',
                        prefixIcon: const Icon(CupertinoIcons.search,
                            color: Color(0XFF149954)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => gc.filterCategories(),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 30,
                        ),
                        title: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          height: Get.height * 0.06,
                        ),
                      ),
                    );
                  },
                  childCount: 10, // Number of shimmer placeholders
                ),
              ),
            ],
          );
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              title: const Text(
                'Categories',
                style: TextStyle(fontFamily: 'HindFont', color: Colors.white),
              ),
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
                    controller: gc.categorySearchController,
                    decoration: InputDecoration(
                      hintText: 'Search Categories',
                      prefixIcon: const Icon(CupertinoIcons.search,
                          color: Color(0XFF149954)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => gc.filterCategories(),
                  ),
                ),
              ),
            ),
            if (gc.filteredCategories.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No items found',
                    style: TextStyle(
                      fontFamily: 'HindFont',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = gc.filteredCategories[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: Hero(
                            tag: 'hero-${category.category}',
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.asset(
                                category.image,
                              ),
                            ),
                          ),
                          title: Text(category.category,
                              style: const TextStyle(fontFamily: 'HindFont')),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(
                              ProductsListScreen(category: category),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                        if (index != gc.filteredCategories.length - 1)
                          const Divider(),
                      ],
                    );
                  },
                  childCount: gc.filteredCategories.length,
                ),
              ),
          ],
        );
      }),
    );
  }
}
