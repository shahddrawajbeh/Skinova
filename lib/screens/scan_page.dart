import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  bool isBarcodeMode = false;
  bool isInitializing = true;
  bool isTorchOn = false;
  bool isTakingPhoto = false;
  bool isShowingBarcodeResult = false;

  CameraController? _cameraController;
  CameraDescription? _backCamera;

  final MobileScannerController _barcodeController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  final ImagePicker _picker = ImagePicker();

  String? _lastBarcodeValue;
  File? _selectedGalleryImage;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initPhotoCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) return;

    if (state == AppLifecycleState.inactive) {
      await _cameraController?.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed && !isBarcodeMode) {
      await _initPhotoCamera();
    }
  }

  Future<void> _initPhotoCamera() async {
    try {
      setState(() {
        isInitializing = true;
      });

      final cameras = await availableCameras();

      _backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        _backCamera!,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (!mounted) return;

      await _cameraController?.dispose();
      _cameraController = controller;

      setState(() {
        isTorchOn = false;
        isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isInitializing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
    }
  }

  Future<void> _switchMode(bool barcodeMode) async {
    if (isBarcodeMode == barcodeMode) return;

    setState(() {
      isInitializing = true;
      isBarcodeMode = barcodeMode;
      isTorchOn = false;
      _lastBarcodeValue = null;
    });

    if (barcodeMode) {
      await _cameraController?.dispose();
      _cameraController = null;

      try {
        await _barcodeController.start();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        isInitializing = false;
      });
    } else {
      try {
        await _barcodeController.stop();
      } catch (_) {}

      await _initPhotoCamera();
    }
  }

  Future<void> _toggleTorch() async {
    if (isBarcodeMode) {
      await _barcodeController.toggleTorch();
      if (!mounted) return;
      setState(() {
        isTorchOn = !isTorchOn;
      });
      return;
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      if (isTorchOn) {
        await controller.setFlashMode(FlashMode.off);
      } else {
        await controller.setFlashMode(FlashMode.torch);
      }

      if (!mounted) return;
      setState(() {
        isTorchOn = !isTorchOn;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flash error: $e')),
      );
    }
  }

  Future<void> _capturePhoto() async {
    if (isBarcodeMode) return;

    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        isTakingPhoto) {
      return;
    }

    try {
      setState(() {
        isTakingPhoto = true;
      });

      final XFile file = await controller.takePicture();
      final imageFile = File(file.path);

      if (!mounted) return;

      setState(() {
        _capturedImage = imageFile;
      });

      await showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isTakingPhoto = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (picked == null || !mounted) return;

      final file = File(picked.path);

      setState(() {
        _selectedGalleryImage = file;
      });

      await showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.file(
                    file,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gallery error: $e')),
      );
    }
  }

  void _onBarcodeDetect(BarcodeCapture capture) async {
    if (!isBarcodeMode || isShowingBarcodeResult) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final value = barcodes.first.rawValue;
    if (value == null || value.isEmpty) return;

    isShowingBarcodeResult = true;
    _lastBarcodeValue = value;

    try {
      await _barcodeController.stop();
    } catch (_) {}

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFCFAF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Barcode detected',
                style: GoogleFonts.marcellus(
                  fontSize: 24,
                  color: const Color(0xFF202124),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E3DE)),
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF202124),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF202124),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _barcodeController.start();
                  } catch (_) {}
                },
                child: const Text('Scan again'),
              ),
            ],
          ),
        );
      },
    );

    isShowingBarcodeResult = false;

    if (mounted && isBarcodeMode) {
      try {
        await _barcodeController.start();
      } catch (_) {}
    }
  }

  Widget _buildPreview() {
    if (isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (isBarcodeMode) {
      return MobileScanner(
        controller: _barcodeController,
        onDetect: _onBarcodeDetect,
      );
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text(
          'Camera not available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return CameraPreview(controller);
  }

  @override
  Widget build(BuildContext context) {
    final bool photoMode = !isBarcodeMode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: _buildPreview()),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.18),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.42),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.50),
                    ],
                    stops: const [0.0, 0.22, 0.68, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIconButton(
                        icon: isTorchOn ? Icons.bolt : Icons.bolt_outlined,
                        onTap: _toggleTorch,
                      ),
                      _circleIconButton(
                        icon: Icons.close,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'lumi',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  photoMode
                      ? 'Take a photo of the front of the product'
                      : 'Scan a barcode',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: Center(
                    child: IgnorePointer(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: photoMode
                            ? MediaQuery.of(context).size.width - 44
                            : 270,
                        height: photoMode
                            ? MediaQuery.of(context).size.height * 0.52
                            : 108,
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(photoMode ? 28 : 24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.92),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: photoMode ? _capturePhoto : null,
                  child: Opacity(
                    opacity: photoMode ? 1 : 0.45,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.75),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 66,
                          height: 66,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      _bottomSideButton(
                        icon: Icons.info_outline,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFFFCFAF8),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                            ),
                            builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'How to scan',
                                      style: GoogleFonts.marcellus(
                                        fontSize: 24,
                                        color: const Color(0xFF202124),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      photoMode
                                          ? 'Center the product front inside the frame, hold still, then tap the shutter.'
                                          : 'Place the barcode inside the small frame and wait until it is detected automatically.',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: _modeSwitcher()),
                      const SizedBox(width: 14),
                      _bottomSideButton(
                        icon: Icons.photo_library_outlined,
                        onTap: _pickFromGallery,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeSwitcher() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _switchMode(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !isBarcodeMode ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  'PHOTO',
                  style: GoogleFonts.poppins(
                    color:
                        !isBarcodeMode ? const Color(0xFF2A2A2A) : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _switchMode(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isBarcodeMode ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  'BARCODE',
                  style: GoogleFonts.poppins(
                    color:
                        isBarcodeMode ? const Color(0xFF2A2A2A) : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 58,
            height: 58,
            color: Colors.white.withOpacity(0.12),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSideButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 58,
            height: 58,
            color: Colors.white.withOpacity(0.12),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
