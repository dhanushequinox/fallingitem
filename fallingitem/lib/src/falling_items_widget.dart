// lib/src/falling_items_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_falling_items/flutter_falling_items.dart';


/// A widget that displays falling items (like flowers or icons) animation
class FallingItemsWidget extends StatefulWidget {
  /// The child widget to display beneath the falling items
  final Widget child;
  
  /// List of image providers for the falling items
  final List<ImageProvider> itemProviders;
  
  /// Whether to start the animation automatically
  final bool autoStart;
  
  /// Number of items per image provider
  final int itemCount;
  
  /// Size of each item in pixels
  final double itemSize;
  
  /// Minimum animation duration in milliseconds
  final int minDuration;
  
  /// Maximum animation duration in milliseconds
  final int maxDuration;

  /// Creates a widget that displays falling items animation
  const FallingItemsWidget({
    super.key,
    required this.child,
    required this.itemProviders,
    this.autoStart = true,
    this.itemCount = 15,
    this.itemSize = 25,
    this.minDuration = 1500,
    this.maxDuration = 3500,
  });

  @override
  FallingItemsWidgetState createState() => FallingItemsWidgetState();
}

/// State for the FallingItemsWidget
/// This class is public so it can be used with GlobalKey
class FallingItemsWidgetState extends State<FallingItemsWidget> with TickerProviderStateMixin {
  late Size _screenSize;
  final FallingItemsService _fallingItemsService = FallingItemsService();
  final Map<ImageProvider, List<Widget>> _itemsMap = {};
  final Map<ImageProvider, List<AnimationController>> _controllersMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size;
      if (widget.autoStart) {
        showAllItems();
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    for (final controllerList in _controllersMap.values) {
      for (final controller in controllerList) {
        controller.dispose();
      }
    }
    _fallingItemsService.dispose();
    super.dispose();
  }

  /// Shows falling items for all provided image providers
  void showAllItems() {
    for (final provider in widget.itemProviders) {
      showItems(provider);
    }
  }

  /// Shows falling items for a specific image provider
  void showItems(ImageProvider provider) {
    _fallingItemsService.addFallingItems(
      itemProvider: provider,
      screenSize: _screenSize,
      vsync: this,
      itemsMap: _itemsMap,
      controllersMap: _controllersMap,
      itemCount: widget.itemCount,
      itemSize: widget.itemSize,
      minDuration: widget.minDuration,
      maxDuration: widget.maxDuration,
    );
    setState(() {});
  }

  /// Stops all falling animations
  void stopAllAnimations() {
    for (final controllerList in _controllersMap.values) {
      for (final controller in controllerList) {
        controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _itemsMap.values.expand((items) => items).toList();
    _screenSize = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        widget.child,
        ...allItems,
      ],
    );
  }
}
