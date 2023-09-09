import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ThongTinLoaiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('content/species_info.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> speciesData = jsonDecode(snapshot.data.toString())['species'];

          List<String> speciesNames = speciesData.keys.toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Species List'),
            ),
            body: ListView.builder(
              itemCount: speciesNames.length,
              itemBuilder: (context, index) {
                String speciesName = speciesNames[index];
                Map<String, dynamic> speciesInfo = speciesData[speciesName];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedSpeciesPage(speciesData: speciesInfo),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(speciesInfo['reference_images'][0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                speciesInfo['name_vi'],
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Tình trạng bảo tồn: ${speciesInfo['conservation_status']}'),
                              SizedBox(height: 8.0),
                              Text('Tên Tiếng Anh: ${speciesInfo['name_en']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Species List'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class DetailedSpeciesPage extends StatelessWidget {
  final Map<String, dynamic> speciesData;

  DetailedSpeciesPage({required this.speciesData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(speciesData['name_vi']),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Đặc điểm nhận dạng',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: speciesData['identification_images']
                  .map<Widget>((image) => Image.asset(
                        image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Hình tham khảo',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: speciesData['reference_images']
                  .map<Widget>((image) => Image.asset(
                        image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Text('Conservation Status: ${speciesData['conservation_status']}'),
          SizedBox(height: 8.0),
          Text('English Name: ${speciesData['name_en']}'),
          SizedBox(height: 8.0),
          Text('Distribution: ${speciesData['distribution']}'),
          SizedBox(height: 8.0),
          Text('Fun Fact: ${speciesData['fun_fact']}'),
        ],
      ),
    );
  }
}