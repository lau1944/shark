import 'package:flutter/material.dart';
import 'package:shark/shark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Shark.init(hostUrl: 'http://localhost:8080');

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SharkController _controller;

  @override
  void initState() {
    _controller = SharkController.fromUrl(
      context,
      '/first_page',
    )..get();

    _controller.stateStream.listen((state) {
      if (state is SharkWidgetState) {
        print(_controller.value);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharkWidget(
        controller: _controller,
        clickEvent: (event) {
          print(event);
        },
      ),
    );
  }
}
