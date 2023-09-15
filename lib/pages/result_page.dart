import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> jsonResponse;

  const ResultPage({required this.jsonResponse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.secondaryHeaderColor,
        title: Text(
          'VNTURTLE',
          style: TextStyle(
            fontFamily: "Happy Monkey", 
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Kết quả',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          Column(
            children: List<Widget>.from(jsonResponse['predictions'].entries.map((entry) {
              final prediction = entry.value;
              final scientificName = prediction['scientific_name'];
              final score = prediction['score'];

              return ListTile(
                title: Text(scientificName),
                subtitle: Text('Score: $score'),
              );
            })),
          ),
        ],
      ),
    );
  }
}