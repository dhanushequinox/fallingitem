import 'package:flutter/material.dart';
import 'package:flutter_falling_items/falling_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FlowerDemoPage());
  }
}

class FlowerDemoPage extends StatefulWidget {
  const FlowerDemoPage({super.key});
  @override
  State<FlowerDemoPage> createState() => _FlowerDemoPageState();
}

class _FlowerDemoPageState extends State<FlowerDemoPage>
    with TickerProviderStateMixin {
  final FlowerService _flowerService = FlowerService();
  final Map<ImageProvider, List<Widget>> _flowersMap = {};
  final Map<ImageProvider, List<AnimationController>> _controllersMap = {};
  late Size _screenSize;

  void _addFlowersForImage(ImageProvider imageProvider) {
    _flowerService.addFlowersForImage(
      imageProvider: imageProvider,
      screenSize: _screenSize,
      vsync: this,
      flowersMap: _flowersMap,
      controllersMap: _controllersMap,
    );
    setState(() {});
  }

  void showFlowers(ImageProvider imageProvider) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _addFlowersForImage(imageProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    final allFlowers = _flowersMap.values.expand((flowers) => flowers).toList();
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.black)),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showFlowers(const NetworkImage(
                    'https://purepng.com/public/uploads/large/flower-2wq.png',
                  ));
                },
                child: const Text('Show Flowers'),
              ),
            ),
          ),
          ...allFlowers,
        ],
      ),
    );
  }
}
