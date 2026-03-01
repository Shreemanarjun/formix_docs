import 'package:jaspr/jaspr.dart';

class UpdaterOverlayConfig {
  final String title;
  final String message;
  final String actionLabel;

  const UpdaterOverlayConfig({
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  @decoder
  factory UpdaterOverlayConfig.decode(Map<String, dynamic> data) {
    return UpdaterOverlayConfig(
      title: data['title'] as String,
      message: data['message'] as String,
      actionLabel: data['actionLabel'] as String,
    );
  }

  @encoder
  Map<String, dynamic> encode() {
    return {
      'title': title,
      'message': message,
      'actionLabel': actionLabel,
    };
  }
}
