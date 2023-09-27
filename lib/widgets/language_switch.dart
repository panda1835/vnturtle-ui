import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vnturtle/l10n/l10n.dart';
import 'package:vnturtle/provider/locale_provider.dart';

class LanguageSwitchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return PopupMenuButton<Locale>(
      icon: Container(
        width: 32,
        height: 32,
        child: const Icon(Icons.language, color: Colors.green),
      ),
      itemBuilder: (BuildContext context) {
        return L10n.all.map(
          (locale) {
            final flag = L10n.getName(locale.languageCode);

            return PopupMenuItem<Locale>(
              child: ListTile(
                leading: Text(
                  flag,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList();
      },
      onSelected: (_) {},
    );
  }
}