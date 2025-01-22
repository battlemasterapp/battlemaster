import 'dart:math';

import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class SyncStatus extends StatelessWidget {
  const SyncStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: LayoutBuilder(
        builder: (context, layout) {
          final iconSize = min(128, layout.maxHeight / 3).toDouble();
          if (authProvider.isAnonymous) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FIcon(
                  GI.GiHoodedFigure,
                  size: iconSize,
                  color: Theme.of(context).iconTheme.color ??
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black,
                ),
                const SizedBox(height: 16),
                Text(
                  "Você está logado como um usuário anônimo.",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                    "Saia e entre na sua conta para sincronizar seus combates."),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    authProvider.logout();
                  },
                  child: Text("Sair"),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FIcon(
                GI.GiTabletopPlayers,
                size: iconSize,
                color: Theme.of(context).iconTheme.color ??
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    Colors.black,
              ),
              Text(
                "Você está logado como ${authProvider.userModel?.getStringValue('name')}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("Seus dados estão sincronizados"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  authProvider.logout();
                },
                child: Text("Sair"),
              ),
            ],
          );
        },
      ),
    );
  }
}
