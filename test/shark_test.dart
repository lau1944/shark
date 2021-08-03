@TestOn('vm')

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shark/shark.dart';
import 'package:shark/src/models/cache_strategy.dart';
import 'package:shark/src/models/enum.dart';
import 'package:shark/src/models/remote_config.dart';
import 'package:shark/src/views/shark_controller.dart';

import 'util.dart';

void main() {
  setUp(startServer);
  tearDown(stopServer);

  test('testShareInit', () async {
    await Shark.init(
        hostUrl: serverUrl.toString(),
        cacheStrategy: CacheStrategy(
          path: 'shark',
        ),
        remoteConfig: RemoteConfig(
          timeout: 20000,
          headers: {
            'testHeader': 'from Shark',
          },
        ),
        onError: (e, m) {
          print('Shark Error: $e');
        });
  });

  testWidgets('Render Widget test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const _TestWidget(),
      ),
    );

    await tester.pump();
  });
}

class _TestWidget extends StatefulWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  __TestWidgetState createState() => __TestWidgetState();
}

class __TestWidgetState extends State<_TestWidget> {
  late final SharkController _sharkController;

  @override
  void initState() {
    _sharkController = SharkController.fromUrl(context, '/first_page');
    _sharkController.updateHeader(header: {'new_header': 'hello'});
    _sharkController.updateParam(params: {'new_param': 'param'});
    _sharkController.get();
    _sharkController.stateStream.listen((state) {
      if (state == SharkWidgetState.success) {
        print(_sharkController.value);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sharkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharkWidget(
      controller: _sharkController,
      errorWidget: Text('error'),
      initWidget: Text('init'),
      loadingWidget: Text('load'),
      clickEvent: (event) {
        print(event);
      },
    );
  }
}
