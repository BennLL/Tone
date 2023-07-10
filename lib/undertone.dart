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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: null,
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
