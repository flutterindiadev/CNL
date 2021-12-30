import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/mybutton.dart';
import '../widgets/drawer.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({Key? key}) : super(key: key);

  static const routename = '/kyc-screen';

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _picker = ImagePicker();
  File? _savedAdharFront;
  File? _savedPancardImage;

  Future _pickImage() async {
    final _adharfront = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 200, imageQuality: 50);
    setState(() {
      _savedPancardImage = File(_adharfront!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
          ),
        ),
        title: const Text('Coinlee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
        //TODO : Appbar footer here
      ),
      drawer: const drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  label: const Text('Full Name'),
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  label: const Text('Pancard '),
                  hintText: 'Enter your pancard number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: _savedPancardImage == null
                  ? Image.asset('assets/images/camera.png',
                      height: 200, width: 200)
                  : Image.file(_savedPancardImage!),
              onTap: _pickImage,
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              'Scan Pancard',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: MyButton(text: 'Ok'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
