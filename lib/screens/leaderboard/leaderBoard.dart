import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/screens/leaderboard/monthScreen.dart';
import '/screens/leaderboard/todayScreen.dart';
import '/screens/leaderboard/weekScreen.dart';
import '/utils/color.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({
    super.key,
  });

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double height = 0;
  double width = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Color(0xff323232), width: 2),
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    surfaceVariant: Colors.transparent,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorPadding: EdgeInsets.all(4),
                  indicatorSize: TabBarIndicatorSize.tab,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: primary,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  labelStyle: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(
                      text: 'Today',
                    ),
                    Tab(
                      text: 'Week',
                    ),
                    Tab(
                      text: 'Month',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                TodayScreen(),
                WeekScreen(),
                MonthScreen(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
