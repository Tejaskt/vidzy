import 'package:flutter/material.dart';
import 'package:vidzy/core/routes/route_name.dart';
import 'package:vidzy/view/screens/dashboard/dashboard.dart';

class AppRoutes {

  static Map<String, WidgetBuilder> routes = {
    RouteName.home: (_) => Dashboard(),
  };


}
