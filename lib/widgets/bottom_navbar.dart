import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      indicatorColor: Theme.of(context).colorScheme.primary,
      onDestinationSelected: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      destinations: <Widget>[
      NavigationDestination(
        // icon: Badge(child: Icon(Icons.hourglass_bottom_outlined)),
        icon: Icon(Icons.hourglass_bottom_outlined),
        label: 'Timer',
      ),
      NavigationDestination(
        // icon: Badge(child: Icon(Icons.timer_outlined)),
        icon: Icon(Icons.timer_outlined),
        label: 'Messages',
      ),
    ],
    );
  }
}
