import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'skinova_products_screen.dart';
import 'profile_screen.dart';
import 'package:skinnova/screens/post_page.dart';

class MainNavigationScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const MainNavigationScreen(
      {super.key, required this.userId, required this.userName});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const Color whiteSmoke = Color(0xFFF7F4F3);
  static const Color wine = Color(0xFF5B2333);

  int selectedIndex = 0;

  List<Widget> get pages => [
        const HomeScreen(),
        PostPage(
          userId: widget.userId,
          userName: widget.userName,
        ),
        const _PlaceholderPage(title: "Scan"),
        SkinovaProductsScreen(userId: widget.userId, userName: widget.userName),
        ProfileScreen(userId: widget.userId),
      ];

  final List<IconData> navIcons = const [
    Icons.home_outlined,
    Icons.article_outlined,
    Icons.qr_code_scanner_rounded,
    Icons.shopping_bag_outlined,
    Icons.person_outline_rounded,
  ];

  void _onTap(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteSmoke,
      body: pages[selectedIndex],
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: wine.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(navIcons.length, (index) {
              final isSelected = selectedIndex == index;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _onTap(index),
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          navIcons[index],
                          size: 18,
                          color: isSelected ? wine : Colors.black87,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _navLabel(index),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? wine : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

String _navLabel(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Posts';
    case 2:
      return 'Scan';
    case 3:
      return 'Products';
    case 4:
      return 'Profile';
    default:
      return '';
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F3),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF5B2333),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
