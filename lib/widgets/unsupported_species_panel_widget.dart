import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vnturtle/widgets/result_block_widget.dart';

class UnsupportedSpeciesTogglePanel extends StatefulWidget {
  final Map<String, dynamic> speciesInfo;
  final FilePickerResult image;

  const UnsupportedSpeciesTogglePanel({
    super.key, 
    required this.speciesInfo,
    required this.image
  });

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
                  AppLocalizations.of(context)!.notSupportedSpeciesTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          body: Container(
            height: 350,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final entry in widget.speciesInfo.entries.toList())
                    ResultBlock(
                      image: widget.image, 
                      score: -1, 
                      speciesInfo: entry.value
                    ),
                  ]
                ),
              ),
          ),
            
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}