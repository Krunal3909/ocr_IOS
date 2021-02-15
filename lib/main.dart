import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR IOS',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = '';
  File image;
  ImagePicker imagePicker;

  pickImageFromGallery() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    setState(() {
      image;
      //do image to text
      perfomImageLabeling();
    });
  }

  captureImageWithCamera() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    setState(() {
      image;
      //do image to text
      perfomImageLabeling();
    });
  }

  perfomImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += element.text + "";
          }
        }
        result += "\n\n";
        print(result); // for testing
      }
    });
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 100,
              width: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 140,
                  height: 150,
                  decoration: new BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 12.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      captureImageWithCamera();
                    },
                    child: Card(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            Icon(Icons.camera),
                            SizedBox(height: 18.0),
                            Text(
                              'Camera',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 140,
                    height: 150,
                    decoration: new BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 12.0,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        pickImageFromGallery();
                      },
                      child: Card(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            children: [
                              Icon(Icons.file_upload),
                              SizedBox(height: 14.0),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            Container(
              height: 280,
              width: 250,
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 30.0,
              height: 30.0,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
                Clipboard.setData(ClipboardData(text: result));
              },
              label: Text('Copy Text '),
              icon: Icon(Icons.copy),
              backgroundColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
