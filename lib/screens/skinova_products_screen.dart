import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_page.dart';
import 'search_page.dart';
import 'ask_ai_page.dart';
import 'compare_page.dart';
import 'analyze_page.dart';
import 'cart_screen.dart';
import '../api_service.dart';

class SkinovaProductsScreen extends StatefulWidget {
  final String userId;

  const SkinovaProductsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SkinovaProductsScreen> createState() => _SkinovaProductsScreenState();
}

class _SkinovaProductsScreenState extends State<SkinovaProductsScreen> {
  String selectedConcern = 'All';
  String selectedCategory = 'All';
  String selectedSkinType = 'All';
  String searchQuery = '';
  int cartCount = 0;
  final TextEditingController searchController = TextEditingController();

  final List<String> concerns = const [
    'All',
    'Acne',
    'Dryness',
    'Redness',
    'Dark Spots',
    'Pores',
  ];
  Future<void> loadCartCount() async {
    try {
      final result = await ApiService.fetchCart(widget.userId);

      if (result["statusCode"] == 200) {
        final data = result["data"];
        final items = data["items"] ?? [];

        int totalCount = 0;
        for (final item in items) {
          totalCount += (item["quantity"] as int? ?? 1);
        }

        setState(() {
          cartCount = totalCount;
        });
      }
    } catch (e) {
      // تجاهلي الخطأ مؤقتًا أو اطبعيه
    }
  }

  @override
  void initState() {
    super.initState();
    loadCartCount();
  }

  final List<String> categories = const [
    'All',
    'Cleanser',
    'Toner',
    'Toner Pads',
    'Serum',
    'Moisturizer',
    'Sunscreen',
    'Treatment',
  ];

  final List<String> skinTypes = const [
    'All',
    'Dry',
    'Oily',
    'Combination',
    'Sensitive',
    'Normal',
  ];

