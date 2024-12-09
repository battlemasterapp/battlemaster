import 'package:flutter/material.dart';

import '../main_page/navigation_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.selectedPage,
    this.pages = const {},
    this.onPageSelected,
  });

  final String selectedPage;
  final Map<String, NavigationPage> pages;
  final ValueChanged<String>? onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(8),
            child: Text(
              "BattleMaster",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          for (final page in pages.entries)
            ListTile(
              title: Text(page.value.title),
              leading: Icon(page.value.icon),
              selected: selectedPage == page.key,
              onTap: () {
                onPageSelected?.call(page.key);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
