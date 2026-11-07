import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gardirop/l10n/app_localizations.dart';
import '../../data/gardi_item_analysis_service.dart';
import '../widgets/gardi_analyzing_dialog.dart';

class AiScanCameraScreen extends StatefulWidget {
  const AiScanCameraScreen({super.key});

  @override
  State<AiScanCameraScreen> createState() =>
      _AiScanCameraScreenState();
}

class _AiScanCameraScreenState extends State<AiScanCameraScreen> {
  CameraController? _cameraController;

  bool _isInitializing = true;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;
  bool _isAutoMode = true;

  String? _cameraError;
  String? _lastPhotoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        if (!mounted) return;

        setState(() {
          _cameraError = 'No camera available';
          _isInitializing = false;
        });

        return;
      }

      final backCamera = cameras.firstWhere(
            (camera) =>
        camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isInitializing = false;
      });
    } catch (error) {
      debugPrint('GARDI CAMERA INITIALIZATION ERROR: $error');

      if (!mounted) return;

      setState(() {
        _cameraError = error.toString();
        _isInitializing = false;
      });
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    try {
      final nextFlashState = !_isFlashOn;

      await controller.setFlashMode(
        nextFlashState ? FlashMode.torch : FlashMode.off,
      );

      if (!mounted) return;

      setState(() {
        _isFlashOn = nextFlashState;
      });
    } catch (error) {
      debugPrint('GARDI FLASH ERROR: $error');
    }
  }

  Future<void> _takePhoto() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    bool dialogIsOpen = false;

    try {
      final XFile photo = await controller.takePicture();

      debugPrint(
        'GARDI PHOTO CAPTURED: ${photo.path}',
      );

      if (!mounted) return;

      setState(() {
        _lastPhotoPath = photo.path;
      });

      // Show Gardi analyzing popup.
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.48),
        builder: (_) => const GardiAnalyzingDialog(),
      );

      dialogIsOpen = true;

      final result = await GardiItemAnalysisService.analyze(
        imagePath: photo.path,
      );

      if (!mounted) return;

      if (dialogIsOpen) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        dialogIsOpen = false;
      }

      debugPrint(
        'GARDI CAMERA ANALYSIS: ${result.analysis}',
      );

      context.pushReplacement(
        '/closet/ai-result',
        extra: {
          'draft': result.draft,
          'analysis': result.analysis,
        },
      );
    } catch (error) {
      debugPrint(
        'GARDI CAMERA ANALYSIS ERROR: $error',
      );

      if (!mounted) return;

      if (dialogIsOpen) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        dialogIsOpen = false;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gardi is a little busy right now. Please try again in a moment.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_cameraError != null ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _cameraError ?? 'Camera unavailable',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildCameraPreview(),

        // Soft dark overlay for better control visibility.
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.22),
                ],
                stops: const [
                  0.0,
                  0.22,
                  0.72,
                  1.0,
                ],
              ),
            ),
          ),
        ),

        SafeArea(
          child: Stack(
            children: [
              // Close button.
              Positioned(
                top: 12,
                left: 14,
                child: _CameraTopButton(
                  icon: Icons.close_rounded,
                  onTap: () => context.pop(),
                ),
              ),

              // Flash button.
              Positioned(
                top: 12,
                right: 14,
                child: _CameraTopButton(
                  icon: _isFlashOn
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  onTap: _toggleFlash,
                ),
              ),

              // Auto / Manual selector.
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildModeSelector(l10n),
                ),
              ),

              // Clothing framing guide.
              Positioned.fill(
                top: 145,
                bottom: 155,
                left: 42,
                right: 42,
                child: const _GarmentFrame(),
              ),

              // Last captured photo thumbnail.
              Positioned(
                left: 34,
                bottom: 34,
                child: _buildThumbnail(),
              ),

              // Shutter button.
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: Center(
                  child: _buildShutterButton(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    final controller = _cameraController!;

    return Center(
      child: CameraPreview(controller),
    );
  }

  Widget _buildModeSelector(AppLocalizations l10n) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: l10n.cameraAuto,
            selected: _isAutoMode,
            onTap: () {
              setState(() {
                _isAutoMode = true;
              });
            },
          ),
          _ModeButton(
            label: l10n.cameraManual,
            selected: !_isAutoMode,
            onTap: () {
              setState(() {
                _isAutoMode = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: _lastPhotoPath == null
            ? Container(
          color: Colors.black.withValues(alpha: 0.12),
          child: const Icon(
            Icons.checkroom_outlined,
            color: Colors.white,
            size: 25,
          ),
        )
            : Image.file(
          File(_lastPhotoPath!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _isTakingPicture ? null : _takePhoto,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isTakingPicture ? 0.55 : 1,
        child: Container(
          width: 78,
          height: 78,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: _isTakingPicture
                ? const Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black54,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}

class _CameraTopButton extends StatelessWidget {
  const _CameraTopButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(
          minWidth: 82,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.08,
              ),
              blurRadius: 8,
            ),
          ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected
                ? const Color(0xFF3C2F2A)
                : Colors.white.withValues(alpha: 0.82),
            fontSize: 13,
            fontWeight:
            selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _GarmentFrame extends StatelessWidget {
  const _GarmentFrame();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GarmentFramePainter(),
    );
  }
}

class _GarmentFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 38.0;
    const radius = 16.0;

    // Top left.
    final topLeft = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(cornerLength, 0);

    // Top right.
    final topRight = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(
        size.width,
        0,
        size.width,
        radius,
      )
      ..lineTo(size.width, cornerLength);

    // Bottom left.
    final bottomLeft = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(
        0,
        size.height,
        radius,
        size.height,
      )
      ..lineTo(cornerLength, size.height);

    // Bottom right.
    final bottomRight = Path()
      ..moveTo(
        size.width - cornerLength,
        size.height,
      )
      ..lineTo(
        size.width - radius,
        size.height,
      )
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width,
        size.height - radius,
      )
      ..lineTo(
        size.width,
        size.height - cornerLength,
      );

    canvas.drawPath(topLeft, paint);
    canvas.drawPath(topRight, paint);
    canvas.drawPath(bottomLeft, paint);
    canvas.drawPath(bottomRight, paint);
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}