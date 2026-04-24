import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../product_model.dart';
import '../api_service.dart';
import '../review_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  final String userId;
  final String userName;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.userId,
    required this.userName,
  });
  Color _getPostTypeColor(String postType) {
    switch (postType.toLowerCase()) {
      case "question":
        return const Color(0xFFF3D86B);
      case "review":
        return const Color(0xFF6BA4D9);
      case "update":
        return const Color(0xFF8BC48A);
      default:
        return const Color(0xFFB0B0B0);
    }
  }

  Color _getPostTypeTextColor(String postType) {
    switch (postType.toLowerCase()) {
      case "question":
        return const Color(0xFF5A4A00);
      case "review":
        return Colors.white;
      case "update":
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const Color whiteSmoke = Color(0xFFF7F4F3);
  static const Color wine = Color(0xFF5B2333);

  bool isFavorite = false;
  bool isFavoriteLoading = false;
  bool isCartLoading = false;

  bool favoriteChanged = false;
  late List<ReviewModel> displayedReviews;
  late double displayedRating;
  Future<void> _loadLatestProduct() async {
    try {
      final updatedProduct =
          await ApiService.fetchProductById(widget.product.id);

      if (!mounted) return;

      setState(() {
        displayedReviews = List<ReviewModel>.from(updatedProduct.reviews);
        displayedRating = updatedProduct.rating;
      });
    } catch (e) {
      debugPrint("Load latest product error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    displayedReviews = List<ReviewModel>.from(widget.product.reviews);
    loadFavoriteState();
    displayedRating = widget.product.rating;
    _loadLatestProduct();
  }

  Future<void> _openReviewSheet() async {
    int currentStep = 1;
    int selectedStars = 0;
    final TextEditingController reviewController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: const EdgeInsets.only(top: 24),
              padding: EdgeInsets.fromLTRB(
                22,
                22,
                22,
                22 + MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (currentStep == 1) ...[
                      Text(
                        "How was the product?",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Share your experience with the community.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedStars = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                index < selectedStars
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 44,
                                color: index < selectedStars
                                    ? wine
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ] else ...[
                      Text(
                        "Tell others about the product",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Share helpful details with the community.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: reviewController,
                        maxLines: 6,
                        onChanged: (_) {
                          setModalState(() {});
                        },
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              "Consider including how you used it, what you liked, and any tips for others.",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black45,
                            height: 1.7,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: wine),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: currentStep == 1 ? 0.5 : 1.0,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(wine),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        if (currentStep == 2)
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                currentStep = 1;
                              });
                            },
                            child: Text(
                              "Back",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        const Spacer(),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: currentStep == 1
                                ? (selectedStars == 0
                                    ? null
                                    : () {
                                        setModalState(() {
                                          currentStep = 2;
                                        });
                                      })
                                : (reviewController.text.trim().isEmpty
                                    ? null
                                    : () async {
                                        try {
                                          final result =
                                              await ApiService.addReview(
                                            productId: widget.product.id,
                                            userId: widget.userId,
                                            userName: widget.userName,
                                            rating: selectedStars.toDouble(),
                                            title: "",
                                            comment:
                                                reviewController.text.trim(),
                                            repurchase: null,
                                            improvedSkin: null,
                                            wasGift: null,
                                            adverseReaction: null,
                                            texture: "",
                                            usageWeeks: "",
                                          );

                                          if (!mounted) return;

                                          if (result["statusCode"] == 201) {
                                            await _loadLatestProduct();

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Review added"),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Failed to add review"),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (!mounted) return;

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Something went wrong"),
                                            ),
                                          );
                                        }
                                      }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: wine,
                              disabledBackgroundColor: Colors.grey.shade200,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              currentStep == 1 ? "Next" : "Done",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: currentStep == 1
                                    ? (selectedStars == 0
                                        ? Colors.black26
                                        : Colors.white)
                                    : (reviewController.text.trim().isEmpty
                                        ? Colors.black26
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadFavoriteState() async {
    try {
      final favoriteProducts = await ApiService.fetchFavorites(widget.userId);

      if (!mounted) return;

      setState(() {
        isFavorite = favoriteProducts.any((e) => e.id == widget.product.id);
      });
    } catch (e) {
      debugPrint("Favorites load error: $e");
    }
  }

  Future<void> _toggleFavorite() async {
    if (isFavoriteLoading) return;

    setState(() {
      isFavoriteLoading = true;
      favoriteChanged = true;
    });

    try {
      final result = await ApiService.toggleFavorite(
        userId: widget.userId,
        productId: widget.product.id,
      );

      if (!mounted) return;

      if (result["statusCode"] == 200) {
        final favoriteState = result["data"]["isFavorite"];

        setState(() {
          isFavorite = favoriteState == true;
        });
      }
    } catch (e) {
      debugPrint("Toggle favorite error: $e");
    } finally {
      if (!mounted) return;

      setState(() {
        isFavoriteLoading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    if (isCartLoading) return;

    setState(() {
      isCartLoading = true;
    });

    try {
      await ApiService.addToCart(
        userId: widget.userId,
        productId: widget.product.id,
        quantity: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Added to cart"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add to cart"),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isCartLoading = false;
      });
    }
  }

  Widget _recommendedLine(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 17,
              color: wine,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: wine,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: wine.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final double finalPrice = product.discountPercent > 0
        ? product.price - (product.price * product.discountPercent / 100)
        : product.price;

    final whatsInsideMap = {
      "Alcohol Free": product.whatsInside.alcoholFree,
      "EU Allergen Free": product.whatsInside.euAllergenFree,
      "Fragrance Free": product.whatsInside.fragranceFree,
      "Oil Free": product.whatsInside.oilFree,
      "Paraben Free": product.whatsInside.parabenFree,
      "Silicone Free": product.whatsInside.siliconeFree,
      "Sulfate Free": product.whatsInside.sulfateFree,
      "Cruelty Free": product.whatsInside.crueltyFree,
      "Fungal Acne Safe": product.whatsInside.fungalAcneSafe,
      "Reef Safe": product.whatsInside.reefSafe,
      "Vegan": product.whatsInside.vegan,
    };

    final bool hasRecommendedFor =
        product.recommendedFor.skinTypes.isNotEmpty ||
            product.recommendedFor.concerns.isNotEmpty ||
            product.recommendedFor.goals.isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, favoriteChanged);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  onPressed: isFavoriteLoading ? null : _toggleFavorite,
                  icon: isFavoriteLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: wine,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        product.inStock && !isCartLoading ? _addToCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: wine,
                      disabledBackgroundColor: wine.withOpacity(0.35),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isCartLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                product.inStock ? "Add to Cart" : "Unavailable",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              iconTheme: const IconThemeData(color: wine),
              expandedHeight: 360,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 90, 24, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: product.imageUrl.isNotEmpty
                          ? Hero(
                              tag: product.id,
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    _imagePlaceholder(),
                              ),
                            )
                          : _imagePlaceholder(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: wine.withOpacity(0.45),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: GoogleFonts.marcellus(
                        fontSize: 30,
                        height: 1.28,
                        color: wine,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: wine, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          displayedRating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: wine,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: wine,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          "${displayedReviews.length} Reviews",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: wine.withOpacity(0.72),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          "${finalPrice.toStringAsFixed(2)} ${product.currency}",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: wine,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (product.discountPercent > 0)
                          Text(
                            "${product.price.toStringAsFixed(2)} ${product.currency}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: wine.withOpacity(0.35),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (product.shortDescription.isNotEmpty)
                      Text(
                        product.shortDescription,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.75,
                          color: wine.withOpacity(0.78),
                        ),
                      ),
                    const SizedBox(height: 26),
                    _divider(),
                    const SizedBox(height: 22),
                    _sectionTitle("Overview"),
                    const SizedBox(height: 14),
                    _infoRow(
                      "Availability",
                      product.inStock ? "In Stock" : "Out of Stock",
                    ),
                    _infoRow("Stock Count", "${product.stockCount}"),
                    if (product.size.isNotEmpty) _infoRow("Size", product.size),
                    if (product.brandOrigin.isNotEmpty)
                      _infoRow("Brand Origin", product.brandOrigin),
                    if (product.discountPercent > 0)
                      _infoRow("Discount", "${product.discountPercent}%"),
                    if (hasRecommendedFor) ...[
                      const SizedBox(height: 28),
                      _divider(),
                      const SizedBox(height: 22),
                      _sectionTitle("Recommended For"),
                      const SizedBox(height: 16),
                      if (product.recommendedFor.skinTypes.isNotEmpty)
                        _recommendedLine(
                          Icons.water_drop_outlined,
                          "Best for skin types",
                          product.recommendedFor.skinTypes.join(", "),
                        ),
                      if (product.recommendedFor.concerns.isNotEmpty)
                        _recommendedLine(
                          Icons.track_changes_outlined,
                          "Targets concerns",
                          product.recommendedFor.concerns.join(", "),
                        ),
                      if (product.recommendedFor.goals.isNotEmpty)
                        _recommendedLine(
                          Icons.auto_awesome_outlined,
                          "Helps with",
                          product.recommendedFor.goals.join(", "),
                        ),
                    ],
                    const SizedBox(height: 28),
                    _divider(),
                    const SizedBox(height: 22),
                    _sectionTitle("What’s Inside"),
                    const SizedBox(height: 14),
                    Column(
                      children: whatsInsideMap.entries.map((entry) {
                        final name = entry.key;
                        final value = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Icon(
                                value ? Icons.check_circle : Icons.cancel,
                                color: value ? Colors.green : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: wine,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    _divider(),
                    const SizedBox(height: 22),
                    _sectionTitle("Ingredients"),
                    const SizedBox(height: 14),
                    product.ingredients.isEmpty
                        ? _emptyText("No ingredients added yet.")
                        : Column(
                            children: product.ingredients
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final ingredient = entry.value;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      index == product.ingredients.length - 1
                                          ? 0
                                          : 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ingredient.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: wine,
                                      ),
                                    ),
                                    if (ingredient.description.isNotEmpty)
                                      const SizedBox(height: 6),
                                    if (ingredient.description.isNotEmpty)
                                      Text(
                                        ingredient.description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          height: 1.7,
                                          color: wine.withOpacity(0.76),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 28),
                    _divider(),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        _sectionTitle("Reviews"),
                        const Spacer(),
                        GestureDetector(
                            onTap: _openReviewSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: wine,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.edit,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Write review",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 14),
                    displayedReviews.isEmpty
                        ? _emptyText("No reviews yet.")
                        : Column(
                            children:
                                displayedReviews.asMap().entries.map((entry) {
                              final index = entry.key;
                              final review = entry.value;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == displayedReviews.length - 1
                                      ? 0
                                      : 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: whiteSmoke,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// 👤 user + stars
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                wine.withOpacity(0.15),
                                            child: Text(
                                              review.userName.isNotEmpty
                                                  ? review.userName[0]
                                                      .toUpperCase()
                                                  : "A",
                                              style: GoogleFonts.poppins(
                                                color: wine,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          /// name + stars
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review.userName.isEmpty
                                                      ? "Anonymous"
                                                      : review.userName,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: wine,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                    (starIndex) => Icon(
                                                      starIndex <
                                                              review.rating
                                                                  .round()
                                                          ? Icons.star_rounded
                                                          : Icons
                                                              .star_border_rounded,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      /// 💬 comment
                                      if (review.comment.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          review.comment,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            height: 1.7,
                                            color: wine.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.marcellus(
        fontSize: 22,
        color: wine,
      ),
    );
  }

  Widget _subTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: wine.withOpacity(0.55),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: wine.withOpacity(0.48),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: wine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _simpleWrap(List<String> items) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: whiteSmoke,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            item,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: wine,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: wine.withOpacity(0.08),
    );
  }

  Widget _emptyText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: wine.withOpacity(0.5),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 64,
        color: wine.withOpacity(0.28),
      ),
    );
  }
}
