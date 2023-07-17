import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'result.dart';

class ToneUnderTonePage extends StatefulWidget {
  const ToneUnderTonePage({super.key});

  @override
  State<ToneUnderTonePage> createState() => _ToneUnderTonePageState();
}

class _ToneUnderTonePageState extends State<ToneUnderTonePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  _imgFromCamera() async {
    final image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    final image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'images/replace.png',
            height: 100,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Do You want to change the current Image?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
                _showPicker();
              },
              child: const Text("yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
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
        child: _image == null
            ? IconButton(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                ),
                onPressed: () {
                  _showPicker();
                },
              )
            : Stack(
                children: [
                  Container(
                    width: width,
                    height: height * 0.4,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {
                        _showMyDialog();
                      },
                      color: const Color.fromRGBO(31, 150, 247, 1),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromRGBO(252, 186, 3, 1),
              Color.fromRGBO(241, 243, 147, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: height * 0.12,
              child: Image.asset(
                "images/logo_transparent.png",
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
              child: Column(
                children: [
                  const Text(
                    "Test Your Skin Tone & Undertone",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(50, 50, 50, 1),
                    ),
                  ),
                  Container(
                    height: 3,
                    color: const Color.fromRGBO(50, 50, 50, 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildImageContainer(width, height),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _image == null
                        ? null
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ResultPage(image: _image!),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(50, 50, 50, 1)),
                            child: const Text(
                              "Analyze",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
