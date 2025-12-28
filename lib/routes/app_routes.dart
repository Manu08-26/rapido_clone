import 'package:flutter/material.dart';
import '../features/user/login_screen.dart';
import '../features/rider/rider_home.dart';
import '../features/driver/driver_home.dart';

class AppRoutes {
  static const String login = '/';
  static const String riderHome = '/rider';
  static const String driverHome = '/driver';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    riderHome: (_) => const RiderHome(),
    driverHome: (_) => const DriverHome(),
  };
}
