import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ResultPage extends StatefulWidget {
  ResultPage({
    Key? key,
    required this.image,
  }) : super(key: key);
  File image;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List? _result;

  @override
  void initState() {
    super.initState();
    uploadFileToServer();
  }
  
  void uploadFileToServer() async {
    var url = 'http://13.56.151.69:5000';
    Map<String, String> headers = {
      "connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000",
    };

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('$url/fetch_skin_tone'));
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        widget.image.path,
        contentType: MediaType('application', 'jpeg'),
      ),
    );

    request.send().then((r) async {
      if (r.statusCode == 200) {
        var result = json.decode(await r.stream.transform(utf8.decoder).join());

        setState(() {
          _result = result;
        });
      }
    });
  }

  Padding buildImageContainer(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        width: width,
        height: height * 0.4,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: widget.image == null
            ? Center(
                child: Text('Image error'),
              )
            : Stack(children: [
                Container(
                  width: width,
                  height: height * 0.4,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.file(
                      File(widget.image!.path),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 214, 225),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 245, 229, 141),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 100,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 85,
                width: 110,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo_transparent.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _result != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    buildImageContainer(width, height),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            color: Color.fromRGBO(_result![0][0],
                                _result![0][1], _result![0][2], 1)),
                        Column(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              'Tone: ${_result![1].split('_')[0].toUpperCase()}',
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Undertone:  ${_result![1].split('_')[1].toUpperCase()}',
                              style: const TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Analyzing Image"),
                  ),
                ],
              ),
            ),
    );
  }
}
