import 'package:flutter/material.dart';
import '../models/updater_config.dart';

class FlutterUpdaterOverlay extends StatelessWidget {
  const FlutterUpdaterOverlay({
    required this.config,
    required this.onClose,
    required this.isDark,
    this.onAction,
    super.key,
  });

  final UpdaterOverlayConfig config;
  final VoidCallback onClose;
  final VoidCallback? onAction;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Theme(
        data: isDark ? ThemeData.dark() : ThemeData.light(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        config.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(config.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onAction,
                    child: Text(config.actionLabel),
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
