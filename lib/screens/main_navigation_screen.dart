import 'package:flutter/material.dart';
import 'home_screen.dart';
//import 'skinova_product_scanner_screen.dart';
import 'skinova_products_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String userId;

  const MainNavigationScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const Color bgColor = Color(0xFFF6F1F0);
  static const Color primary = Color(0xFFB08A90);
  static const Color ringColor = Color(0xFFB08A90);
  static const Color inactive = Color(0xFF8A7E81);
  static const Color darkRing = Color(0xFFB08A90);

  int selectedIndex = 0;

  List<Widget> get pages => [
        const HomeScreen(),
        const _PlaceholderPage(title: "AI Skinova Chat"),
        const _PlaceholderPage(title: "Scan Skin"),
        SkinovaProductsScreen(userId: widget.userId),
        const _PlaceholderPage(title: "Profile"),
      ];

  final List<IconData> outlinedIcons = const [
    Icons.home_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.camera_alt_outlined,
    Icons.shopping_bag_outlined,
    Icons.person_outline_rounded,
  ];

  final List<IconData> filledIcons = const [
    Icons.home_rounded,
    Icons.chat_bubble_rounded,
    Icons.camera_alt_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  void _onTap(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: pages[selectedIndex],
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          height: 90,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth - 32;
              final itemWidth = barWidth / 5;
              final centerX = 16 + itemWidth * selectedIndex + itemWidth / 2;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: SizedBox(
                      height: 64,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            size: Size(barWidth, 64),
                            painter: _NavBarPainter(
                              color: Colors.white,
                              notchCenterX: centerX - 16,
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: List.generate(5, (index) {
                                final isSelected = selectedIndex == index;

                                return Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _onTap(index),
                                    child: Center(
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 180),
                                        opacity: isSelected ? 0 : 1,
                                        child: Icon(
                                          outlinedIcons[index],
                                          size: 21,
                                          color: inactive,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    left: centerX - 25,
                    bottom: 23,
                    child: GestureDetector(
                      onTap: () => _onTap(selectedIndex),
                      child: _CuteBubble(
                        icon: filledIcons[selectedIndex],
                        iconColor: primary,
                        ringColor: ringColor,
                        darkRing: darkRing,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CuteBubble extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color ringColor;
  final Color darkRing;

  const _CuteBubble({
    required this.icon,
    required this.iconColor,
    required this.ringColor,
    required this.darkRing,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: darkRing,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF663F44).withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ringColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavBarPainter extends CustomPainter {
  final Color color;
  final double notchCenterX;

  _NavBarPainter({
    required this.color,
    required this.notchCenterX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    const radius = 18.0;
    const notchRadius = 28.0;
    const notchDepth = 18.0;

    final path = Path();

    path.moveTo(radius, 0);

    final notchStart = notchCenterX - 34;
    final notchEnd = notchCenterX + 34;

    path.lineTo(notchStart, 0);

    path.cubicTo(
      notchCenterX - 24,
      0,
      notchCenterX - 24,
      notchDepth,
      notchCenterX,
      notchDepth,
    );

    path.cubicTo(
      notchCenterX + 24,
      notchDepth,
      notchCenterX + 24,
      0,
      notchEnd,
      0,
    );

    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();

    canvas.drawShadow(path, Color(0xFF663F44).withOpacity(0.10), 12, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavBarPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX ||
        oldDelegate.color != color;
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F0),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF663F44),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
