import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class VeChungToiPage extends StatefulWidget {
  @override
  _VeChungToiPageState createState() => _VeChungToiPageState();
}

class _VeChungToiPageState extends State<VeChungToiPage> {
  Future<String> _loadAboutUsContent() async {
    return await rootBundle.loadString('content/about_us.md');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VNTURTLE', 
        ),
      ),
      body: FutureBuilder(
        future: _loadAboutUsContent(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load about us content.'
                ),
              );
            } else {
              return Markdown(data: snapshot.data!);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}