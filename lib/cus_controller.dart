import 'package:untitled1/product_view_model.dart';

class CusExtendController {
  CusExtendController({required this.date, required this.index});

  double titleHeight = 170;

  //获取标题+内容的总高度 //用于设置Stack中的高度
  double calExpandedHeight() {
    double itemTotalHeight = 0.0;
    for (int i = 0; i < allProducts.length; i++) {
      itemTotalHeight += calculateExpendedItemViewHeight(i, this);
    }
    double expandedHeight = calculateExpendedViewHeight(this) + itemTotalHeight;
    return expandedHeight;
  }

  //获取某一个controller products 中所有item的总高度
  double calItemTotalHeight() {
    double itemTotalHeight = 0.0;
    for (int i = 0; i < allProducts.length; i++) {
      itemTotalHeight += calculateExpendedItemViewHeight(i, this);
    }
    return itemTotalHeight;
  }

  double calculateExpendedViewHeight(CusExtendController controller) {
    double totalHeight = 0.0;
    if (controller.allProducts.isNotEmpty) {
      totalHeight += 70;
    } else {
      totalHeight += 85;
    }
    return totalHeight;
  }

  double calculateExpendedItemViewHeight(int index,
      CusExtendController controller) {
    if (index == controller.allProducts.length - 1) {
      return 76 + 45;
    } else {
      return 76 + 49;
    }
  }

  bool isExpanded = false;
  List<ProductViewModel> allProducts = [];

  canExpand() {
    return allProducts.isNotEmpty;
  }

  DateTime date;
  int index;
}
