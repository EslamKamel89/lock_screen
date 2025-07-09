import 'package:flutter/services.dart';

class LockScreenService {
  static const channelName = 'lockscreen_channel';
  static const platform = MethodChannel(channelName);
  static Future<void> sendCounterToNative(int value) async {
    try {
      await platform.invokeMethod('updateCounter', {'counter': value});
    } on PlatformException catch (e) {
      print('Failed to send counter to native: ${e.message}');
    }
  }
}
