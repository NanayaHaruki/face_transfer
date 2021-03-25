import 'dart:convert';
import 'dart:io';

import 'package:face_transfer/data/ResponseResult.dart';
import 'package:face_transfer/data/edit_face_response_entity.dart';
import 'package:face_transfer/net/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<int> imgData;
  Widget? _image;
  final picker = ImagePicker();
  bool loading = false;
  int childFeatureIndex = 0;

  Future pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    getImage(pickedFile);
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    getImage(pickedFile);
  }

  void getImage(pickedFile) {
    setState(() {
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        _image = Image.file(file);
        imgData = file.readAsBytesSync();
      } else {
        print('No image selected.');
      }
    });
  }

  Future swapGender(String actionType) async {
    setState(() {
      loading = true;
    });

    // 百度不支持4000像素以上
    Img.Image uploadImg = Img.decodeImage(imgData)!;
    int width = uploadImg.width;
    int height = uploadImg.height;
    if (width > 4000) width = 4000;
    if (height > 4000) height = 4000;

    if (width == 4000 || height == 4000) {
      uploadImg = Img.copyResize(uploadImg, width: width, height: height);
    }
    var imgBase64 = Base64Encoder().convert(Img.writePng(uploadImg));

    ResponseResult<EditFaceResponseEntity> result =
        await Api.swapGenderByBaidu(imgBase64, actionType);
    setState(() {
      loading = false;
      if (result.isSuccess()) {
        if (result.data?.errorCode == 0 && result.data?.result != null) {
          var uint8list = base64Decode(result.data!.result!.image);
          _image = Image.memory(uint8list);
          imgData = uint8list;
        } else {
          _image = Text(result.data!.errorMsg);
        }
      } else {
        _image = Text(result.msg!);
      }
    });
  }

  void onGenderPress(int index) {
    String actionType;
    if (index == 0) {
      actionType = "TO_MALE";
    } else {
      actionType = "TO_FEMALE";
    }
    swapGender(actionType);
  }

  void onAgePress(int index) {
    String actionType;
    if (index == 0) {
      actionType = "TO_KID";
    } else {
      actionType = "TO_OLD";
    }
    swapGender(actionType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Face Transfer'),
        ),
        body: Column(
          children: [
            Offstage(
              offstage: !loading,
              child: LinearProgressIndicator(),
            ),
            Expanded(
                child: Center(
              child: _image == null
                  ? Text(
                      '请选一张图',
                      style: TextStyle(fontSize: 18),
                    )
                  : _image,
            )),
            Offstage(
              offstage: _image == null,
              child: Column(
                children: [
                  IndexedStack(
                    index: childFeatureIndex,
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () => onGenderPress(0),
                              icon: Image.asset(
                                "assets/images/male.png",
                                width: 20,
                                height: 20,
                              ),
                              label: Text("男")),
                          TextButton.icon(
                              onPressed: () => onGenderPress(1),
                              icon: Image.asset("assets/images/female.png",
                                  width: 20, height: 20),
                              label: Text("女"))
                        ],
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () => onAgePress(0),
                              icon: Image.asset("assets/images/child.png",
                                  width: 20, height: 20),
                              label: Text("小孩")),
                          TextButton.icon(
                              onPressed: () => onAgePress(1),
                              icon: Image.asset("assets/images/oldman.png",
                                  width: 20, height: 20),
                              label: Text("老人"))
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              childFeatureIndex = 0;
                            });
                          },
                          icon: Image.asset("assets/images/gender.png",
                              width: 20, height: 20),
                          label: Text("性别")),
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              childFeatureIndex = 1;
                            });
                          },
                          icon: Image.asset("assets/images/age.png",
                              width: 20, height: 20),
                          label: Text("年龄"))
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: pickImageFromCamera),
                IconButton(
                    icon: Icon(Icons.photo_album),
                    onPressed: pickImageFromGallery)
              ],
            )
          ],
        ));
  }
}
