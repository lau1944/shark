import '../../shark.dart';

const int timeout = 20000;
const Map<String, dynamic> sharkRemoteHeaders = {
  'from': 'shark_server_render',
};
const String DB_DATE_KEY = 'last_saved_date';
const String WIDGET_REQUEST_KEY = 'widget_request';
const String ROUTE_SCHEMA = 'route://';
const String REDIRECT_SCHEMA = 'redirect://';
const String POP_SCHEMA = 'pop://';
const String LINK_SCHEMA = 'link://';

Map<String, RouteType> get routeTypeMap => {
      'route://': RouteType.route,
      'link://': RouteType.link,
      'redirect://': RouteType.redirect,
      'pop://': RouteType.pop,
    };
