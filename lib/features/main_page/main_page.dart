import 'package:battlemaster/features/main_page/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

import '../encounters/encounters_page.dart';
import '../groups/groups_page.dart';
import '../settings/settings_page.dart';
import '../widgets/main_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _selectedPage = "combats";

  @override
  Widget build(BuildContext context) {
    final pages = {
      "combats": NavigationPage(
        page: CombatsPage(),
        title: AppLocalizations.of(context)!.combats_page_title,
        icon: LineAwesome.dragon_solid,
      ),
      "groups": NavigationPage(
        page: GroupsPage(),
        title: AppLocalizations.of(context)!.groups_page_title,
        icon: LineAwesome.users_solid,
      ),
      "settings": NavigationPage(
        page: SettingsPage(),
        title: AppLocalizations.of(context)!.settings_page_title,
        icon: Icons.settings,
      ),
    };

    return OrientationBuilder(
      builder: (context, orientation) {
        // if orientation is landscape, use a navigation rail
        // if orientation is portrait, use a drawer
        return Scaffold(
          appBar: AppBar(
            title: Text(pages[_selectedPage]!.title),
          ),
          drawer: orientation == Orientation.portrait
              ? MainDrawer(
                  selectedPage: _selectedPage,
                  pages: pages,
                  onPageSelected: (page) {
                    setState(() {
                      _selectedPage = page;
                    });
                  },
                )
              : null,
          body: Row(
            children: [
              if (orientation == Orientation.landscape)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NavigationRail(
                      selectedIndex: pages.keys.toList().indexOf(_selectedPage),
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedPage = pages.keys.toList()[index];
                        });
                      },
                      labelType: NavigationRailLabelType.selected,
                      destinations: [
                        for (final page in pages.entries)
                          NavigationRailDestination(
                            icon: Icon(page.value.icon),
                            label: Text(page.value.title),
                          ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                  ],
                ),
              Expanded(
                child: pages[_selectedPage]!.page,
              ),
            ],
          ),
        );
      },
    );
  }
}
