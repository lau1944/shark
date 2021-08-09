import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shark/shark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Shark.init(hostUrl: 'http://localhost:8080');

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('zh')],
      path: 'assets/translations',
      child: MyMaterialApp(),
    ),
  );
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MyApp(),
    );
  }
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

    _controller.addParse(TranslatedTextParser());

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