  final List<Map<String, dynamic>> quickActions = [
    {
      'title': 'Scan',
      'subtitle': 'Analyze a product by barcode or photo',
      'icon': Icons.document_scanner_outlined,
      'color': const Color(0xFFCCBDB9),
      'border': const Color(0xFFCCBDB9),
      'page': const ScanPage(),
    },
    {
      'title': 'Search',
      'subtitle': 'Find products by type, ingredient, or concern',
      'icon': Icons.search_rounded,
      'color': const Color(0xFFCCBDB9),
      'border': const Color(0xFFCCBDB9),
      'page': const SearchPage(),
    },
    {
      'title': 'Ask AI',
      'subtitle': 'Beauty questions? Skinova can help!',
      'icon': Icons.auto_awesome_outlined,
      'color': const Color(0xFFCCBDB9),
      'border': const Color(0xFFCCBDB9),
      'page': const AskAiPage(),
    },
    {
      'title': 'Compare',
      'subtitle': 'Compare two or more products',
      'icon': Icons.compare_arrows_rounded,
      'color': const Color(0xFFCCBDB9),
      'border': const Color(0xFFCCBDB9),
      'page': const ComparePage(),
    },
    {
      'title': 'Analyze',
      'subtitle': 'Paste ingredients and check if they suit your skin',
      'icon': Icons.science_outlined,
      'color': const Color(0xFFCCBDB9),
      'border': const Color(0xFFCCBDB9),
      'page': const AnalyzePage(),
    },
  ];

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Cicaplast Baume B5+',
      'brand': 'La Roche-Posay',
      'type': 'Moisturizer',
      'concern': 'Redness',
      'skinTypes': ['Dry', 'Sensitive', 'Combination'],
      'score': 91,
      'tag': 'Barrier Repair',
      'emoji': '🧴',
      'color': Color(0xFFE7F0FB),
    },
    {
      'name': 'Heartleaf 77 Clear Pad',
      'brand': 'Anua',
      'type': 'Toner Pads',
      'concern': 'Acne',
      'skinTypes': ['Oily', 'Combination', 'Sensitive'],
      'score': 90,
      'tag': 'Calming',
      'emoji': '🫙',
      'color': Color(0xFFE9EFE7),
    },
    {
      'name': 'Niacinamide 10% + Zinc 1%',
      'brand': 'The Ordinary',
      'type': 'Serum',
      'concern': 'Pores',
      'skinTypes': ['Oily', 'Combination'],
      'score': 93,
      'tag': 'Oil Control',
      'emoji': '💧',
      'color': Color(0xFFF3EEE8),
    },
    {
      'name': 'Glow Milky Toner',
      'brand': 'Anua',
      'type': 'Toner',
      'concern': 'Dryness',
      'skinTypes': ['Dry', 'Normal', 'Sensitive'],
      'score': 89,
      'tag': 'Hydrating',
      'emoji': '🥛',
      'color': Color(0xFFF6F1EB),
    },
    {
      'name': 'Round Lab 1025 Dokdo Toner',
      'brand': 'Round Lab',
      'type': 'Toner',
      'concern': 'Redness',
      'skinTypes': ['Sensitive', 'Combination', 'Normal'],
      'score': 94,
      'tag': 'Sensitive Skin',
      'emoji': '💦',
      'color': Color(0xFFEAF3FA),
    },
    {
      'name': 'Purito Oat-in Calming Gel Cream',
      'brand': 'Purito',
      'type': 'Moisturizer',
      'concern': 'Redness',
      'skinTypes': ['Sensitive', 'Combination', 'Dry'],
      'score': 92,
      'tag': 'Lightweight',
      'emoji': '🌿',
      'color': Color(0xFFEFF5E8),
    },
    {
      'name': 'Beauty of Joseon Relief Sun SPF50+',
      'brand': 'BOJ',
      'type': 'Sunscreen',
      'concern': 'All',
      'skinTypes': ['All'],
      'score': 95,
      'tag': 'Daily SPF',
      'emoji': '☀️',
      'color': Color(0xFFF8F0DF),
    },
    {
      'name': 'Panthenol Skin Barrier Cream',
      'brand': 'Some By Mi',
      'type': 'Moisturizer',
      'concern': 'Dryness',
      'skinTypes': ['Dry', 'Sensitive'],
      'score': 88,
      'tag': 'Barrier Support',
      'emoji': '🧸',
      'color': Color(0xFFF7EEE6),
    },
    {
      'name': 'Azelaic Acid Suspension 10%',
      'brand': 'The Ordinary',
      'type': 'Treatment',
      'concern': 'Dark Spots',
      'skinTypes': ['Combination', 'Oily', 'Normal'],
      'score': 87,
      'tag': 'Brightening',
      'emoji': '✨',
      'color': Color(0xFFF4EFEA),
    },
    {
      'name': 'Salicylic Acid 2% Solution',
      'brand': 'The Ordinary',
      'type': 'Treatment',
      'concern': 'Acne',
      'skinTypes': ['Oily', 'Combination'],
      'score': 86,
      'tag': 'Acne Care',
      'emoji': '🫧',
      'color': Color(0xFFE9F2F5),
    },
    {
      'name': 'Toleriane Hydrating Gentle Cleanser',
      'brand': 'La Roche-Posay',
      'type': 'Cleanser',
      'concern': 'Dryness',
      'skinTypes': ['Dry', 'Sensitive', 'Normal'],
      'score': 90,
      'tag': 'Gentle Cleanse',
      'emoji': '🧼',
      'color': Color(0xFFF4F0ED),
    },
    {
      'name': 'Low pH Good Morning Gel Cleanser',
      'brand': 'COSRX',
      'type': 'Cleanser',
      'concern': 'Acne',
      'skinTypes': ['Oily', 'Combination'],
      'score': 89,
      'tag': 'Fresh Start',
      'emoji': '🫧',
      'color': Color(0xFFEAF4E8),
    },
  ];

  List<Map<String, dynamic>> get featuredPicks => [
        products[0],
        products[6],
        products[10],
        products[5],
      ];

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((p) {
      final String name = (p['name'] as String).toLowerCase();
      final String brand = (p['brand'] as String).toLowerCase();
      final String type = (p['type'] as String).toLowerCase();
      final String concern = (p['concern'] as String).toLowerCase();
      final String tag = (p['tag'] as String).toLowerCase();
      final query = searchQuery.trim().toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          brand.contains(query) ||
          type.contains(query) ||
          concern.contains(query) ||
          tag.contains(query);

      final matchesConcern = selectedConcern == 'All' ||
          p['concern'] == selectedConcern ||
          p['concern'] == 'All';

      final matchesCategory =
          selectedCategory == 'All' || p['type'] == selectedCategory;

      final List skinList = p['skinTypes'] as List;
      final matchesSkinType = selectedSkinType == 'All' ||
          skinList.contains('All') ||
          skinList.contains(selectedSkinType);

      return matchesSearch &&
          matchesConcern &&
          matchesCategory &&
          matchesSkinType;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      selectedConcern = 'All';
      selectedCategory = 'All';
      selectedSkinType = 'All';
      searchQuery = '';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Products',
                            style: GoogleFonts.marcellus(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF202124),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CartScreen(userId: widget.userId),
                              ),
                            );
                            loadCartCount();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFFEAE2DE),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xFF663F44),
                                  size: 22,
                                ),
                              ),
                              if (cartCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF663F44),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$cartCount',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find skincare that matches your skin, concern, and routine.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildQuickActions(),
                    const SizedBox(height: 22),
                    _buildFinderCard(),
                    const SizedBox(height: 24),
                    _sectionTitle('Featured Picks', 'Curated'),
                    const SizedBox(height: 12),
                    _horizontalProducts(featuredPicks),
                    const SizedBox(height: 24),
                    _sectionTitle(
                      'All Products',
                      '${filteredProducts.length} items',
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              sliver: filteredProducts.isEmpty
                  ? SliverToBoxAdapter(
                      child: _emptyState(),
                    )
                  : SliverList.separated(
                      itemCount: filteredProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _productListTile(product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Discover your match',
                style: GoogleFonts.marcellus(
                  fontSize: 22,
                  color: const Color(0xFF202124),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearFilters,
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: Color(0xFF8E6F74),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F3F1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEAE2DE)),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black45),
                hintText: 'Search brand, product, ingredient, or tag',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _filterBlock(
            title: 'Skin Type',
            child: _filterChips(
              items: skinTypes,
              selectedValue: selectedSkinType,
              onSelected: (value) {
                setState(() {
                  selectedSkinType = value;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          _filterBlock(
            title: 'Concern',
            child: _filterChips(
              items: concerns,
              selectedValue: selectedConcern,
              onSelected: (value) {
                setState(() {
                  selectedConcern = value;
                });
              },
              darkSelected: true,
            ),
          ),
          const SizedBox(height: 14),
          _filterBlock(
            title: 'Category',
            child: _filterChips(
              items: categories,
              selectedValue: selectedCategory,
              onSelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBlock({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _filterChips({
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    bool darkSelected = false,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = item == selectedValue;

        return GestureDetector(
          onTap: () => onSelected(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? (darkSelected
                      ? const Color(0xFF202124)
                      : const Color(0xFFCCBDB9))
                  : const Color(0xFFF9F6F4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? (darkSelected
                        ? const Color(0xFF202124)
                        : const Color(0xFFCCBDB9))
                    : const Color(0xFFE8E3DE),
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? (darkSelected ? Colors.white : const Color(0xFF202124))
                    : const Color(0xFF5F5753),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickActions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = quickActions[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => item['page'] as Widget,
                ),
              );
            },
            child: Container(
              width: 185,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: item['border'] as Color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: const Color(0xFF61707B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['title'] as String,
                    style: GoogleFonts.marcellus(
                      fontSize: 18,
                      color: const Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item['subtitle'] as String,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, String action) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.marcellus(
            fontSize: 20,
            color: const Color(0xFF202124),
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _horizontalProducts(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = items[index];
          return _productCard(product);
        },
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    return Container(
      width: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF80A35B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${product['score']}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: product['color'] as Color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  product['emoji'] as String,
                  style: const TextStyle(fontSize: 42),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product['brand'] as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            product['name'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productListTile(Map<String, dynamic> product) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: product['color'] as Color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                product['emoji'] as String,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['brand'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202124),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _miniTag(product['type'] as String),
                    _miniTag(product['tag'] as String),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF80A35B),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${product['score']}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black38,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B625E),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: Colors.black38,
          ),
          SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try changing the skin type, concern, category, or search words.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
