import 'package:flutter/material.dart';
import '../widgets/result_block_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ResultPage extends StatefulWidget {
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
    final jsonString =
        await rootBundle.loadString('content/species_info_vi.json');
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
        "prediction1": {
          "scientific_name": "Platysternon megacephalum",
          "score": "70"
        },
        "prediction2": {
          "scientific_name": "Cuora amboinensis",
          "score": "20"
        },
        "prediction3": {
          "scientific_name": "Cuora galbinifrons",
          "score": "5"
        },
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
    return Scaffold(
      appBar: AppBar(
        title: Text('VNTURTLE'),
      ),
      body: Column(
        children: [
          // First Half - Title and Image
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.imageUrl,
                    // fit: BoxFit.cover,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          // Second Half - List View (wrapped with SingleChildScrollView)
          Expanded(
            flex: 2,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final entry
                            in jsonResponse['predictions'].entries)
                          ResultBlock(
                            scientificName: entry.value['scientific_name'],
                            nameVi: speciesInfo[entry.value['scientific_name']]['primary_name'],
                            score: entry.value['score'],
                            imagePaths: (speciesInfo[entry.value['scientific_name']]
                                    ['reference_images'] as List<dynamic>)
                                .cast<String>(),
                          ),

                        ResultBlock(
                            scientificName: 'No match',
                            nameVi: '',
                            score: '',
                            imagePaths: [],
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}