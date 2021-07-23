import 'package:flutter_test/flutter_test.dart';
import 'package:shark/core/cache_manager.dart';
import 'package:shark/models/cache_strategy.dart';
import 'package:shark/models/remote_config.dart';

import 'package:shark/shark.dart';

void main() {
  test('testShareInit', () async {
    await Shark.init(
      hostUrl: 'https://google.com',
      remoteConfig: RemoteConfig(
        timeout: 20000,
        headers: {
          'testHeader': 'from Shark',
        },
      ),
      onError: (e, m) {
        print(e);
      }
    );
  });
}
