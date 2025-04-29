import 'dart:math';
import 'package:flutter/material.dart';


class FlowerService {

  final List<AnimationController> _controllerPool = [];

  void addFlowersForImage({
    required ImageProvider imageProvider,
    required Size screenSize,
    required TickerProvider vsync,
    required Map<ImageProvider, List<Widget>> flowersMap,
    required Map<ImageProvider, List<AnimationController>> controllersMap,
  }) {
    Random random = Random();

    for (int i = 0; i < 15; i++) {
      final startX = random.nextDouble() * screenSize.width;
      final startY = -random.nextDouble() * 200.0;
      final endY = screenSize.height + random.nextDouble() * 100.0;

      final duration = Duration(milliseconds: 1500 + random.nextInt(2000));

      final AnimationController controller = _controllerPool.isNotEmpty
          ? _controllerPool.removeLast()
          : AnimationController(vsync: vsync, duration: duration);

      controllersMap.putIfAbsent(imageProvider, () => []).add(controller);

      final animationY = Tween<double>(begin: startY, end: endY).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );

      final flowerWidget = AnimatedBuilder(
        animation: animationY,
        builder: (context, child) {
          final yValue = animationY.value;
          return Positioned(
            left: startX,
            top: yValue,
            child: Opacity(
              opacity: (1 - ((yValue - startY) / (screenSize.height + 200.0)))
                  .clamp(0.0, 1.0),
              child: Image(
                image: imageProvider,
                width: 25,
              ),
            ),
          );
        },
      );

      flowersMap.putIfAbsent(imageProvider, () => []).add(flowerWidget);
      controller.forward();
    }
  }
}
