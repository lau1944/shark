import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:shark/models/remote_config.dart';
import 'package:shark/service/api_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Shark entry point
/// in order to make shark starts, you need to add [Shark.init] before flutter app run
///
/// Sample :
/// void main(List args) {
///   await Shark.init('https:google.com');
///
///   runApp(MyApp());
/// }
class Shark {
  /// init shark client
  /// see also [_SharkCore.init]
  static Future<void> init(
      {required String hostUrl,
      RemoteConfig? remoteConfig,
      List<Interceptor>? interceptors}) {
    return _ShareCore.instance
        .init(hostUrl, remoteConfig: remoteConfig, interceptors: interceptors);
  }
}

class _ShareCore {
  _ShareCore._();

  static _ShareCore instance = _ShareCore._();

  factory _ShareCore() => instance;

  /// init shark client
  Future<void> init(String hostUrl,
      {RemoteConfig? remoteConfig, List<Interceptor>? interceptors}) async {
    String deviceInfo = await _buildDeviceInfo();
    await _initApiClient(hostUrl, deviceInfo,
        remoteConfig: remoteConfig, interceptors: interceptors);
  }

  /// build device info string, in order to push it as headers on api client
  Future<String> _buildDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return _deviceMetaBuild('android', info.androidId, info.model);
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return _deviceMetaBuild('ios', info.name, info.model);
    } else if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return _deviceMetaBuild('mac', info.computerName, info.model);
    } else if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      return _deviceMetaBuild('linux', info.id, info.machineId);
    } else if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      return _deviceMetaBuild('windows', info.computerName, info.computerName);
    } else if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return _deviceMetaBuild('web', info.userAgent, '');
    }

    return _deviceMetaBuild('others', '', '');
  }

  String _deviceMetaBuild(String platform, String? deviceId, String? model) {
    return '$platform-$deviceId-$model';
  }

  /// init shark network client
  Future<void> _initApiClient(String hostUrl, String deviceInfo,
      {RemoteConfig? remoteConfig, List<Interceptor>? interceptors}) async {
    return await ApiClient.instance.init(hostUrl, deviceInfo,
        remoteConfig: remoteConfig, interceptors: interceptors);
  }
}