import 'package:flutter_test/flutter_test.dart';
import 'package:shark/models/remote_config.dart';

import 'package:shark/shark.dart';

void main() {
  test('testShareInit', () {
    Shark.init(
      hostUrl: 'https://google.com',
      remoteConfig: RemoteConfig(
        timeout: 20000,
        headers: {
          'testHeader': 'from Shark',
        },
      ),
    );

    Shark.init(
      hostUrl: 'https://google.com',
    );

    Shark.init(
      hostUrl: 'https://google.com',
      remoteConfig: RemoteConfig(
        timeout: 20000,
        headers: {
          'testHeader': 'from Shark',
        },
      ),
      interceptors: []
    );
  });
}
