import 'package:flutter/material.dart';

class SafeImage extends StatelessWidget {
  const SafeImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade800,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, color: Colors.white70),
            );
      },
    );
  }
}
