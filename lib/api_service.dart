import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.4:5000";

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "password": password,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> saveOnboarding({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/auth/onboarding/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> getUserProfile({
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/auth/user/$userId"),
      headers: {"Content-Type": "application/json"},
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception(
          'Failed to load products: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> toggleFavorite({
    required String userId,
    required String productId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/favorites/toggle"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<List<ProductModel>> fetchFavorites(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/favorites/$userId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load favorites");
    }
  }

  static Future<Map<String, dynamic>> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/cart/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
        "quantity": quantity,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> fetchCart(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/cart/$userId"),
      headers: {"Content-Type": "application/json"},
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/cart/remove"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> updateCartQuantity({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/cart/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
        "quantity": quantity,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> createOrder({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String city,
    required String streetAddress,
    required String note,
    required String paymentMethod,
    required double subtotal,
    required double deliveryFee,
    required double total,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/orders/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "city": city,
        "streetAddress": streetAddress,
        "note": note,
        "paymentMethod": paymentMethod,
        "subtotal": subtotal,
        "deliveryFee": deliveryFee,
        "total": total,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }
}
