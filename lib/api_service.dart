import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';
import 'user_model.dart';
import 'dart:io';
import '../admin_story_user_model.dart';
import '../group_model.dart';
import 'screens/post_page.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.22:5000";
  static Future<String?> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("$baseUrl/api/auth/upload-profile-image/$userId"),
      );

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final decoded = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return decoded["profileImage"];
      } else {
        print("Upload failed: $responseBody");
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/auth/update-profile/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

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

  static Future<bool> removeProfileImage({
    required String userId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/auth/remove-profile-image/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      print("REMOVE STATUS: ${response.statusCode}");
      print("REMOVE BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("REMOVE IMAGE ERROR: $e");
      return false;
    }
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

  static Future<ProductModel> fetchProductById(String productId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/products/$productId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load product: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> addProduct({
    required Map<String, dynamic> productData,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/products"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(productData),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> addReview({
    required String productId,
    required String userId,
    required String userName,
    required double rating,
    required String title,
    required String comment,
    bool? repurchase,
    bool? improvedSkin,
    bool? wasGift,
    bool? adverseReaction,
    String texture = "",
    String usageWeeks = "",
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/products/$productId/reviews"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "userName": userName,
        "rating": rating,
        "title": title,
        "comment": comment,
        "repurchase": repurchase,
        "improvedSkin": improvedSkin,
        "wasGift": wasGift,
        "adverseReaction": adverseReaction,
        "texture": texture,
        "usageWeeks": usageWeeks,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<UserModel?> fetchUserProfile(String userId) async {
    try {
      final url = Uri.parse("$baseUrl/api/auth/user/$userId");
      print("REQUEST URL: $url");

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("FETCH PROFILE ERROR: $e");
      return null;
    }
  }

  static Future<List<UserCollectionModel>?> addCollection({
    required String userId,
    required String title,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/user/$userId/collections'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'images': [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return (data['collections'] as List<dynamic>)
            .map((e) => UserCollectionModel.fromJson(e))
            .toList();
      } else {
        print('Add collection failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Add collection error: $e');
      return null;
    }
  }

  static Future<bool> updateCollectionName({
    required String collectionId,
    required String newTitle,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/auth/collection/$collectionId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': newTitle,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteCollection({
    required String collectionId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/auth/collection/$collectionId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('deleteCollection STATUS = ${response.statusCode}');
      print('deleteCollection BODY = ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('deleteCollection ERROR = $e');
      return false;
    }
  }

  static Future<List<AdminStoryUserModel>> getAllUsersForAdmin() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/users'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => AdminStoryUserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<int> getProductsCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products/count'));

    print("PRODUCTS COUNT STATUS: ${response.statusCode}");
    print("PRODUCTS COUNT BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception('Failed to load products count');
    }
  }

  static Future<GroupModel> fetchGroupBySlug(String slug) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups/$slug"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return GroupModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch group");
    }
  }

  static Future<List<ProductModel>> fetchGroupProducts(String slug) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups/$slug/products"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch group products");
    }
  }

  static Future<List<GroupModel>> fetchGroups() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => GroupModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch groups");
    }
  }

  static Future<bool> joinGroup({
    required String slug,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/groups/$slug/join"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to join group");
    }
  }

  static Future<bool> fetchJoinStatus({
    required String slug,
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups/$slug/join-status/$userId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["isJoined"] ?? false;
    } else {
      throw Exception("Failed to fetch join status");
    }
  }

  static Future<bool> leaveGroup({
    required String slug,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/groups/$slug/leave"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to leave group");
    }
  }

  static Future<Map<String, dynamic>> addReviewPost({
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    required String productId,
    required String productName,
    required String productImage,
    required double rating,
    required bool? repurchase,
    required bool? improvedSkin,
    required bool? wasGift,
    required bool? adverseReaction,
    required String texture,
    required String usageWeeks,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/group-posts/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "userName": userName,
        "userAvatar": userAvatar,
        "content": content,
        "productId": productId,
        "productName": productName,
        "productImage": productImage,
        "rating": rating,
        "repurchase": repurchase,
        "improvedSkin": improvedSkin,
        "wasGift": wasGift,
        "adverseReaction": adverseReaction,
        "texture": texture,
        "usageWeeks": usageWeeks,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<List<GroupPostModel>> fetchPosts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/group-posts"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => GroupPostModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  static Future<bool> deletePost(String postId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/group-posts/$postId"),
      headers: {"Content-Type": "application/json"},
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/group-posts/$postId/like"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> addComment({
    required String postId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String comment,
    String? parentCommentId,
    String replyToUserName = "",
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/group-posts/$postId/comments"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "userName": userName,
        "userAvatar": userAvatar,
        "comment": comment,
        "parentCommentId": parentCommentId,
        "replyToUserName": replyToUserName,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> toggleSavePost({
    required String userId,
    required String postId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/user/$userId/save-post/$postId"),
      headers: {"Content-Type": "application/json"},
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<List<GroupPostModel>> fetchSavedPosts(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/auth/user/$userId/saved-posts"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => GroupPostModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      throw Exception("Failed to load saved posts");
    }
  }

  static Future<Map<String, dynamic>> toggleCommentLike({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/group-posts/$postId/comments/$commentId/like"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<bool> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/group-posts/$postId/comments/$commentId"),
      headers: {"Content-Type": "application/json"},
    );

    return response.statusCode == 200;
  }

  static Future<bool> editComment({
    required String postId,
    required String commentId,
    required String comment,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/group-posts/$postId/comments/$commentId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "comment": comment,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<List<GroupModel>> fetchGroupsByType(String groupType) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/groups/type/$groupType"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => GroupModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch groups by type");
    }
  }

  static Future<Map<String, dynamic>> addQuestionPost({
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    required String productId,
    required String productName,
    required String productImage,
    required String groupId,
    required String groupTitle,
    required String groupSlug,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/group-posts/question"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "userName": userName,
        "userAvatar": userAvatar,
        "content": content,
        "productId": productId,
        "productName": productName,
        "productImage": productImage,
        "groupId": groupId,
        "groupTitle": groupTitle,
        "groupSlug": groupSlug,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<bool> editPost({
    required String postId,
    required String content,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/group-posts/$postId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "content": content,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> addUpdatePost({
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    required String productId,
    required String productName,
    required String productImage,
    required String groupId,
    required String groupTitle,
    required String groupSlug,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/group-posts/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "userName": userName,
        "userAvatar": userAvatar,
        "content": content,
        "productId": productId,
        "productName": productName,
        "productImage": productImage,
        "groupId": groupId,
        "groupTitle": groupTitle,
        "groupSlug": groupSlug,
      }),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  static Future<String?> uploadPostImage(File imageFile) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/group-posts/upload"),
    );

    request.files.add(
      await http.MultipartFile.fromPath("image", imageFile.path),
    );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data["imageUrl"];
    } else {
      return null;
    }
  }
}
