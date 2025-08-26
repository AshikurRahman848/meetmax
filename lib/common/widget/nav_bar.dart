import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'Feed'),
        NavigationDestination(icon: Icon(Icons.people_outline), label: 'My community'),
        NavigationDestination(icon: Icon(Icons.public_outlined), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.notifications_none), label: 'Notification'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
  }
}
