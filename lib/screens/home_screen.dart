// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../api_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   static const Color beetroot = Color(0xFF663F44);
//   static const Color barelyMauve = Color(0xFFCCBDB9);
//   static const Color softLight = Color(0xFFF6F1F0);
//   static const Color softRose = Color(0xFFB08A90);
//   static const Color cardWhite = Color(0xFFFFFCFC);
//   Map<String, dynamic>? userData;
//   bool isLoading = true;

//   final List<Map<String, dynamic>> quickActions = [
//     {
//       "title": "Scan Skin",
//       "icon": Icons.document_scanner_outlined,
//     },
//     {
//       "title": "Routine",
//       "icon": Icons.checklist_rounded,
//     },
//     {
//       "title": "AI Chat",
//       "icon": Icons.auto_awesome_rounded,
//     },
//   ];

//   final List<Map<String, dynamic>> routineSteps = [
//     {
//       "title": "Gentle Cleanser",
//       "done": true,
//     },
//     {
//       "title": "Hydrating Serum",
//       "done": false,
//     },
//     {
//       "title": "SPF 50 Sunscreen",
//       "done": false,
//     },
//   ];

//   final List<Map<String, dynamic>> products = [
//     {
//       "name": "Barrier Moisturizer",
//       "subtitle": "Hydration support",
//       "icon": Icons.favorite_border_rounded,
//     },
//     {
//       "name": "Niacinamide Serum",
//       "subtitle": "Pores & oil balance",
//       "icon": Icons.opacity_rounded,
//     },
//     {
//       "name": "Daily SPF",
//       "subtitle": "UV protection",
//       "icon": Icons.wb_sunny_outlined,
//     },
//   ];
//   Future<void> loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("userId");

//     if (userId == null) {
//       setState(() => isLoading = false);
//       return;
//     }

//     final result = await ApiService.getUserProfile(userId: userId);

//     if (result["statusCode"] == 200) {
//       setState(() {
//         userData = result["data"];
//         isLoading = false;
//       });
//     } else {
//       setState(() => isLoading = false);
//     }
//   }

//   String buildInsight(
//     List<String> skinConcerns,
//     String skinSensitivity,
//   ) {
//     if (skinConcerns.contains("Redness")) {
//       return "Focus on calming and hydrating your skin today.";
//     }

//     if (skinConcerns.contains("Acne & Blemishes")) {
//       return "Keep your routine gentle and consistent to support clearer skin.";
//     }

//     if (skinSensitivity == "Very sensitive") {
//       return "Use fragrance-free and barrier-friendly products today.";
//     }

//     return "Your skin looks balanced. Stay consistent with your routine.";
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fullName = userData?["fullName"] ?? "Beautiful";
//     final onboarding = userData?["onboarding"] ?? {};

