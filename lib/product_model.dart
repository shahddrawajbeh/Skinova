// class ProductModel {
//   final String id;
//   final String name;
//   final String brand;
//   final String category;
//   final String imageUrl;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.category,
//     required this.imageUrl,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       brand: json['brand'] ?? '',
//       category: json['category'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//     );
//   }
// }
class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageUrl;
  final String productType;
  final String shortDescription;
  final String safetyRating;

  final double price;
  final String currency;
  final bool inStock;
  final int stockCount;
  final String size;
  final int discountPercent;
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.productType,
    required this.shortDescription,
    required this.safetyRating,
    required this.price,
    required this.currency,
    required this.inStock,
    required this.stockCount,
    required this.size,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      productType: json['productType'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      safetyRating: json['safetyRating'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      inStock: json['inStock'] ?? true,
      stockCount: json['stockCount'] ?? 0,
      size: json['size'] ?? '',
      discountPercent: json['discountPercent'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}
