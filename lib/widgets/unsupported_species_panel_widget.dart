import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnsupportedSpeciesTogglePanel extends StatefulWidget {
  @override
  _UnsupportedSpeciesTogglePanelState createState() => _UnsupportedSpeciesTogglePanelState();
}

class _UnsupportedSpeciesTogglePanelState extends State<UnsupportedSpeciesTogglePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionPanelList(
      elevation: 1,
      expandIconColor: theme.primaryColor,
      expandedHeaderPadding: EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !isExpanded;
                });
              },
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.notSupportedSpeciesToggleTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          body: Text('world'),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}