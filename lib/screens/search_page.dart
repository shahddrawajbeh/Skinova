import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'skincare_finder_page.dart';
import '../product_model.dart';
import '../api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Color bgColor = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color softRose = Color(0xFFCCBDB9);
  static const Color deepRose = Color(0xFF663F44);
  static const Color darkRose = Color(0xFF663F44);
  static const Color textDark = Color(0xFF111111);
  static const Color lineColor = Color(0xFFF7F7F7);

  Set<String> favoriteIds = {};
  String? currentUserId;
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  Future<void> loadUserAndFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) return;

    currentUserId = userId;

    try {
      final favoriteProducts = await ApiService.fetchFavorites(userId);
      setState(() {
        favoriteIds = favoriteProducts.map((e) => e.id).toSet();
      });
    } catch (e) {
      print("Favorites load error: $e");
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (currentUserId == null) return;

    try {
      final result = await ApiService.toggleFavorite(
        userId: currentUserId!,
        productId: product.id,
      );

      if (result["statusCode"] == 200) {
        final isFavorite = result["data"]["isFavorite"];

        setState(() {
          if (isFavorite == true) {
            favoriteIds.add(product.id);
          } else {
            favoriteIds.remove(product.id);
          }
        });
      }
    } catch (e) {
      print("Toggle favorite error: $e");
    }
  }

  final List<String> categories = const [
    'All',
    'Cleanser',
    'Toner',
    'Moisturizer',
    'Serum',
    'Sunscreen',
    'Sheet Mask',
    'Eye Care',
    'Exfoliators',
    'Treatment',
  ];
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;

      final query = searchController.text.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          product.brand.toLowerCase().contains(query) ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadUserAndFavorites();
  }

  Future<void> addProductToCart(ProductModel product) async {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in first")),
      );
      return;
    }

    try {
      final result = await ApiService.addToCart(
        userId: currentUserId!,
        productId: product.id,
        quantity: 1,
      );

      if (result["statusCode"] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF663F44),
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            duration: const Duration(seconds: 2),
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Product added to cart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product to cart")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> loadProducts() async {
    try {
      final fetchedProducts = await ApiService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: lineColor, width: 1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: darkRose,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Discover',
                    style: GoogleFonts.marcellus(
                      fontSize: 27,
                      color: darkRose,
                      height: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: lineColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkRose.withOpacity(0.025),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: softRose,
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (_) => setState(() {}),
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: textDark,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search products, brands...',
                                hintStyle: GoogleFonts.poppins(
                                  color: softRose,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SkincareFinderPage(),
                        ),
                      );

                      if (result != null) {
                        print(result);
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: lineColor,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkRose.withOpacity(0.025),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: deepRose,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        decoration: BoxDecoration(
                          color: isSelected ? deepRose : cardColor,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(
                            color: isSelected ? deepRose : lineColor,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : softRose,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Text(
                    'All Products',
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: darkRose,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredProducts.length} items',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: softRose,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Text(
                              errorMessage!,
                              style: GoogleFonts.poppins(),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return _productCard(product);
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        // لاحقًا: ننتقل لصفحة Product Details
      },
      child: Container(
        height: 162,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: lineColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: darkRose.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 93,
              height: 93,
              decoration: BoxDecoration(
                color: const Color(0xFFF4EEEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            "No Image",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: softRose,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        toggleFavorite(product);
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          favoriteIds.contains(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 15,
                          color: const Color(0xFFFF8E8E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 98,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textDark,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "by ${product.brand}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: softRose,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3D345D),
                            height: 1,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            addProductToCart(product);
                          },
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF663F44),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Add to cart",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
