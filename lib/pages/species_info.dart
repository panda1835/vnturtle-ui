import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/services.dart';
import 'detailed_species_page.dart';

class ThongTinLoaiPage extends StatefulWidget {
  @override
  _ThongTinLoaiPageState createState() => _ThongTinLoaiPageState();
}

class _ThongTinLoaiPageState extends State<ThongTinLoaiPage> {
  List<String> speciesNames = [];
  List<String> filteredSpeciesNames = [];
  Map<String, dynamic> speciesData = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSpeciesData();
  }

  Future<void> loadSpeciesData() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString('content/species_info_vi.json');
    speciesData = jsonDecode(jsonString);

    setState(() {
      speciesNames = speciesData.keys.toList();
      filteredSpeciesNames = speciesNames;
    });
  }

  void filterSpeciesList(String query) {
    setState(() {
      filteredSpeciesNames = speciesNames.where((name) {
        Map<String, dynamic> speciesInfo = speciesData[name];
        String nameVi = speciesInfo['primary_name'];
        String conservationStatus = speciesInfo['iucn'];
        String nameEn = speciesInfo['secondary_name'];
        String nameSci = speciesInfo['scientific_name'];

        return nameVi.toLowerCase().contains(query.toLowerCase()) ||
            conservationStatus.toLowerCase().contains(query.toLowerCase()) ||
            nameSci.toLowerCase().contains(query.toLowerCase()) ||
            nameEn.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToDetailPage(String speciesName) {
    Map<String, dynamic> speciesInfo = speciesData[speciesName];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedSpeciesPage(speciesInfo: speciesInfo),
      ),
    );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Thông Tin Loài',
              style: TextStyle(
                fontSize: 24.0, 
                fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSpeciesList,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSpeciesNames.length,
              itemBuilder: (context, index) {
                String speciesName = filteredSpeciesNames[index];
                Map<String, dynamic> speciesInfo = speciesData[speciesName];

                return GestureDetector(
                  onTap: () => navigateToDetailPage(speciesName),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration( 
                      color: theme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.black38, // Border color
                        width: 0.5, // Border width
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(speciesInfo['reference_images'][0]),
                              // image: AssetImage('images/reference_images/Heosemys_grandis/Heosemys_grandis_cover.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                speciesInfo['primary_name'],
                                style:
                                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Tình trạng bảo tồn: ${speciesInfo['iucn']}'),
                              SizedBox(height: 8.0),
                              Text('Tên khoa học: ${speciesInfo['scientific_name']}'),
                              SizedBox(height: 8.0),
                              Text('Tên tiếng Anh: ${speciesInfo['secondary_name']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

