# flutter_falling_items

A Flutter package that creates beautiful animations of items (flowers, icons, images, etc.) falling from top to bottom like raindrops.

## Features

- Create animated falling items (like flowers or icons)
- Customize size, count, and animation duration
- Easy integration with any Flutter app
- Support for multiple item types simultaneously
- Optimized performance with controller pooling

## Getting started

Add the package to your pubspec.yaml:

```yaml
dependencies:
  flutter_falling_items: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_falling_items/flutter_falling_items.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FallingItemsWidget(
        itemProviders: [
          NetworkImage('https://example.com/flower.png'),
        ],
        child: Center(
          child: Text('Your content here'),
        ),
      ),
    );
  }
}
```

### With Controller

```dart
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FallingItemsWidgetState> _fallingItemsKey = GlobalKey<FallingItemsWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FallingItemsWidget(
        key: _fallingItemsKey,
        autoStart: false,
        itemProviders: [
          NetworkImage('https://example.com/flower.png'),
          AssetImage('assets/images/petal.png'),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your content here'),
            ElevatedButton(
              onPressed: () {
                _fallingItemsKey.currentState?.showAllItems();
              },
              child: Text('Show Falling Items'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Customization

The `FallingItemsWidget` supports the following parameters:

- `itemProviders`: List of `ImageProvider`s for the falling items
- `child`: The widget to display beneath the falling items
- `autoStart`: Whether to start the animation automatically (default: true)
- `itemCount`: Number of items per provider (default: 15)
- `itemSize`: Size of each item in pixels (default: 25)
- `minDuration`: Minimum animation duration in milliseconds (default: 1500)
- `maxDuration`: Maximum animation duration in milliseconds (default: 3500)

## Additional Information

### Performance Tips

- Use appropriately sized images to avoid excessive memory usage
- Limit the number of items when using on lower-end devices
- Call `stopAllAnimations()` when the animation is not visible

### Example with Assets

```dart
FallingItemsWidget(
  itemProviders: [
    AssetImage('assets/images/flower1.png'),
    AssetImage('assets/images/flower2.png'),
    AssetImage('assets/images/petal.png'),
  ],
  itemCount: 10, // 10 of each image
  itemSize: 30,
  minDuration: 2000,
  maxDuration: 4000,
  child: YourWidget(),
)
```

### Advanced Usage with Direct API

If you need more control over the animation, you can use the `FallingItemsService` directly:

```dart
class _MyCustomWidgetState extends State<MyCustomWidget> with TickerProviderStateMixin {
  final FallingItemsService _fallingItemsService = FallingItemsService();
  final Map<ImageProvider, List<Widget>> _itemsMap = {};
  final Map<ImageProvider, List<AnimationController>> _controllersMap = {};
  
  void _addFallingItems() {
    _fallingItemsService.addFallingItems(
      itemProvider: NetworkImage('https://example.com/flower.png'),
      screenSize: MediaQuery.of(context).size,
      vsync: this,
      itemsMap: _itemsMap,
      controllersMap: _controllersMap,
      itemCount: 20,
      itemSize: 30,
      minDuration: 2000,
      maxDuration: 5000,
    );
    setState(() {});
  }
  
  @override
  void dispose() {
    _fallingItemsService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final allItems = _itemsMap.values.expand((items) => items).toList();
    
    return Stack(
      children: [
        YourMainContent(),
        ...allItems,
      ],
    );
  }
}
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.