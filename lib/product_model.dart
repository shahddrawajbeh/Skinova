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
//seconf

// class ProductModel {
//   final String id;
//   final String name;
//   final String brand;
//   final String category;
//   final String imageUrl;
//   final String productType;
//   final String shortDescription;
//   final String safetyRating;

//   final double price;
//   final String currency;
//   final bool inStock;
//   final int stockCount;
//   final String size;
//   final int discountPercent;
//   final double rating;
//   final int reviewCount;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.category,
//     required this.imageUrl,
//     required this.productType,
//     required this.shortDescription,
//     required this.safetyRating,
//     required this.price,
//     required this.currency,
//     required this.inStock,
//     required this.stockCount,
//     required this.size,
//     required this.discountPercent,
//     required this.rating,
//     required this.reviewCount,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       brand: json['brand'] ?? '',
//       category: json['category'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       productType: json['productType'] ?? '',
//       shortDescription: json['shortDescription'] ?? '',
//       safetyRating: json['safetyRating'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//       currency: json['currency'] ?? 'USD',
//       inStock: json['inStock'] ?? true,
//       stockCount: json['stockCount'] ?? 0,
//       size: json['size'] ?? '',
//       discountPercent: json['discountPercent'] ?? 0,
//       rating: (json['rating'] ?? 0).toDouble(),
//       reviewCount: json['reviewCount'] ?? 0,
//     );
//   }
// }
//second

import 'ingredient_model.dart';
import 'review_model.dart';
import 'whats_inside_model.dart';
import 'recommended_for_model.dart';

class ProductModel {
  final String id;
  final String brand;
  final String name;
  final String shortDescription;
  final String imageUrl;

  final double rating;
  final List<ReviewModel> reviews;

  final WhatsInsideModel whatsInside;
  final List<IngredientModel> ingredients;

  final String brandOrigin;

  final double price;
  final String currency;
  final bool inStock;
  final int stockCount;
  final String size;
  final int discountPercent;

  final RecommendedForModel recommendedFor;

  final bool isPublished;

  ProductModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.whatsInside,
    required this.ingredients,
    required this.brandOrigin,
    required this.price,
    required this.currency,
    required this.inStock,
    required this.stockCount,
    required this.size,
    required this.discountPercent,
    required this.recommendedFor,
    required this.isPublished,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? '',
      brand: json['brand'] ?? '',
      name: json['name'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      whatsInside: WhatsInsideModel.fromJson(
        Map<String, dynamic>.from(json['whatsInside'] ?? {}),
      ),
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => IngredientModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      brandOrigin: json['brandOrigin'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      inStock: json['inStock'] ?? true,
      stockCount: json['stockCount'] ?? 0,
      size: json['size'] ?? '',
      discountPercent: json['discountPercent'] ?? 0,
      recommendedFor: RecommendedForModel.fromJson(
        Map<String, dynamic>.from(
          json['recommendedFor'] ??
              {
                'skinTypes': [],
                'concerns': [],
                'goals': [],
              },
        ),
      ),
      isPublished: json['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brand': brand,
      'name': name,
      'shortDescription': shortDescription,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'whatsInside': whatsInside.toJson(),
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'brandOrigin': brandOrigin,
      'price': price,
      'currency': currency,
      'inStock': inStock,
      'stockCount': stockCount,
      'size': size,
      'discountPercent': discountPercent,
      'recommendedFor': recommendedFor.toJson(),
      'isPublished': isPublished,
    };
  }
}
