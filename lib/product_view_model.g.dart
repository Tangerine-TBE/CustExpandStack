// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductViewModel _$ProductViewModelFromJson(Map<String, dynamic> json) =>
    ProductViewModel(
      id: (json['id'] as num).toInt(),
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      supplierName: json['supplierName'] as String,
      supplierShortName: json['supplierShortName'] as String,
      qualityInfo: json['qualityInfo'] as String,
      supplierId: (json['supplierId'] as num).toInt(),
      isSelected: json['isSelected'] as bool? ?? false,
      price: (json['price'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      selectedCount: (json['selectedCount'] as num?)?.toInt() ?? 0,
    )
      ..dateTime = json['dateTime'] as String?
      ..classifyId = (json['classifyId'] as num?)?.toInt()
      ..restaurantId = (json['restaurantId'] as num?)?.toInt()
      ..likeStatus = json['likeStatus'] as bool?;

Map<String, dynamic> _$ProductViewModelToJson(ProductViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'supplierName': instance.supplierName,
      'supplierId': instance.supplierId,
      'supplierShortName': instance.supplierShortName,
      'qualityInfo': instance.qualityInfo,
      'count': instance.count,
      'isSelected': instance.isSelected,
      'selectedCount': instance.selectedCount,
      'price': instance.price,
      'dateTime': instance.dateTime,
      'classifyId': instance.classifyId,
      'restaurantId': instance.restaurantId,
      'likeStatus': instance.likeStatus,
    };
