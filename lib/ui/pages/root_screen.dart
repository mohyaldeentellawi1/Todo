import 'package:flutter/material.dart';
import 'package:todoapp/ui/pages/home_page.dart';
import 'package:todoapp/ui/pages/remind_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  List<Widget> screens = [
    const HomeScreen(),
    const RemindScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Task',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Remind',
            ),
          ],
          onTap: (value) {
            currentIndex = value;
            _pageController.jumpToPage(value);
          },
        ));
  }
}
