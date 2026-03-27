import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  static const Color bgColor = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFFFFCFC);
  static const Color softRose = Color(0xFFCCBDB9);
  static const Color deepRose = Color(0xFF663F44);
  static const Color darkRose = Color(0xFF663F44);
  static const Color textDark = Color(0xFF111111);
  static const Color lineColor = Color(0xFFCCBDB9);

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final productTypeController = TextEditingController();
  final imageUrlController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final safetyRatingController = TextEditingController();

  final priceController = TextEditingController();
  final currencyController = TextEditingController(text: "USD");
  final stockCountController = TextEditingController();
  final sizeController = TextEditingController();
  final discountPercentController = TextEditingController(text: "0");
  final ratingController = TextEditingController(text: "0");
  final reviewCountController = TextEditingController(text: "0");

  final benefitsController = TextEditingController();
  final concernTitleController = TextEditingController();
  final concernIngredientsController = TextEditingController();
  final ingredientNameController = TextEditingController();
  final ingredientDescriptionController = TextEditingController();

  bool inStock = true;

  bool alcoholFree = false;
  bool fragranceFree = false;
  bool parabenFree = false;
  bool sulfateFree = false;
  bool vegan = false;
  bool crueltyFree = false;
  bool siliconeFree = false;

  String selectedIngredientStatus = 'good';

  final List<String> benefits = [];
  final List<Map<String, dynamic>> ingredientConcerns = [];
  final List<Map<String, dynamic>> ingredients = [];

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    categoryController.dispose();
    productTypeController.dispose();
    imageUrlController.dispose();
    shortDescriptionController.dispose();
    safetyRatingController.dispose();

    priceController.dispose();
    currencyController.dispose();
    stockCountController.dispose();
    sizeController.dispose();
    discountPercentController.dispose();
    ratingController.dispose();
    reviewCountController.dispose();

    benefitsController.dispose();
    concernTitleController.dispose();
    concernIngredientsController.dispose();
    ingredientNameController.dispose();
    ingredientDescriptionController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(priceController.text.trim());
    final stockCount = int.tryParse(stockCountController.text.trim());
    final discountPercent = int.tryParse(discountPercentController.text.trim());
    final rating = double.tryParse(ratingController.text.trim());
    final reviewCount = int.tryParse(reviewCountController.text.trim());

    if (price == null ||
        stockCount == null ||
        discountPercent == null ||
        rating == null ||
        reviewCount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid numeric values")),
      );
      return;
    }

    if (price < 0 ||
        stockCount < 0 ||
        discountPercent < 0 ||
        rating < 0 ||
        reviewCount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Values cannot be negative")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final body = {
      "name": nameController.text.trim(),
      "brand": brandController.text.trim(),
      "category": categoryController.text.trim(),
      "productType": productTypeController.text.trim(),
      "imageUrl": imageUrlController.text.trim(),
      "shortDescription": shortDescriptionController.text.trim(),
      "safetyRating": safetyRatingController.text.trim(),
      "benefits": benefits,
      "composition": {
        "alcoholFree": alcoholFree,
        "fragranceFree": fragranceFree,
        "parabenFree": parabenFree,
        "sulfateFree": sulfateFree,
        "vegan": vegan,
        "crueltyFree": crueltyFree,
        "siliconeFree": siliconeFree,
      },
      "ingredientConcerns": ingredientConcerns,
      "ingredients": ingredients,
      "price": price,
      "currency": currencyController.text.trim(),
      "inStock": inStock,
      "stockCount": stockCount,
      "size": sizeController.text.trim(),
      "discountPercent": discountPercent,
      "rating": rating,
      "reviewCount": reviewCount,
    };

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:5000/api/products"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addBenefit() {
    final text = benefitsController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      benefits.add(text);
      benefitsController.clear();
    });
  }

  void addConcern() {
    final title = concernTitleController.text.trim();
    final ingredientsText = concernIngredientsController.text.trim();

    if (title.isEmpty || ingredientsText.isEmpty) return;

    final parsedIngredients = ingredientsText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() {
      ingredientConcerns.add({
        "title": title,
        "ingredients": parsedIngredients,
      });
      concernTitleController.clear();
      concernIngredientsController.clear();
    });
  }

  void addIngredient() {
    final name = ingredientNameController.text.trim();
    final description = ingredientDescriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) return;

    setState(() {
      ingredients.add({
        "name": name,
        "status": selectedIngredientStatus,
        "description": description,
      });
      ingredientNameController.clear();
      ingredientDescriptionController.clear();
      selectedIngredientStatus = 'good';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Product',
          style: GoogleFonts.marcellus(
            color: darkRose,
            fontSize: 26,
          ),
        ),
        iconTheme: const IconThemeData(color: darkRose),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _sectionTitle("Basic Info"),
            _card(
              child: Column(
                children: [
                  _textField(nameController, "Product Name"),
                  _textField(brandController, "Brand"),
                  _textField(categoryController, "Category"),
                  _textField(productTypeController, "Product Type"),
                  _textField(imageUrlController, "Image URL"),
                  _textField(shortDescriptionController, "Short Description"),
                  _textField(safetyRatingController, "Safety Rating"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Purchase Info"),
            _card(
              child: Column(
                children: [
                  _textField(
                    priceController,
                    "Price",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _textField(currencyController, "Currency"),
                  _textField(
                    stockCountController,
                    "Stock Count",
                    keyboardType: TextInputType.number,
                  ),
                  _textField(sizeController, "Size"),
                  _textField(
                    discountPercentController,
                    "Discount Percent",
                    keyboardType: TextInputType.number,
                  ),
                  _textField(
                    ratingController,
                    "Rating",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _textField(
                    reviewCountController,
                    "Review Count",
                    keyboardType: TextInputType.number,
                  ),
                  _switchTile(
                    "In Stock",
                    inStock,
                    (v) => setState(() => inStock = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Benefits"),
            _card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _plainField(
                          benefitsController,
                          "Add Benefit",
                        ),
                      ),
                      const SizedBox(width: 10),
                      _smallButton("Add", addBenefit),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: benefits
                        .map(
                          (b) => _chip(
                            b,
                            onDelete: () {
                              setState(() {
                                benefits.remove(b);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Composition"),
            _card(
              child: Column(
                children: [
                  _switchTile(
                    "Alcohol Free",
                    alcoholFree,
                    (v) => setState(() => alcoholFree = v),
                  ),
                  _switchTile(
                    "Fragrance Free",
                    fragranceFree,
                    (v) => setState(() => fragranceFree = v),
                  ),
                  _switchTile(
                    "Paraben Free",
                    parabenFree,
                    (v) => setState(() => parabenFree = v),
                  ),
                  _switchTile(
                    "Sulfate Free",
                    sulfateFree,
                    (v) => setState(() => sulfateFree = v),
                  ),
                  _switchTile(
                    "Vegan",
                    vegan,
                    (v) => setState(() => vegan = v),
                  ),
                  _switchTile(
                    "Cruelty Free",
                    crueltyFree,
                    (v) => setState(() => crueltyFree = v),
                  ),
                  _switchTile(
                    "Silicone Free",
                    siliconeFree,
                    (v) => setState(() => siliconeFree = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Ingredient Concerns"),
            _card(
              child: Column(
                children: [
                  _plainField(concernTitleController, "Concern Title"),
                  const SizedBox(height: 12),
                  _plainField(
                    concernIngredientsController,
                    "Concern Ingredients (comma separated)",
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _smallButton("Add Concern", addConcern),
                  ),
                  const SizedBox(height: 12),
                  ...ingredientConcerns.map(
                    (c) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        c["title"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text((c["ingredients"] as List).join(", ")),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            ingredientConcerns.remove(c);
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle("Ingredients"),
            _card(
              child: Column(
                children: [
                  _plainField(ingredientNameController, "Ingredient Name"),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedIngredientStatus,
                    decoration: _inputDecoration("Ingredient Status"),
                    items: const [
                      DropdownMenuItem(value: 'good', child: Text('good')),
                      DropdownMenuItem(
                          value: 'warning', child: Text('warning')),
                      DropdownMenuItem(
                          value: 'neutral', child: Text('neutral')),
                      DropdownMenuItem(value: 'bad', child: Text('bad')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedIngredientStatus = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _plainField(
                    ingredientDescriptionController,
                    "Ingredient Description",
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _smallButton("Add Ingredient", addIngredient),
                  ),
                  const SizedBox(height: 12),
                  ...ingredients.map(
                    (i) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        i["name"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text("${i["status"]} • ${i["description"]}"),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            ingredients.remove(i);
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepRose,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Save Product",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkRose,
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lineColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: darkRose.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _plainField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: softRose,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF9F4F3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: lineColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: deepRose, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }

  Widget _smallButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: deepRose,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, {required VoidCallback onDelete}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEEE),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: lineColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              size: 16,
              color: darkRose,
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: deepRose,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
      ),
    );
  }
}
