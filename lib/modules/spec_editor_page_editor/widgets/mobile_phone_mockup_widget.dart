import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';

class MobilePhoneMockupWidget extends StatelessWidget {
  const MobilePhoneMockupWidget({
    required this.child,
    super.key,
  });

  /// child - The child widget to render inside the mobile phone mockup
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      isToolbarVisible: false,
      builder: (context) => child,
    );
  }
}
