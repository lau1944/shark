import 'package:flutter/cupertino.dart';
import 'package:shark/models/remote_config.dart';

/// Controller for Shark Widget UI, in order to control current widget
class SharkController extends ChangeNotifier {

   /// path of your widget request host
   ///
   /// sample:
   /// path = '/login'
   /// your request url would become -> $hostUrl + path
   final String path;

   /// current request network configuration
   final RemoteConfig? config;

   /// request json result
   String? _resultData;

   SharkController({required this.path, this.config});


}