import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patch_project/home/controllers/home_screen_controllers.dart';
import 'package:patch_project/services/scale_utils.dart';

class HomeScreen extends GetView<HomeScreenControllers> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)
      ..setCurrentDeviceSize();

    return buildHomeScreen(scale);
  }

  Widget buildHomeScreen(ScalingUtility scale) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7A6EAE),
      ),
      body: Obx(() {
        if (controller.screenLoadingStatus.value.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              buildSearchBarSection(scale),
              buildCategorySection(scale),
              SizedBox(
                height: scale.getScaledHeight(10),
              ),
              buildNumberOfProductChoosenSection(scale),
              SizedBox(
                height: scale.getScaledHeight(8),
              ),
              buildSortingButtonsSection(scale),
              SizedBox(
                height: scale.getScaledHeight(10),
              ),
              buildProductListSection(scale),
            ],
          ),
        );
      }),
    );
  }

  Widget buildSearchBarSection(ScalingUtility scale) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: Color(0xFF7A6EAE),
              width: scale.fullWidth,
              height: scale.getScaledHeight(35),
            ),
            Container(
              width: scale.fullWidth,
              height: scale.getScaledHeight(35),
            ),
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: scale.getScaledHeight(56),
              width: scale.getScaledWidth(330),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF717171), // Adjust color as needed
                    ),
                    hintText: 'What are you looking for?',
                    hintStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: scale.getScaledFont(16),
                      color: Color(0xFF717171),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: scale.getScaledFont(16),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategorySection(ScalingUtility scale) {
    return Padding(
      padding: scale.getPadding(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Choose from any category',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: scale.getScaledFont(18)),
              )
            ],
          ),
          SizedBox(
            height: scale.getScaledHeight(10),
          ),
          Container(
            height: scale.getScaledHeight(110),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                bool conditionMet = index == 2;

                return Padding(
                  padding: scale.getPadding(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.categorySelected.value ==
                                  controller.categories[index]
                              ? controller.categorySelected.value = ""
                              : controller.categorySelected.value =
                                  controller.categories[index];
                          controller.tapDetected();
                        },
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            border: controller.categorySelected.value ==
                                    controller.categories[index]
                                ? Border.all(
                                    color: Colors.green,
                                    width: 4.0,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        index == 2
                            ? "Men's wear"
                            : index == 3
                                ? "Women's wear"
                                : controller
                                        .categories[index].capitalizeFirst ??
                                    '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: scale.getScaledFont(14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildNumberOfProductChoosenSection(ScalingUtility scale) {
    return Padding(
      padding: scale.getPadding(horizontal: 15),
      child: Row(
        children: [
          Text(
            '${controller.numberOfProductChoosen} products to choose from',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, fontSize: scale.getScaledFont(18)),
          )
        ],
      ),
    );
  }

  Widget buildSortingButtonsSection(ScalingUtility scale) {
    return Padding(
      padding: scale.getPadding(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (controller.sortingSlected.value == 1) {
                controller.sortingSlected.value = 0;
              } else {
                controller.sortingSlected.value = 1;
              }
              controller.tapDetected();
            },
            child: Container(
              padding: scale.getPadding(vertical: 9, horizontal: 19),
              height: scale.getScaledHeight(32),
              width: scale.getScaledWidth(132),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: controller.sortingSlected.value == 1
                    ? Color(0xFF7A6EAE)
                    : Color(0xFFCACACA),
              ),
              child: Text(
                'Lowest price first',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: scale.getScaledFont(12),
                    color: controller.sortingSlected.value == 1
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: scale.getScaledWidth(10),
          ),
          GestureDetector(
            onTap: () {
              if (controller.sortingSlected.value == 2) {
                controller.sortingSlected.value = 0;
              } else {
                controller.sortingSlected.value = 2;
              }

              controller.tapDetected();
            },
            child: Container(
              padding: scale.getPadding(vertical: 9, horizontal: 19),
              height: scale.getScaledHeight(32),
              width: scale.getScaledWidth(132),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: controller.sortingSlected.value == 2
                    ? Color(0xFF7A6EAE)
                    : Color(0xFFCACACA),
              ),
              child: Text(
                'Highest price first',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: scale.getScaledFont(12),
                    color: controller.sortingSlected.value == 2
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProductListSection(ScalingUtility scale) {
    return Padding(
      padding: scale.getPadding(horizontal: 15),
      child: Obx(() {
        if (controller.showCurrentProduct.value == null) {
          return Center(child: Text("No products found"));
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: scale.getScaledWidth(10),
            mainAxisSpacing: scale.getScaledHeight(10),
            childAspectRatio: (scale.fullWidth - scale.getScaledWidth(60)) /
                (2 * scale.getScaledHeight(210)),
          ),
          itemCount: controller.showCurrentProduct.value?.products?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFCACACA), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: scale.getPadding(all: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: scale.getScaledHeight(137),
                      width: scale.getScaledWidth(137),
                      child: Image.network(
                        controller.showCurrentProduct.value?.products?[index]
                                .image ??
                            "temp",
                      ),
                    ),
                    buildProductDetailSection(scale, index),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildProductDetailSection(ScalingUtility scale, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            controller.showCurrentProduct?.value?.products?[index].title ?? '',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: scale.getScaledFont(12),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            controller
                    .showCurrentProduct?.value?.products?[index].description ??
                '',
            style: GoogleFonts.inter(
              color: Color(0xFF7C7C7C),
              fontWeight: FontWeight.w400,
              fontSize: scale.getScaledFont(10),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '\$${controller.showCurrentProduct?.value?.products?[index].price ?? ''}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: scale.getScaledFont(10),
            ),
          )
        ],
      ),
    );
  }
}
