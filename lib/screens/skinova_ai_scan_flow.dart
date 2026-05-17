import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skinnova/services/image_quality_api.dart';

class SkinovaAiScanFlow extends StatefulWidget {
  const SkinovaAiScanFlow({super.key});

  @override
  State<SkinovaAiScanFlow> createState() => _SkinovaAiScanFlowState();
}

class _SkinovaAiScanFlowState extends State<SkinovaAiScanFlow> {
  final ImagePicker _picker = ImagePicker();
  File? _photo;

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.front,
    );
    if (picked == null) return;

    setState(() => _photo = File(picked.path));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewScanPhotoPage(
          photo: _photo!,
          onRetake: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            children: [
              const _TopHandle(),
              const SizedBox(height: 16),
              _TitleBlock(
                title: 'Ready to scan',
                subtitle: 'Align your face in the frame and tap Scan',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Container(
                      width: 230,
                      height: 270,
                      color: const Color(0xFFF7F4F3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 64,
                            color: Color(0xFFBDB7B7),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Camera preview',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _PrimaryButton(
                text: 'Take Photo',
                icon: Icons.camera_alt_outlined,
                onTap: () => _pick(ImageSource.camera),
              ),
              const SizedBox(height: 14),
              _SecondaryButton(
                text: 'Upload Photo',
                icon: Icons.photo_library_outlined,
                onTap: () => _pick(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewScanPhotoPage extends StatefulWidget {
  final File photo;
  final VoidCallback onRetake;

  const ReviewScanPhotoPage({
    super.key,
    required this.photo,
    required this.onRetake,
  });

  @override
  State<ReviewScanPhotoPage> createState() => _ReviewScanPhotoPageState();
}

class _ReviewScanPhotoPageState extends State<ReviewScanPhotoPage> {
  bool _isChecking = false;

  Future<void> _checkAndContinue() async {
    setState(() => _isChecking = true);

    try {
      final result = await ImageQualityApi.checkImage(widget.photo);

      if (!mounted) return;
      setState(() => _isChecking = false);

      if (result["isValid"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanningPage(photo: widget.photo),
          ),
        );
      } else {
        _showScanMessage(result["message"] ?? "Invalid image");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isChecking = false);

      _showScanMessage("Could not connect to image check server.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            children: [
              const _TopHandle(),
              const SizedBox(height: 16),
              _TitleBlock(
                title: 'Review your photo',
                subtitle: 'Make sure your face is clear before scanning',
              ),
              const SizedBox(height: 46),
              Expanded(
                child: Center(
                  child: _OvalPhoto(
                    photo: widget.photo,
                    width: 280,
                    height: 360,
                  ),
                ),
              ),
              _PrimaryButton(
                text: _isChecking ? 'Checking photo...' : 'Get your Skin Score',
                onTap: _isChecking ? () {} : _checkAndContinue,
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: widget.onRetake,
                child: Text(
                  'Retake Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9C9C9C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScanMessage(String message, {bool success = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: success
                      ? const Color(0xFFEAF8EF)
                      : const Color(0xFFFFF3E8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success
                      ? Icons.check_rounded
                      : Icons.tips_and_updates_rounded,
                  color: success
                      ? const Color(0xFF31C768)
                      : const Color(0xFFFF9F1C),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScanningPage extends StatefulWidget {
  final File photo;
  const ScanningPage({super.key, required this.photo});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _messageIndex = 0;

  final List<String> _messages = const [
    'Detecting skin texture...',
    'Measuring skin health...',
    'Checking acne and redness...',
    'Building your routine...',
  ];
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return false;
      setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
      return true;
    });

    _sendImageToBackend();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1700),
  //   )..repeat();

  //   Future.doWhile(() async {
  //     await Future.delayed(const Duration(milliseconds: 900));
  //     if (!mounted) return false;
  //     setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
  //     return true;
  //   });

  //   Future.delayed(const Duration(seconds: 4), () {
  //     if (!mounted) return;
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => SkinScorePage(
  //           photo: widget.photo,
  //           result: SkinScanUiResult.mock(),
  //         ),
  //       ),
  //     );
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendImageToBackend() async {
    try {
      final uri = Uri.parse('http://192.168.1.11:8000/analyze-skin');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          widget.photo.path,
        ),
      );

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw Exception(responseBody);
      }

      final data = jsonDecode(responseBody);
      final result = SkinScanUiResult.fromJson(data);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SkinScorePage(
            photo: widget.photo,
            result: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SkinScorePage(
            photo: widget.photo,
            result: SkinScanUiResult.mock(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            children: [
              const _TopHandle(),
              const SizedBox(height: 16),
              _TitleBlock(
                title: 'Scanning...',
                subtitle: 'Hold still while we analyze your skin',
              ),
              const SizedBox(height: 54),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          _OvalPhoto(
                              photo: widget.photo, width: 280, height: 360),
                          Positioned(
                            top: 40 + (_controller.value * 260),
                            child: Container(
                              width: 250,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF31C768),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x7731C768),
                                    blurRadius: 16,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Text(
                _messages[_messageIndex],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFC8C8C8),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class SkinScorePage extends StatelessWidget {
  final File photo;
  final SkinScanUiResult result;

  const SkinScorePage({super.key, required this.photo, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _ProgressHeader(progress: .72),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                child: Column(
                  children: [
                    Text(
                      '${result.skinScore}',
                      style: GoogleFonts.poppins(
                        fontSize: 58,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    Text(
                      'Your Skin Score',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Transform.scale(
                        scale: 0.78,
                        child: _ScoreArc(photo: photo, score: result.skinScore),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: result.metrics.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.35,
                      ),
                      itemBuilder: (_, i) =>
                          _MetricCard(metric: result.metrics[i]),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              child: _PrimaryButton(
                text: 'View Potential',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PotentialRoutinePage(
                        photo: photo,
                        result: result,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PotentialRoutinePage extends StatelessWidget {
  final File photo;
  final SkinScanUiResult result;

  const PotentialRoutinePage(
      {super.key, required this.photo, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _ProgressHeader(progress: .95),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${result.potentialScore}',
                            style: GoogleFonts.poppins(
                              fontSize: 58,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Your Potential!',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                          const SizedBox(height: 48),
                          _ScoreArc(
                              photo: photo,
                              score: result.potentialScore,
                              green: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Transform.scale(
                      scale: 0.9,
                      child: _ReadyPlanCard(months: result.improvementTime),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      ' your custom skin plan is ready',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.18,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _RoutineStepsCard(
                      title: 'Your morning routine',
                      icon: Icons.wb_sunny_outlined,
                      steps: result.morningRoutine,
                    ),
                    const SizedBox(height: 16),
                    _RoutineStepsCard(
                      title: 'Your evening routine',
                      icon: Icons.dark_mode_outlined,
                      steps: result.nightRoutine,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F8EF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Start your transformation today',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF31C768),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _PrimaryButton(text: 'Build My Routine', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class SkinScanUiResult {
  final int skinScore;
  final int potentialScore;
  final String improvementTime;
  final List<SkinMetric> metrics;
  final List<RoutineStep> morningRoutine;
  final List<RoutineStep> nightRoutine;

  SkinScanUiResult({
    required this.skinScore,
    required this.potentialScore,
    required this.improvementTime,
    required this.metrics,
    required this.morningRoutine,
    required this.nightRoutine,
  });
  factory SkinScanUiResult.fromJson(Map<String, dynamic> json) {
    return SkinScanUiResult(
      skinScore: json['skinScore'] ?? 60,
      potentialScore: json['potentialScore'] ?? 95,
      improvementTime: json['improvementTime'] ?? '3 Months',
      metrics: (json['metrics'] as List? ?? [])
          .map((e) => SkinMetric.fromJson(e))
          .toList(),
      morningRoutine: (json['morningRoutine'] as List? ?? [])
          .map((e) => RoutineStep.fromJson(e))
          .toList(),
      nightRoutine: (json['nightRoutine'] as List? ?? [])
          .map((e) => RoutineStep.fromJson(e))
          .toList(),
    );
  }
  factory SkinScanUiResult.mock() => SkinScanUiResult(
        skinScore: 60,
        potentialScore: 97,
        improvementTime: '3 Months',
        morningRoutine: const [],
        nightRoutine: const [],
        metrics: const [
          SkinMetric(
              'Hydration', 55, Icons.water_drop_outlined, MetricStatus.medium),
          SkinMetric('Acne', 38, Icons.bubble_chart_outlined, MetricStatus.bad),
          SkinMetric('Redness', 44, Icons.local_fire_department_outlined,
              MetricStatus.bad),
          SkinMetric('Pores', 48, Icons.circle_outlined, MetricStatus.bad),
          SkinMetric('Wrinkles', 70, Icons.show_chart, MetricStatus.medium),
          SkinMetric('Dark spots', 41, Icons.blur_circular, MetricStatus.bad),
        ],
      );
}

class SkinMetric {
  final String name;
  final int score;
  final IconData icon;
  final MetricStatus status;

  const SkinMetric(this.name, this.score, this.icon, this.status);

  factory SkinMetric.fromJson(Map<String, dynamic> json) {
    final statusText = (json['status'] ?? '').toString().toLowerCase();

    MetricStatus status = MetricStatus.medium;

    if (statusText.contains('good')) {
      status = MetricStatus.good;
    }

    if (statusText.contains('needs') || statusText.contains('bad')) {
      status = MetricStatus.bad;
    }

    return SkinMetric(
      json['name'] ?? '',
      json['score'] ?? 0,
      Icons.circle_outlined,
      status,
    );
  }
}

class RoutineStep {
  final int step;
  final String name;
  final String why;
  final String ingredient;
  final String category;

  RoutineStep({
    required this.step,
    required this.name,
    required this.why,
    required this.ingredient,
    required this.category,
  });

  factory RoutineStep.fromJson(Map<String, dynamic> json) {
    return RoutineStep(
      step: json['step'] ?? 0,
      name: json['name'] ?? '',
      why: json['why'] ?? '',
      ingredient: json['ingredient'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

enum MetricStatus { good, medium, bad }

class _MetricCard extends StatelessWidget {
  final SkinMetric metric;
  const _MetricCard({required this.metric});

  Color get color {
    switch (metric.status) {
      case MetricStatus.good:
        return const Color(0xFF31C768);
      case MetricStatus.medium:
        return const Color(0xFFFFA11A);
      case MetricStatus.bad:
        return const Color(0xFFFF6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${metric.score}',
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: metric.score / 100,
                    minHeight: 8,
                    color: color,
                    backgroundColor: const Color(0xFFEDEDED),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(metric.icon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  metric.name,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFB8B8B8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OvalPhoto extends StatelessWidget {
  final File photo;
  final double width;
  final double height;

  const _OvalPhoto(
      {required this.photo, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width),
      child: Image.file(
        photo,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ScoreArc extends StatelessWidget {
  final File photo;
  final int score;
  final bool green;

  const _ScoreArc(
      {required this.photo, required this.score, this.green = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 42,
            child: CustomPaint(
              size: const Size(180, 90),
              painter: _ArcPainter(
                progress: score / 100,
                color:
                    green ? const Color(0xFF31C768) : const Color(0xFFFFA11A),
              ),
            ),
          ),
          _OvalPhoto(photo: photo, width: 115, height: 145),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, -35, size.width, size.height * 2);
    final bg = Paint()
      ..color = const Color(0xFFEDEDED)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;

    canvas.drawArc(rect, math.pi * .17, math.pi * .66, false, bg);
    canvas.drawArc(rect, math.pi * .17, math.pi * .66 * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _GoalPreview extends StatelessWidget {
  final File photo;
  const _GoalPreview({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}

class BackdropFilterPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white.withOpacity(.32));
  }
}

class _RoutineLockedCard extends StatelessWidget {
  final String title;
  final String steps;
  final IconData icon;

  const _RoutineLockedCard(
      {required this.title, required this.steps, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FF),
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: const Color(0xFF4655C7)),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w500))),
              Text(steps,
                  style: GoogleFonts.poppins(
                      fontSize: 15, color: const Color(0xFF8E8E8E))),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(18)),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(28)),
                child: Text('🔒 Tap to view',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineStepsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<RoutineStep> steps;

  const _RoutineStepsCard({
    required this.title,
    required this.icon,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF5B2333)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text('${steps.length} steps'),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.map((s) => _RoutineProductStep(step: s)).toList(),
        ],
      ),
    );
  }
}

class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureBox(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: const Color(0xFFEAF8EF),
                borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: const Color(0xFF31C768)),
          ),
          const SizedBox(height: 18),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500, height: 1.15)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF8E8E8E), height: 1.35)),
        ],
      ),
    );
  }
}

class _ReadyPlanCard extends StatelessWidget {
  final String months;
  const _ReadyPlanCard({required this.months});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(32),
      //   border: Border.all(color: const Color(0xFFE2E2E2)),
      // ),
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;
  final bool dark;
  final bool green;

  const _SmallLabel(
      {required this.text, this.dark = false, this.green = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: green
            ? const Color(0xFF31C768)
            : dark
                ? Colors.black87
                : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: GoogleFonts.poppins(
              color: (green || dark) ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final double progress;
  const _ProgressHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 24, 0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 28)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: const Color(0xFF5B2333),
                backgroundColor: const Color(0xFFE6E6E6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopHandle extends StatelessWidget {
  const _TopHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFE1E1E1),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TitleBlock({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style:
              GoogleFonts.poppins(fontSize: 19, color: const Color(0xFF8E8E8E)),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const _PrimaryButton({required this.text, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, color: Colors.white),
        label: Text(text,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton(
      {required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.black),
        label: Text(text,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}

class _RoutineProductStep extends StatefulWidget {
  final RoutineStep step;

  const _RoutineProductStep({required this.step});

  @override
  State<_RoutineProductStep> createState() => _RoutineProductStepState();
}

class _RoutineProductStepState extends State<_RoutineProductStep> {
  // Map<String, dynamic>? product;
  // bool loading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   loadProduct();
  // }

  // Future<void> loadProduct() async {
  //   try {
  //     final uri = Uri.parse(
  //       'http://192.168.1.11:5000/api/products/recommend/routine?ingredient=${Uri.encodeComponent(widget.step.ingredient)}&category=${Uri.encodeComponent(widget.step.category)}',
  //     );

  //     print('PRODUCT URL: $uri');

  //     final response = await http.get(uri);

  //     print('PRODUCT STATUS: ${response.statusCode}');
  //     print('PRODUCT BODY: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data is List && data.isNotEmpty) {
  //         if (!mounted) return;
  //         setState(() {
  //           product = data.first;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('PRODUCT ERROR: $e');
  //   }

  //   if (mounted) {
  //     setState(() => loading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final s = widget.step;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFF7F4F3),
            child: Text('${s.step}', style: GoogleFonts.poppins(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.why,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${s.category} • ${s.ingredient}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF5B2333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoutineCategoryProductsPage(
                          category: s.category,
                          ingredient: s.ingredient,
                          stepName: s.name,
                        ),
                      ),
                    );
                  },
                  child: Text('Browse ${s.category} products'),
                ),
                // const SizedBox(height: 10),
                // if (loading)
                //   const SizedBox(
                //     height: 18,
                //     width: 18,
                //     child: CircularProgressIndicator(strokeWidth: 2),
                //   ),
                // if (!loading && product != null)
                //   Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFF7F4F3),
                //       borderRadius: BorderRadius.circular(14),
                //     ),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             ClipRRect(
                //               borderRadius: BorderRadius.circular(10),
                //               child: Image.network(
                //                 product!['imageUrl'] ?? '',
                //                 width: 54,
                //                 height: 54,
                //                 fit: BoxFit.cover,
                //                 errorBuilder: (_, __, ___) =>
                //                     const Icon(Icons.image_not_supported),
                //               ),
                //             ),
                //             const SizedBox(width: 12),
                //             Expanded(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     product!['name'] ?? '',
                //                     maxLines: 1,
                //                     overflow: TextOverflow.ellipsis,
                //                     style: GoogleFonts.poppins(
                //                       fontWeight: FontWeight.w500,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 3),
                //                   Text(
                //                     product!['brand'] ?? '',
                //                     style: GoogleFonts.poppins(
                //                       fontSize: 12,
                //                       color: Colors.grey,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 10),
                //         Row(
                //           children: [
                //             Expanded(
                //               child: OutlinedButton(
                //                 onPressed: () {
                //                   // later: open product details page
                //                 },
                //                 child: const Text('View Product'),
                //               ),
                //             ),
                //             const SizedBox(width: 8),
                //             Expanded(
                //               child: ElevatedButton(
                //                 onPressed: () {
                //                   // later: save to routine
                //                 },
                //                 style: ElevatedButton.styleFrom(
                //                   backgroundColor: Colors.black,
                //                   foregroundColor: Colors.white,
                //                 ),
                //                 child: const Text('Add to Routine'),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // if (!loading && product == null)
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFF7F4F3),
                //       borderRadius: BorderRadius.circular(14),
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'No matching product in Skinova yet',
                //           style: GoogleFonts.poppins(
                //             fontSize: 13,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         const SizedBox(height: 8),
                //         OutlinedButton(
                //           onPressed: () {
                //             // later: open products by category
                //           },
                //           child: Text('Browse ${s.category} products'),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoutineCategoryProductsPage extends StatefulWidget {
  final String category;
  final String ingredient;
  final String stepName;

  const RoutineCategoryProductsPage({
    super.key,
    required this.category,
    required this.ingredient,
    required this.stepName,
  });

  @override
  State<RoutineCategoryProductsPage> createState() =>
      _RoutineCategoryProductsPageState();
}

class _RoutineCategoryProductsPageState
    extends State<RoutineCategoryProductsPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final uri = Uri.parse(
        'http://192.168.1.12:5000/api/products?category=${widget.category}',
      );

      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data is List) {
        setState(() => products = data);
      }
    } catch (e) {
      print('CATEGORY PRODUCTS ERROR: $e');
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        p['imageUrl'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['name'] ?? ''),
                            Text(
                              p['brand'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
