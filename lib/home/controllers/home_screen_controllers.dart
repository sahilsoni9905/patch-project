import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:patch_project/home/models/product_model.dart';
import 'package:patch_project/services/api_client.dart';

class HomeScreenControllers extends GetxController {
  late ApiClient _apiClient;
  ProductListModel? productModel;
  Rx<ProductListModel?> showCurrentProduct = Rx<ProductListModel?>(null);

  RxString categorySelected = "".obs;
  RxInt sortingSlected = 0.obs;
  Rx<RxStatus> screenLoadingStatus = RxStatus.loading().obs;
  RxInt numberOfProductChoosen = 0.obs;
  HomeScreenControllers();

  @override
  onInit() async {
    super.onInit();
    _apiClient = Get.put(ApiClient());
    await loadAllProduct();
  }

  Future<void> loadAllProduct() async {
    try {
      print('reached 1');
      screenLoadingStatus.value = RxStatus.loading();
      await _apiClient.loadProducts(onSuccess: (resp) async {
        print('reached 2');
        print('the resp is $resp');
        if (resp is List) {
          productModel = ProductListModel.fromList(resp);
        } else {
          throw Exception('Invalid data format: Expected a List');
        }
        showCurrentProduct.value = productModel;
        numberOfProductChoosen.value = productModel?.products?.length ?? 0;
        print('Loaded products: ${productModel?.products}');
        screenLoadingStatus.value = RxStatus.success();
      }, onError: (err) {
        print('Error occurred: $err');
        screenLoadingStatus.value = RxStatus.error();
      });
    } catch (e) {
      print('Exception: $e');
      screenLoadingStatus.value = RxStatus.error();
    }
  }

  Future<void> tapDetected() async {
    screenLoadingStatus.value = RxStatus.loading();

    if (categorySelected.value == "") {
      if (sortingSlected.value == 0) {
        showCurrentProduct.value = productModel;
      } else {
        List<ProductModel>? tempProducts = productModel?.products;

        if (sortingSlected.value == 1) {
          // Low to High Price
          tempProducts!.sort((a, b) {
            double priceA = a.price ?? 0.0;
            double priceB = b.price ?? 0.0;
            return priceA.compareTo(priceB);
          });
        } else if (sortingSlected.value == 2) {
          // High to Low Price
          tempProducts!.sort((a, b) {
            double priceA = a.price ?? 0.0;
            double priceB = b.price ?? 0.0;
            return priceB.compareTo(priceA);
          });
        }

        showCurrentProduct.value = ProductListModel(products: tempProducts);
      }
    } else {
      List<ProductModel>? tempProducts = [];

      if (sortingSlected.value == 0) {
        for (var temp in productModel?.products ?? []) {
          if (temp.category == categorySelected.value) {
            tempProducts.add(temp);
          }
        }
      } else if (sortingSlected.value == 1) {
        for (var temp in productModel?.products ?? []) {
          if (temp.category == categorySelected.value) {
            tempProducts.add(temp);
          }
        }
        tempProducts.sort((a, b) {
          double priceA = a.price ?? 0.0;
          double priceB = b.price ?? 0.0;
          return priceA.compareTo(priceB);
        });
      } else {
        for (var temp in productModel?.products ?? []) {
          if (temp.category == categorySelected.value) {
            tempProducts.add(temp);
          }
        }
        tempProducts.sort((a, b) {
          double priceA = a.price ?? 0.0;
          double priceB = b.price ?? 0.0;
          return priceB.compareTo(priceA);
        });
      }
      showCurrentProduct.value = ProductListModel(products: tempProducts);
    }

    screenLoadingStatus.value = RxStatus.success();
  }

  List<String> categories = [
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing",
  ];
}
