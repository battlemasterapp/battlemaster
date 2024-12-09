import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/main_page/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../encounters/encounters_page.dart';
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
        page: CombatsPage(type: EncounterType.encounter),
        title: AppLocalizations.of(context)!.combats_page_title,
        icon: MingCute.sword_fill,
      ),
      "groups": NavigationPage(
        page: CombatsPage(type: EncounterType.group),
        title: AppLocalizations.of(context)!.groups_page_title,
        icon: MingCute.group_fill,
      ),
      "settings": NavigationPage(
        page: SettingsPage(),
        title: AppLocalizations.of(context)!.settings_page_title,
        icon: MingCute.settings_3_fill,
      ),
    };

    return OrientationBuilder(
      builder: (context, orientation) {
        // if orientation is landscape, use a navigation rail
        // if orientation is portrait, use a drawer
        final isPortrait = orientation == Orientation.portrait;
        return Scaffold(
          appBar: isPortrait
              ? AppBar(
                  title: Text(pages[_selectedPage]!.title),
                )
              : null,
          drawer: isPortrait
              ? MainDrawer(
                  selectedPage: _selectedPage,
                  pages: pages,
                  onPageSelected: (page) => _changePage(page),
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!isPortrait)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NavigationRail(
                        backgroundColor: Colors.grey.withOpacity(.2),
                        selectedIndex:
                            pages.keys.toList().indexOf(_selectedPage),
                        onDestinationSelected: (index) => _changePage(
                          pages.keys.toList()[index],
                        ),
                        labelType: NavigationRailLabelType.all,
                        indicatorColor: Theme.of(context).primaryColor,
                        unselectedIconTheme: IconThemeData(
                          color: Theme.of(context).iconTheme.color,
                        ),
                        selectedIconTheme: IconThemeData(
                          color: Colors.white,
                          size: 27,
                        ),
                        indicatorShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
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
          ),
        );
      },
    );
  }

  void _changePage(String page) {
    setState(() {
      _selectedPage = page;
    });
    context.read<AnalyticsService>().logEvent(
      'change_page',
      props: {'page': _selectedPage},
    );
  }
}
