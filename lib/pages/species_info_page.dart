import 'package:flutter/material.dart';
import 'dart:convert';
import 'detailed_species_page.dart';
import 'package:flutter/services.dart' show rootBundle;


class ThongTinLoaiPage extends StatefulWidget {
  @override
  _ThongTinLoaiPageState createState() => _ThongTinLoaiPageState();
}

class _ThongTinLoaiPageState extends State<ThongTinLoaiPage> {
  List<String> speciesNames = [];
  List<String> filteredSpeciesNames = [];
  Map<String, dynamic> speciesData = {};
  Map<String, dynamic> conservationStatusData = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadConservationStatus();
    loadSpeciesData();
  }

  Future<void> loadConservationStatus() async {
    String jsonString =
        await rootBundle.loadString('content/conservation_status.json');
    conservationStatusData = jsonDecode(jsonString);
  }

  Future<void> loadSpeciesData() async {
    String jsonString =
        await rootBundle.loadString('content/species_info_vi.json');
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

  Widget buildConservationStatusText(Map<String, dynamic> speciesInfo) {
    String conservationStatus = speciesInfo['iucn'];
    // Map<String, dynamic> statusInfo = speciesInfo['conservation_status'];

    String hexColor = conservationStatusData[conservationStatus]['hex_color'];
    String viName = conservationStatusData[conservationStatus]['vi'];

    String newText = '$viName ($conservationStatus)';

    return Text(
      newText,
      style: TextStyle(
        color: Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000),
        fontWeight: FontWeight.bold
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
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
          const Padding(
            padding: EdgeInsets.all(16.0),
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
              decoration: const InputDecoration(
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
                              Row(
                                children: [
                                  Text('Tình trạng bảo tồn: '),
                                  buildConservationStatusText(speciesInfo),
                                ],
                              ),
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

