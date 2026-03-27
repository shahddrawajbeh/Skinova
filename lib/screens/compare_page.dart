import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF8),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF202124)),
        title: Text(
          'Compare',
          style: GoogleFonts.marcellus(
            color: const Color(0xFF202124),
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _compareCard('Product 1')),
                const SizedBox(width: 12),
                Expanded(child: _compareCard('Product 2')),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comparison result',
                    style: GoogleFonts.marcellus(
                      fontSize: 22,
                      color: const Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Here you can compare ingredients, benefits, skin compatibility, and overall score.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compareCard(String title) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E3DE)),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
        ),
      ),
    );
  }
}
