import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_product_page.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const Color bgColor = Color(0xFFF7F7F7);
  static const Color cardColor = Color(0xFFFFFCFC);
  static const Color softRose = Color(0xFFCCBDB9);
  static const Color deepRose = Color(0xFF663F44);
  static const Color darkRose = Color(0xFF663F44);
  static const Color textDark = Color(0xFF111111);
  static const Color lineColor = Color(0xFFCCBDB9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Skinova Admin',
                    style: GoogleFonts.marcellus(
                      fontSize: 30,
                      color: darkRose,
                    ),
                  ),
                  const Spacer(),
                  _iconButton(
                    icon: Icons.logout_rounded,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Manage products and store content',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: softRose,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: lineColor),
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
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: deepRose.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: deepRose,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Admin',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You can add, edit, and manage products from here.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: softRose,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: darkRose,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.03,
                children: [
                  _actionCard(
                    title: 'Add Product',
                    subtitle: 'Create a new product entry',
                    icon: Icons.add_box_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductPage(),
                        ),
                      );
                    },
                  ),
                  _actionCard(
                    title: 'Manage Products',
                    subtitle: 'Edit or delete products',
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      // TODO: open manage products page
                    },
                  ),
                  _actionCard(
                    title: 'View Products',
                    subtitle: 'See current store products',
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      // TODO: open products list
                    },
                  ),
                  _actionCard(
                    title: 'Users',
                    subtitle: 'View user accounts later',
                    icon: Icons.people_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                'Overview',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: darkRose,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _statCard('24', 'Products')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('18', 'Published')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('6', 'Drafts')),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Text(
                    'Recent Products',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: darkRose,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'See all',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: softRose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _recentProductTile(
                brand: 'La Roche-Posay',
                name: 'Toleriane Ultra Eye Cream',
                category: 'Eye Care',
              ),
              const SizedBox(height: 12),
              _recentProductTile(
                brand: 'SKIN1004',
                name: 'Madagascar Centella Ampoule Foam',
                category: 'Cleanser',
              ),
              const SizedBox(height: 12),
              _recentProductTile(
                brand: 'Beauty of Joseon',
                name: 'Relief Sun SPF50+',
                category: 'Sunscreen',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddProductPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepRose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Add New Product',
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
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: lineColor),
        ),
        child: Icon(icon, color: darkRose, size: 22),
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: lineColor),
          boxShadow: [
            BoxShadow(
              color: darkRose.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: deepRose.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: deepRose),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: softRose,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lineColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: deepRose,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: softRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentProductTile({
    required String brand,
    required String name,
    required String category,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lineColor),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: deepRose.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: deepRose,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: softRose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: deepRose.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: deepRose,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: softRose,
          ),
        ],
      ),
    );
  }
}
