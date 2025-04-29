// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_falling_items/flutter_falling_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Falling Items Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FallingItemsWidgetState> _fallingItemsKey =
      GlobalKey<FallingItemsWidgetState>();
  bool _isRaining = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Falling Items Demo'),
      ),
      body: FallingItemsWidget(
        key: _fallingItemsKey,
        autoStart: false,
        itemProviders: const [
          NetworkImage(
              'https://purepng.com/public/uploads/large/flower-2wq.png'),
          NetworkImage(
              'https://www.freepnglogos.com/uploads/rose-png/red-rose-png-transparent-image-gallery-yopriceville-high-12.png'),
        ],
        itemCount: 10,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Flutter Falling Items Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                _isRaining
                    ? 'It\'s raining flowers!'
                    : 'Press the button to see the magic',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isRaining = true;
                  });
                  _fallingItemsKey.currentState?.showAllItems();

                  // Add more flowers every 2 seconds
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      _fallingItemsKey.currentState?.showAllItems();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Make it Rain Flowers!',
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isRaining = false;
                  });
                  _fallingItemsKey.currentState?.stopAllAnimations();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Stop Animation',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}