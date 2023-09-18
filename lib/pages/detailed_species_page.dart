import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DetailedSpeciesPage extends StatelessWidget {
  final String speciesName;
  Map<String, dynamic> speciesData = {};

  DetailedSpeciesPage({required this.speciesName});

  Future<Map<String, dynamic>> loadSpeciesData() async {
    String jsonString =
        await rootBundle.loadString('content/species_info_vi.json');
    return jsonDecode(jsonString);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadSpeciesData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> speciesInfo = snapshot.data[speciesName];
          // Use the 'jsonData' variable to access the JSON data
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'VNTURTLE', 
              ),
            ),
            body: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      speciesInfo['primary_name'],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Đặc điểm nhận dạng',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: speciesInfo['identification_images']
                        .map<Widget>(
                          (image) => Image.asset(
                            image,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Hình tham khảo',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: speciesInfo['reference_images']
                        .map<Widget>(
                          (image) => Image.asset(
                            image,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Tình trạng bảo tồn: ${speciesInfo['iucn']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Tên tiếng Anh: ${speciesInfo['name_en']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Bản đồ phân bố: ${speciesInfo['distribution']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Thông tin thú vị: ${speciesInfo['fun_fact']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Sự cố hiển thị thông tin. Vui lòng thử lại sau');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  // Widget build(BuildContext context) {
    
    
  // }
}