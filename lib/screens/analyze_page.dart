import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyzePage extends StatelessWidget {
  const AnalyzePage({super.key});

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
          'Analyze',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paste ingredients',
                    style: GoogleFonts.marcellus(
                      fontSize: 24,
                      color: const Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add a product ingredient list and Skinova will help you understand if it matches your skin.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFAF8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8E3DE)),
                    ),
                    child: const TextField(
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: 'Paste full ingredients here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF202124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Analyze Ingredients',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
