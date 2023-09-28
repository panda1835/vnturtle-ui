import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ConfirmPage extends StatefulWidget {
  final String scientificName;

  const ConfirmPage({
    required this.scientificName,
  });

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool _isContributed = false;
  Map<String, dynamic> speciesData = {};
  String imagePath = '';
  String speciesName = '';
  String warning = '';

  Future<void> loadSpeciesData() async {
    String jsonString =
        await rootBundle.loadString('content/species_info_vi.json');
    setState(() {
      speciesData = jsonDecode(jsonString)[widget.scientificName];
      imagePath = speciesData['reference_images'][0];
      speciesName = speciesData['primary_name'];
      warning = speciesData['warning'];
    });
  }

  Future<void> _makeAPICall() async {
    // Make the POST request to the API
    // Replace API_URL with your actual API endpoint
    
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isContributed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSpeciesData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('VNTURTLE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // margin: EdgeInsets.only(top: 100),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(imagePath), // Replace with your image path
              ),
            ),
            SizedBox(height: 20),
            Text(
              speciesName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.scientificName,
              style: TextStyle(
                // fontSize: 30,
                fontStyle: FontStyle.italic,
                // color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              child: Text(
                warning,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              child: RichText(
                text: TextSpan(
                  text: 'Liên hệ đường dây nóng bảo vệ động vật hoang dã ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '1800-1522',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: ' để được hỗ trợ.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isContributed ? null : _makeAPICall,
              child: Text('Đóng góp ảnh'),
            ),
            SizedBox(height: 20),
            Tooltip(
              message: 'Khi bạn chọn "Đóng góp ảnh", ảnh của bạn sẽ được lưu trên hệ thống. Đóng góp của bạn sẽ giúp nâng cao độ chính xác và hiệu suất của ứng dụng',
              child: IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  // Handle the tooltip button click
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Đóng góp ảnh'),
                        content: Text('Khi bạn chọn "Đóng góp ảnh", ảnh của bạn sẽ được lưu trên hệ thống. Đóng góp của bạn sẽ giúp nâng cao độ chính xác và hiệu suất của ứng dụng.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Đóng'),
                          ),
                        ],
                      );
                    },
                  );
                }
              )
            ),
            if (_isContributed)
              Container(
                width: 400,
                child: Text(
                  """Cảm ơn đóng góp của bạn. Đóng góp của bạn sẽ giúp chúng mình có thêm dữ liệu để cải thiện chất lượng nhận diện của VNTurtle!""",
                ),
              ),
          ],
        ),
      ),
    );
  }
}
