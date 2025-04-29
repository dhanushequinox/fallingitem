// Package structure
/*
flutter_falling_items/
  ├── lib/
  │   ├── flutter_falling_items.dart       // Main library export file
  │   └── src/
  │       ├── falling_items_service.dart   // Core service for falling animation
  │       └── falling_items_widget.dart    // Widget wrapper for convenience
  ├── example/
  │   └── lib/
  │       └── main.dart                    // Example usage
  ├── pubspec.yaml                         // Package metadata
  └── README.md                            // Documentation
*/

// lib/flutter_falling_items.dart
library flutter_falling_items;


export 'src/falling_items_widget.dart';

// lib/src/falling_items_service.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// A service that creates falling animations for images or icons
class FallingItemsService {
  /// Pool of animation controllers for recycling
  final List<AnimationController> _controllerPool = [];

  /// Add falling items (like flowers) to the screen
  /// 
  /// Parameters:
  /// - [itemProvider]: The image provider for the falling item
  /// - [screenSize]: The size of the screen
  /// - [vsync]: The ticker provider for animations
  /// - [itemsMap]: Map to store the created widgets
  /// - [controllersMap]: Map to store the animation controllers
  /// - [itemCount]: Number of items to create (default: 15)
  /// - [itemSize]: Size of each item in pixels (default: 25)
  /// - [minDuration]: Minimum animation duration in milliseconds (default: 1500)
  /// - [maxDuration]: Maximum animation duration in milliseconds (default: 3500)
  void addFallingItems({
    required ImageProvider itemProvider,
    required Size screenSize,
    required TickerProvider vsync,
    required Map<ImageProvider, List<Widget>> itemsMap,
    required Map<ImageProvider, List<AnimationController>> controllersMap,
    int itemCount = 15,
    double itemSize = 25,
    int minDuration = 1500,
    int maxDuration = 3500,
  }) {
    Random random = Random();

    for (int i = 0; i < itemCount; i++) {
      final startX = random.nextDouble() * screenSize.width;
      final startY = -random.nextDouble() * 200.0;
      final endY = screenSize.height + random.nextDouble() * 100.0;
      
      final durationRange = maxDuration - minDuration;
      final duration = Duration(milliseconds: minDuration + random.nextInt(durationRange));

      final AnimationController controller = _controllerPool.isNotEmpty
          ? _controllerPool.removeLast()
          : AnimationController(vsync: vsync, duration: duration);

      controllersMap.putIfAbsent(itemProvider, () => []).add(controller);

      final animationY = Tween<double>(begin: startY, end: endY).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );

      // Optional slight horizontal movement
      final animationX = Tween<double>(
        begin: startX,
        end: startX + (random.nextDouble() * 40 - 20), // Random drift left or right
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );

      // Optional rotation
      final animationRotation = Tween<double>(
        begin: 0,
        end: random.nextDouble() * 0.5 - 0.25, // Random slight rotation
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );

      final itemWidget = AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final yValue = animationY.value;
          final xValue = animationX.value;
          final rotationValue = animationRotation.value;
          
          return Positioned(
            left: xValue,
            top: yValue,
            child: Transform.rotate(
              angle: rotationValue,
              child: Opacity(
                opacity: (1 - ((yValue - startY) / (screenSize.height + 200.0)))
                    .clamp(0.0, 1.0),
                child: Image(
                  image: itemProvider,
                  width: itemSize,
                  height: itemSize,
                ),
              ),
            ),
          );
        },
      );

      itemsMap.putIfAbsent(itemProvider, () => []).add(itemWidget);

      controller.forward().then((_) {
        // When animation completes, recycle the controller
        _controllerPool.add(controller);
        controller.reset();
        
        // Remove the item from the maps
        itemsMap[itemProvider]?.remove(itemWidget);
        controllersMap[itemProvider]?.remove(controller);
      });
    }
  }

  /// Dispose all animation controllers to prevent memory leaks
  void dispose() {
    for (final controller in _controllerPool) {
      controller.dispose();
    }
    _controllerPool.clear();
  }
}
