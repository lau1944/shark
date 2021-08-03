import 'package:flutter/material.dart';
import 'package:shark/shark.dart';

MaterialPageRoute defaultSharkRoute(String path, args) => MaterialPageRoute(
      builder: (context) {
        final controller = SharkController.fromUrl(context, path)..get();
        return Scaffold(
          body: SharkWidget(
            controller: controller,
          ),
        );
      },
      settings: RouteSettings(name: path, arguments: args),
    );
