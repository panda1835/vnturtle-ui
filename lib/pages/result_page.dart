import 'package:flutter/material.dart';
import 'result_block_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ResultPage extends StatefulWidget {
  // final Map<String, dynamic> jsonResponse;
  final String imageUrl;

  const ResultPage({required this.imageUrl});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;
  late Map<String, dynamic> jsonResponse;
  Map<String, dynamic> speciesInfo = {};
  
  @override
  void initState() {
    super.initState();
    _processData(widget.imageUrl);
    loadData();
  }

  Future<Map<String, dynamic>> loadSpeciesInfo() async {
    final jsonString = await rootBundle.loadString('content/species_info_vi.json');
    return json.decode(jsonString);
  }

  void loadData() async {
    speciesInfo = await loadSpeciesInfo();
    // Use the speciesInfo variable to access the JSON data
  }

  Future<Map<String, dynamic>> _placeholderApiCall(String imagePath) async {
    // Placeholder API call function that returns a mock JSON response
    // In a real implementation, you would make an actual API request here
    // and receive the JSON response
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    return {
      "predictions": {
        "prediction1": {"scientific_name": "Platysternon megacephalum", "score": "70"},
        "prediction2": {"scientific_name": "Cuora amboinensis", "score": "20"},
        "prediction3": {"scientific_name": "Cuora galbinifrons", "score": "5"},
        "prediction4": {"scientific_name": "Cuora bourreti", "score": "3"},
        "prediction5": {"scientific_name": "Cuora mouhotii", "score": "2"}
      }
    };
  }

  Future<void> _processData(url) async {
    // Simulating an API request delay
    // Placeholder API call function for testing
    jsonResponse = await _placeholderApiCall(url);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryHeaderColor,
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
            ),
          ),
          Image.network(widget.imageUrl),
          SizedBox(height: 16.0),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            Column(
              children: [
                SizedBox(height: 16.0),
                
                for (final entry in jsonResponse['predictions'].entries)
                  ResultBlock(
                    // scientificName: entry.key,
                    nameVi: speciesInfo[entry.value['scientific_name']]['primary_name'],
                    score: entry.value['score'],
                    imagePaths: (speciesInfo[entry.value['scientific_name']]['reference_images'] as List<dynamic>).cast<String>(),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}