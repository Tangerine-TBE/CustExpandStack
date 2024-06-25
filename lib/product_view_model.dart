part 'product_view_model.g.dart';

class ProductViewModel {
  int id;
  String productCode;
  String productName;
  String supplierName;
  int  supplierId;
  String supplierShortName;
  String qualityInfo;
  int count;
  bool isSelected;
  int selectedCount;
  int price;
  String? dateTime;
  int? classifyId;
  int? restaurantId;
  bool? likeStatus;
  bool canOrderCart;

  ProductViewModel({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.supplierName,
    required this.supplierShortName,
    required this.qualityInfo,
    required this.supplierId,
    this.isSelected = false,
    this.canOrderCart = false,
    this.price = 0,
    this.count = 0,
    this.selectedCount = 0,
  });

  factory ProductViewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductViewModelToJson(this);
}
