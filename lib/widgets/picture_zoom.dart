import 'package:flutter/material.dart';

class PictureZoom extends StatefulWidget {
  final Widget picture;

  PictureZoom({
    super.key,
    required this.picture,
  });

  @override
  State<PictureZoom> createState() => _PictureZoomState();
}

class _PictureZoomState extends State<PictureZoom>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => controller.value = animation!.value);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: controller,
      clipBehavior: Clip.none,
      minScale: 1,
      maxScale: 5,
      onInteractionEnd: (details) {
        resetAnimation();
      },
      child: widget.picture,
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.forward(
      from: 0,
    );
  }
}
