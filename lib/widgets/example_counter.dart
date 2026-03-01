import 'package:flutter/material.dart';

class ExampleCounter extends StatefulWidget {
  const ExampleCounter({super.key});

  @override
  State<ExampleCounter> createState() => _ExampleCounterState();
}

class _ExampleCounterState extends State<ExampleCounter> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Flutter Embedded Counter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => _counter--),
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => setState(() => _counter++),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
