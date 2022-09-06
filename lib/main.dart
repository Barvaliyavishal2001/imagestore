import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: images(),
  ));
}

class images extends StatefulWidget {
  const images({Key? key}) : super(key: key);

  @override
  State<images> createState() => _imagesState();
}

class _imagesState extends State<images> {
  XFile? image;
  final ImagePicker _picker = ImagePicker();
  bool temp = false;

  @override
  void initState() {
    super.initState();
    get_parmission();
  }

  get_parmission() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.camera);
              },
              child: Text("Camera")),
          ElevatedButton(
              onPressed: () async {
                Directory? temp = await getExternalStorageDirectory();
                Directory? mydir = Directory("${temp!.path}/d1");

                if (!await mydir!.exists()) {
                  mydir.create();
                }
                int num = Random().nextInt(1000);
                String imgName = "img$num.jpg";
                File file = File("${mydir.path}/$imgName");
                file.writeAsBytes(await image!.readAsBytes());
                print("imagepath=${file.path}");
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}