//     final skinType = onboarding["skinType"] ?? "Your Skin";
//     final skinSensitivity = onboarding["skinSensitivity"] ?? "Unknown";
//     final skinConcerns = List<String>.from(onboarding["skinConcerns"] ?? []);
//     return Scaffold(
//       backgroundColor: softLight,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
//           children: [
//             _buildHeader(fullName),
//             const SizedBox(height: 22),
//             _buildMainSkinCard(
//               skinType,
//               skinSensitivity,
//               skinConcerns,
//             ),
//             const SizedBox(height: 22),
//             _buildQuickActions(),
//             const SizedBox(height: 22),
//             _buildRoutineCard(),
//             const SizedBox(height: 22),
//             _buildProductsSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(String fullName) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Good Morning, $fullName ✨",
//                 style: GoogleFonts.poppins(
//                   fontSize: 23,
//                   fontWeight: FontWeight.w700,
//                   color: beetroot,
//                   height: 1.15,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 "Let’s take care of your skin today.",
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: beetroot.withOpacity(0.56),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.88),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: barelyMauve.withOpacity(0.25),
//             ),
//           ),
//           child: Icon(
//             Icons.notifications_none_rounded,
//             color: beetroot,
//             size: 24,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMainSkinCard(
//     String skinType,
//     String skinSensitivity,
//     List<String> skinConcerns,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: beetroot,
//         borderRadius: BorderRadius.circular(32),
//         boxShadow: [
//           BoxShadow(
//             color: beetroot.withOpacity(0.16),
//             blurRadius: 26,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Your Skin Today",
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: softLight.withOpacity(0.82),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             skinType,
//             style: GoogleFonts.poppins(
//               fontSize: 27,
//               fontWeight: FontWeight.w700,
//               color: softLight,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildInfoPill(skinSensitivity),
//               _buildInfoPill("${skinConcerns.length} concerns"),
//               _buildInfoPill("Profile ready"),
//             ],
//           ),
//           const SizedBox(height: 18),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.16),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(
//                     Icons.auto_awesome_rounded,
//                     color: softLight,
//                     size: 21,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "AI Insight: ${buildInsight(skinConcerns, skinSensitivity)}",
//                     style: GoogleFonts.poppins(
//                       fontSize: 13.4,
//                       height: 1.55,
//                       color: softLight.withOpacity(0.92),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),
//           SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: softLight,
//                 foregroundColor: beetroot,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//               child: Text(
//                 "Scan My Skin",
//                 style: GoogleFonts.poppins(
//                   fontSize: 15.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoPill(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.11),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.08),
//         ),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.poppins(
//           fontSize: 12.3,
//           color: softLight.withOpacity(0.92),
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionTitle("Quick Actions"),
//         const SizedBox(height: 12),
//         Row(
//           children: List.generate(quickActions.length, (index) {
//             final item = quickActions[index];
//             return Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   right: index != quickActions.length - 1 ? 12 : 0,
//                 ),
//                 child: Container(
//                   height: 112,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.85),
//                     borderRadius: BorderRadius.circular(26),
//                     border: Border.all(
//                       color: barelyMauve.withOpacity(0.20),
//                     ),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(26),
//                     onTap: () {},
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: softRose.withOpacity(0.12),
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           child: Icon(
//                             item["icon"] as IconData,
//                             color: beetroot,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           item["title"] as String,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12.8,
//                             fontWeight: FontWeight.w500,
//                             color: beetroot,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildRoutineCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.85),
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(
//           color: barelyMauve.withOpacity(0.20),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionTitle("Today's Routine"),
//           const SizedBox(height: 4),
//           Text(
//             "Morning routine",
//             style: GoogleFonts.poppins(
//               fontSize: 13.3,
//               color: beetroot.withOpacity(0.55),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ...routineSteps.map(
//             (step) => Padding(
//               padding: const EdgeInsets.only(bottom: 13),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: (step["done"] as bool)
//                           ? beetroot
//                           : Colors.transparent,
//                       border: Border.all(
//                         color: (step["done"] as bool)
//                             ? beetroot
//                             : barelyMauve.withOpacity(0.70),
//                         width: 1.4,
//                       ),
//                     ),
//                     child: (step["done"] as bool)
//                         ? const Icon(
//                             Icons.check_rounded,
//                             size: 14,
//                             color: softLight,
//                           )
//                         : null,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       step["title"] as String,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14.2,
//                         fontWeight: FontWeight.w500,
//                         color: beetroot,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           TextButton(
//             onPressed: () {},
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.zero,
//             ),
//             child: Text(
//               "See full routine",
//               style: GoogleFonts.poppins(
//                 fontSize: 13.5,
//                 fontWeight: FontWeight.w600,
//                 color: softRose,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionTitle("Recommended for You"),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 172,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: products.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (context, index) {
//               final item = products[index];
//               return Container(
//                 width: 172,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.85),
//                   borderRadius: BorderRadius.circular(26),
//                   border: Border.all(
//                     color: barelyMauve.withOpacity(0.20),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: softRose.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Icon(
//                         item["icon"] as IconData,
//                         color: beetroot,
//                         size: 24,
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       item["name"] as String,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14.4,
//                         fontWeight: FontWeight.w600,
//                         color: beetroot,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       item["subtitle"] as String,
//                       style: GoogleFonts.poppins(
//                         fontSize: 12.6,
//                         color: beetroot.withOpacity(0.56),
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: GoogleFonts.poppins(
//         fontSize: 19,
//         fontWeight: FontWeight.w700,
//         color: beetroot,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color beetroot = Color(0xFF663F44);
  static const Color barelyMauve = Color(0xFFCCBDB9);
  static const Color softLight = Color(0xFFF6F1F0);
  static const Color softRose = Color(0xFFB08A90);
  static const Color cardWhite = Color(0xFFFFFCFC);
  static const Color paleRose = Color(0xFFF3ECEC);

  Map<String, dynamic>? userData;
  bool isLoading = true;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await ApiService.getUserProfile(userId: userId);

    if (result["statusCode"] == 200) {
      setState(() {
        userData = result["data"];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  String buildInsight(List<String> skinConcerns, String skinSensitivity) {
    if (skinConcerns.contains("Redness")) {
      return "Focus on calming and hydrating your skin today.";
    }

    if (skinConcerns.contains("Acne & Blemishes")) {
      return "Keep your routine gentle and consistent to support clearer skin.";
    }

    if (skinSensitivity == "Very sensitive") {
      return "Use fragrance-free and barrier-friendly products today.";
    }

    return "Your skin looks balanced. Stay consistent with your routine.";
  }

  List<Map<String, dynamic>> buildQuickActions() {
    return [
      {
        "title": "Scan Skin",
        "icon": Icons.document_scanner_outlined,
        "highlight": true,
      },
      {
        "title": "Routine",
        "icon": Icons.auto_awesome_outlined,
        "highlight": false,
      },
      {
        "title": "AI Chat",
        "icon": Icons.chat_bubble_outline_rounded,
        "highlight": false,
      },
    ];
  }

  List<Map<String, dynamic>> buildRoutineSteps(
    List<String> skinConcerns,
    String skinSensitivity,
    String experience,
  ) {
    if (skinSensitivity == "Very sensitive") {
      return [
        {"title": "Gentle Foaming Cleanser", "step": 1},
        {"title": "Barrier Repair Moisturizer", "step": 2},
        {"title": "Mineral SPF 50", "step": 3},
      ];
    }

    if (skinConcerns.contains("Acne & Blemishes")) {
      return [
        {"title": "Gentle Foaming Cleanser", "step": 1},
        {"title": "Salicylic Acid Treatment", "step": 2},
        {"title": "Niacinamide 10% Serum", "step": 3},
      ];
    }

    if (experience == "I have no idea") {
      return [
        {"title": "Gentle Cleanser", "step": 1},
        {"title": "Moisturizer", "step": 2},
        {"title": "SPF 50 Sunscreen", "step": 3},
      ];
    }

    return [
      {"title": "Gentle Foaming Cleanser", "step": 1},
      {"title": "Niacinamide 10% Serum", "step": 2},
      {"title": "Barrier Repair Moisturizer", "step": 3},
    ];
  }

  List<Map<String, dynamic>> buildProducts(
    List<String> skinConcerns,
    String skinSensitivity,
  ) {
    if (skinConcerns.contains("Acne & Blemishes")) {
      return [
        {
          "brand": "SKINOVA LABS",
          "name": "Gentle Foaming Cleanser",
          "subtitle": "Perfect for your combination skin to clean gently.",
          "price": "\$28",
        },
        {
          "brand": "SKINOVA LABS",
          "name": "Niacinamide 10% Serum",
          "subtitle": "Targets your pore concerns while helping with oil.",
          "price": "\$42",
        },
      ];
    }

    if (skinSensitivity == "Very sensitive") {
      return [
        {
          "brand": "SKINOVA LABS",
          "name": "Barrier Cream Cleanser",
          "subtitle": "Extra gentle support for sensitive skin.",
          "price": "\$26",
        },
        {
          "brand": "SKINOVA LABS",
          "name": "Barrier Moisturizer",
          "subtitle": "Helps protect and comfort irritated skin.",
          "price": "\$38",
        },
      ];
    }

    return [
      {
        "brand": "SKINOVA LABS",
        "name": "Glow Cleanser",
        "subtitle": "Soft cleanse for daily radiance and comfort.",
        "price": "\$24",
      },
      {
        "brand": "SKINOVA LABS",
        "name": "Hydrating Serum",
        "subtitle": "Supports hydration and smooth texture.",
        "price": "\$36",
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final fullName = userData?["fullName"] ?? "Nuha";
    final onboarding = userData?["onboarding"] ?? {};

    final skinType = onboarding["skinType"] ?? "Your Skin";
    final skinSensitivity = onboarding["skinSensitivity"] ?? "Unknown";
    final skinConcerns = List<String>.from(onboarding["skinConcerns"] ?? []);
    final experience = onboarding["skincareExperience"] ?? "";

    final quickActions = buildQuickActions();
    final routineSteps =
        buildRoutineSteps(skinConcerns, skinSensitivity, experience);
    final products = buildProducts(skinConcerns, skinSensitivity);

    return Scaffold(
      backgroundColor: softLight,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                children: [
                  _buildTopSummary(
                      fullName,
                      skinType,
                      skinSensitivity,
                      skinConcerns,
                      buildInsight(skinConcerns, skinSensitivity)),
                  const SizedBox(height: 18),
                  _buildQuickActions(quickActions),
                  const SizedBox(height: 18),
                  _buildRoutineSection(routineSteps),
                  const SizedBox(height: 18),
                  _buildProductsSection(products),
                  const SizedBox(height: 18),
                  _buildProgressSection(),
                ],
              ),
      ),
    );
  }

  Widget _buildTopSummary(
    String fullName,
    String skinType,
    String skinSensitivity,
    List<String> skinConcerns,
    String insight,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: barelyMauve.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Good evening, $fullName",
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: beetroot,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: paleRose,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  fullName.isNotEmpty ? fullName[0].toUpperCase() : "S",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: beetroot,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "Ready to glow today?",
            style: GoogleFonts.poppins(
              fontSize: 12.4,
              color: beetroot.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "Your Skin Profile",
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: beetroot.withOpacity(0.82),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _miniPill(skinType),
              const SizedBox(width: 8),
              _miniPill(skinSensitivity),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _scoreCard("78", "Overall")),
              const SizedBox(width: 8),
              Expanded(child: _scoreCard("82", "Hydration")),
              const SizedBox(width: 8),
              Expanded(child: _scoreCard("76", "Clarity")),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...skinConcerns.take(3).map((e) => _miniTag(e)),
              if (skinConcerns.isEmpty) _miniTag("No concerns"),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: paleRose,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: beetroot,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "AI Insight\n$insight",
                    style: GoogleFonts.poppins(
                      fontSize: 12.7,
                      height: 1.45,
                      color: beetroot.withOpacity(0.82),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List<Map<String, dynamic>> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Quick Actions"),
        const SizedBox(height: 10),
        Row(
          children: List.generate(actions.length, (index) {
            final item = actions[index];
            final bool highlight = item["highlight"] == true;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: index != actions.length - 1 ? 10 : 0),
                child: Container(
                  height: 88,
                  decoration: BoxDecoration(
                    color: highlight ? beetroot.withOpacity(0.88) : cardWhite,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: barelyMauve.withOpacity(0.16),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: highlight
                                ? Colors.white.withOpacity(0.14)
                                : paleRose,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item["icon"] as IconData,
                            size: 18,
                            color: highlight ? Colors.white : beetroot,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["title"] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10.8,
                            fontWeight: FontWeight.w600,
                            color: highlight ? Colors.white : beetroot,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRoutineSection(List<Map<String, dynamic>> routineSteps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle("Today's Routines"),
            const Spacer(),
            Text(
              "See all",
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: softRose,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _routineCard(
                label: "MORNING",
                title: "Morning Glow Routine",
                stepsCount: "4 steps",
                steps: routineSteps,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _routineCard(
                label: "EVENING",
                title: "Evening Repair Routine",
                stepsCount: "4 steps",
                steps: [
                  {"title": "Gentle Foaming Cleanser", "step": 1},
                  {"title": "Salicylic Acid Treatment", "step": 2},
                  {"title": "Niacinamide 10% Serum", "step": 3},
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _routineCard({
    required String label,
    required String title,
    required String stepsCount,
    required List<Map<String, dynamic>> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: barelyMauve.withOpacity(0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: softRose,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: beetroot,
                    height: 1.25,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: paleRose,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  stepsCount,
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: softRose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.take(3).map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: paleRose,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${step["step"]}",
                          style: GoogleFonts.poppins(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: softRose,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step["title"] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10.8,
                            color: beetroot.withOpacity(0.82),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          Text(
            "+ 1 more",
            style: GoogleFonts.poppins(
              fontSize: 10.4,
              color: softRose,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: paleRose,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Start Routine  ›",
                style: GoogleFonts.poppins(
                  fontSize: 10.8,
                  fontWeight: FontWeight.w600,
                  color: beetroot,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle("Recommended For You"),
            const Spacer(),
            Text(
              "See all",
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: softRose,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(products.length, (index) {
            final item = products[index];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: index != products.length - 1 ? 10 : 0),
                child: Container(
                  height: 188,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: barelyMauve.withOpacity(0.16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: paleRose,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.water_drop_outlined,
                            color: softRose,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item["brand"] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 8.8,
                          color: softRose,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item["name"] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: beetroot,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["subtitle"] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 9.5,
                          color: beetroot.withOpacity(0.56),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "★ 4.8",
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              color: softRose,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item["price"] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: beetroot,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle("Your Progress"),
            const Spacer(),
            Text(
              "View history",
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: softRose,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: barelyMauve.withOpacity(0.16)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _progressItem(
                  icon: Icons.trending_up_rounded,
                  value: "+12%",
                  label: "Overall score",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _progressItem(
                  icon: Icons.water_drop_outlined,
                  value: "+8%",
                  label: "Hydration",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _progressItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: paleRose,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: softRose),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: beetroot,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 9.8,
                  color: beetroot.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: paleRose,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10.5,
          color: beetroot,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: paleRose,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10.3,
          color: beetroot.withOpacity(0.75),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _scoreCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: paleRose,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: beetroot,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10.2,
              color: beetroot.withOpacity(0.56),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: beetroot,
      ),
    );
  }
}
