import 'package:go_router/go_router.dart';

import '../screens/authScreen/login.dart';
import '../screens/home/dashboard.dart';
import '../screens/splash/splash.dart';
import '/utils/constant.dart';

final GoRouter goRouter = GoRouter(routes: [
  GoRoute(
    path: splash,
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: login,
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: dashboard,
    builder: (context, state) => DashboardScreen(),
  ),
]);
