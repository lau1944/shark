
import 'package:flutter/material.dart';
import 'package:shark/shark.dart';
import 'package:shark/views/shark_controller.dart';

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
    _controller = SharkController.fromUrl('/container',)..get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharkWidget(controller: _controller);
  }
}
