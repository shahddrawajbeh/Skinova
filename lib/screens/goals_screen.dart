import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chronic_conditions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const Color beetroot = Color(0xFF663F44);
  static const Color barelyMauve = Color(0xFFCCBDB9);
  static const Color softLight = Color(0xFFF6F1F0);
  static const Color softRose = Color(0xFFB08A90);

  final int currentStep = 7;
  final int totalSteps = 10;

  final Set<String> selectedGoals = {};

  final List<Map<String, dynamic>> goals = [
    {
      "title": "Fix the concerns of my skin",
      "icon": Icons.monitor_heart_outlined,
      "enabled": true,
    },
    {
      "title": "Track my current skincare routines",
      "icon": Icons.fact_check_outlined,
      "enabled": true,
    },
    {
      "title": "Create new skincare routines",
      "icon": Icons.bookmark_add_outlined,
      "enabled": true,
    },
    {
      "title": "Discover skincare products",
      "icon": Icons.gps_fixed_rounded,
      "enabled": true,
    },
    {
      "title": "Monitor my progress with skin diary",
      "icon": Icons.mood_outlined,
      "enabled": true,
    },
    {
      "title": "Educate myself about skincare",
      "icon": Icons.menu_book_outlined,
      "enabled": true,
    },
    {
      "title": "Learn more about my own skin",
      "icon": Icons.account_tree_outlined,
      "enabled": true,
    },
    {
      "title": "Apply home treatments (e.g. masks)",
      "icon": Icons.home_outlined,
      "enabled": true,
    },
    {
      "title": "Practice facial yoga (coming soon)",
      "icon": Icons.fitness_center_outlined,
      "enabled": false,
    },
  ];

  void toggleGoal(String title) {
    setState(() {
      if (selectedGoals.contains(title)) {
        selectedGoals.remove(title);
      } else {
        selectedGoals.add(title);
      }
    });
  }

  Future<void> saveGoalsAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      print("❌ No userId found");
      return;
    }

    final result = await ApiService.saveOnboarding(
      userId: userId,
      data: {
        "goals": selectedGoals.toList(),
      },
    );

    print("GOALS RESULT: $result");

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChronicConditionsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: barelyMauve.withOpacity(0.45),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: beetroot.withOpacity(0.9),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                totalSteps,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: index == currentStep ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: index <= currentStep
                                        ? softRose
                                        : barelyMauve.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Step 8 of 10',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: beetroot.withOpacity(0.55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "What are your goals?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                color: beetroot,
                                height: 1.18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Choose all that match your skincare journey.\nThis helps us tailor the app to your needs.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                height: 1.6,
                                color: beetroot.withOpacity(0.58),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ...goals.map((item) {
                        final String title = item["title"]?.toString() ?? "";
                        final IconData icon =
                            item["icon"] as IconData? ?? Icons.circle_outlined;
                        final bool enabled = item["enabled"] == true;
                        final bool isSelected = selectedGoals.contains(title);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: enabled ? () => toggleGoal(title) : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOut,
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: !enabled
                                    ? Colors.white.withOpacity(0.45)
                                    : isSelected
                                        ? beetroot
                                        : Colors.white.withOpacity(0.72),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: !enabled
                                      ? barelyMauve.withOpacity(0.30)
                                      : isSelected
                                          ? beetroot
                                          : barelyMauve.withOpacity(0.45),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected && enabled
                                        ? beetroot.withOpacity(0.14)
                                        : Colors.black.withOpacity(0.03),
                                    blurRadius: isSelected && enabled ? 22 : 12,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: !enabled
                                          ? Colors.white.withOpacity(0.55)
                                          : isSelected
                                              ? Colors.white.withOpacity(0.14)
                                              : softRose.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: !enabled
                                            ? barelyMauve.withOpacity(0.22)
                                            : isSelected
                                                ? Colors.white.withOpacity(0.10)
                                                : barelyMauve.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 28,
                                      color: !enabled
                                          ? beetroot.withOpacity(0.28)
                                          : isSelected
                                              ? softLight
                                              : beetroot,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.6,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        color: !enabled
                                            ? beetroot.withOpacity(0.36)
                                            : isSelected
                                                ? softLight
                                                : beetroot,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 240),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected && enabled
                                          ? softLight
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: !enabled
                                            ? barelyMauve.withOpacity(0.45)
                                            : isSelected
                                                ? softLight
                                                : barelyMauve.withOpacity(0.75),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: isSelected && enabled
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: beetroot,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: selectedGoals.isEmpty
                              ? null
                              : () {
                                  saveGoalsAndContinue();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: beetroot,
                            foregroundColor: softLight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${selectedGoals.length} selected",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: softLight.withOpacity(0.82),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
