import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkincareFinderPage extends StatefulWidget {
  const SkincareFinderPage({super.key});

  @override
  State<SkincareFinderPage> createState() => _SkincareFinderPageState();
}

class _SkincareFinderPageState extends State<SkincareFinderPage> {
  static const Color bgColor = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color softRose = Color(0xFFCCBDB9);
  static const Color deepRose = Color(0xFF663F44);
  static const Color darkRose = Color(0xFF663F44);
  static const Color textDark = Color(0xFF111111);
  static const Color lineColor = Color(0xFFCCBDB9);
  static const Color buttonColor = Color(0xFFCCBDB9);

  final List<String> productTypes = [
    'Face cream',
    'Face mask',
    'Face scrub',
    'Face mist',
    'Cleanser',
    'Sheet mask',
    'Face toner',
    'Face serum',
    'Eye cream',
    'Sunscreen',
    'Face oil',
    'Aftershave',
    'Shave cream',
    'Repair cream',
  ];

  final List<String> skinSuitability = [
    'Dry',
    'Normal',
    'Combination',
    'Oily',
  ];

  final List<String> productEffects = [
    'Moisturizing',
    'Calming',
    'Anti-acne',
    'Tone evening',
    'Anti-aging',
    'Brightening',
    'Hydrating',
    'Pore minimizing',
    'Soothing',
    'Exfoliating',
  ];

  final Set<String> selectedTypes = {};
  final Set<String> selectedSkinTypes = {};
  final Set<String> selectedEffects = {};

  void _toggleSelection(Set<String> selectedSet, String value) {
    setState(() {
      if (selectedSet.contains(value)) {
        selectedSet.remove(value);
      } else {
        selectedSet.add(value);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      selectedTypes.clear();
      selectedSkinTypes.clear();
      selectedEffects.clear();
    });
  }

  int get totalSelections =>
      selectedTypes.length + selectedSkinTypes.length + selectedEffects.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: cardColor,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: darkRose,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Skincare Finder',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.marcellus(
                        fontSize: 27,
                        color: darkRose,
                        height: 1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _resetFilters,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: softRose,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionContainer(
                      title: 'Product Type',
                      child: _chipWrap(
                        items: productTypes,
                        selectedItems: selectedTypes,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionContainer(
                      title: 'Skin Suitability',
                      child: _chipWrap(
                        items: skinSuitability,
                        selectedItems: selectedSkinTypes,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionContainer(
                      title: 'Product Effects',
                      child: _chipWrap(
                        items: productEffects,
                        selectedItems: selectedEffects,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: bgColor,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'types': selectedTypes.toList(),
                  'skinTypes': selectedSkinTypes.toList(),
                  'effects': selectedEffects.toList(),
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: totalSelections == 0 ? buttonColor : deepRose,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                totalSelections == 0
                    ? 'Show Products'
                    : 'Show Products ($totalSelections)',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionContainer({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: darkRose,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _chipWrap({
    required List<String> items,
    required Set<String> selectedItems,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);

        return GestureDetector(
          onTap: () => _toggleSelection(selectedItems, item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: isSelected ? deepRose : bgColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected ? deepRose : lineColor,
                width: 1,
              ),
            ),
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
