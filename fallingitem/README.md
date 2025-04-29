# 🌸 flutter_falling_items

A Flutter package for adding beautiful falling item animations like flowers, coins, icons, or images — creating a soft, raindrop-like visual experience 🌧️🌼

---

## 📸 Preview

Here's a preview of how the falling items look:

![Preview Image](https://raw.githubusercontent.com/dhanushequinox/fallingitem/main/lib/assets/Screenshot_1745923899.png)

---

## ✨ Features

- 🌼 Animate any widget falling from top to bottom
- 📸 Supports images from assets or network
- 🎯 Customize count, size, and speed
- 🧩 Easy to plug into any Flutter app
- ⚙️ Built-in controller pooling for better performance

---

## 🚀 Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_falling_items: ^1.1.4
```

---

## 📦 Usage

### ✅ Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_falling_items/flutter_falling_items.dart';

class MyFallingScreen extends StatefulWidget {
  @override
  State<MyFallingScreen> createState() => _MyFallingScreenState();
}

class _MyFallingScreenState extends State<MyFallingScreen>
    with TickerProviderStateMixin {
  final FlowerService _flowerService = FlowerService();
  final Map<ImageProvider, List<Widget>> _flowersMap = {};
  final Map<ImageProvider, List<AnimationController>> _controllersMap = {};

  late Size _screenSize;

  void _addFlowers(ImageProvider imageProvider) {
    _flowerService.addFlowersForImage(
      imageProvider: imageProvider,
      screenSize: _screenSize,
      vsync: this,
      flowersMap: _flowersMap,
      controllersMap: _controllersMap,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    final flowerWidgets =
        _flowersMap.values.expand((widgets) => widgets).toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.white),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _addFlowers(
                  const NetworkImage(
                    'https://purepng.com/public/uploads/large/flower-2wq.png',
                  ),
                );
              },
              child: Text('Let it Rain Flowers!'),
            ),
          ),
          ...flowerWidgets,
        ],
      ),
    );
  }
}
```

---

## 🛠️ Customization

You can customize behavior inside `addFlowersForImage()`:

| Parameter         | Type             | Description                              |
|------------------|------------------|------------------------------------------|
| `imageProvider`  | `ImageProvider`  | Image to fall from top                   |
| `screenSize`     | `Size`           | Dimensions of the current screen         |
| `vsync`          | `TickerProvider` | Required for animations                  |
| `flowersMap`     | `Map`            | Internal map storing falling widgets     |
| `controllersMap` | `Map`            | Internal map storing animation controllers|

---

## 💡 Tips

- Use compressed images for better memory efficiency
- Dispose controllers if you're not reusing them
- Combine multiple image types for varied animations

---

## 📄 License

This project is licensed under the MIT License.  
See the full license [here](https://github.com/dhanushequinox/fallingitem/blob/main/LICENSE).

---

## 🔗 Links

- 🌐 [GitHub Repository](https://github.com/dhanushequinox/fallingitem)
- 🏠 [Homepage](https://github.com/dhanushequinox/fallingitem)
- 📸 [Image](https://github.com/dhanushequinox/fallingitem/blob/main/fallingitem/lib/assets/Screenshot_1745923899.png)