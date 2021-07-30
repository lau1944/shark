
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
      '/container',
    )..get();

    /// After 10 secs, redirect to text widget
    /* Timer(Duration(seconds: 5), () {
      _controller.redirect(path: '/text');
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharkWidget(
      controller: _controller,
      clickEvent: (event) {
        print(event);
      },
    );
  }
}
