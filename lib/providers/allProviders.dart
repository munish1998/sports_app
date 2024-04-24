import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:touchmaster/providers/messageProviders.dart';

import '/providers/challengesProvider.dart';
import '/providers/videoProvider.dart';
import 'authProvider.dart';
import 'contactUsProvider.dart';
import 'contentProvider.dart';
import 'homeProvider.dart';
import 'leaderboardProvider.dart';
import 'levelProvider.dart';
import 'planProvider.dart';
import 'practiceProvider.dart';
import 'profileProvider.dart';
import 'userProvider.dart';

class AllProviders {
  List<SingleChildWidget> allProvider = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => ContentProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => LevelProvider()),
    ChangeNotifierProvider(create: (_) => PlanProvider()),
    ChangeNotifierProvider(create: (_) => ContactUsProvider()),
    ChangeNotifierProvider(create: (_) => PracticeProvider()),
    ChangeNotifierProvider(create: (_) => UsersProvider()),
    ChangeNotifierProvider(create: (_) => VideoProvider()),
    ChangeNotifierProvider(create: (_) => ChallengeProvider()),
    ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
    ChangeNotifierProvider(create: (_) => MessageProvider()),
  ];
}
