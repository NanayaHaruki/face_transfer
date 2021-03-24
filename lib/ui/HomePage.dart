import 'dart:convert';
import 'dart:io';

import 'package:face_transfer/data/ResponseResult.dart';
import 'package:face_transfer/data/swap_gender_baidu_response.dart';
import 'package:face_transfer/data/swap_gender_entity.dart';
import 'package:face_transfer/net/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _localImg;
  Widget _image;
  final picker = ImagePicker();
  bool loading = false;
  int childFeatureIndex = 0;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _localImg = File(pickedFile.path);
        _image = Image.file(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void swapGender(String actionType) async {
    setState(() {
      loading = true;
    });
    var imgBytes = await _localImg.readAsBytes();
    var imgBase64 = Base64Encoder().convert(imgBytes);
    ResponseResult<SwapGenderBaiduResponse> result =
        await Api.swapGenderByBaidu(imgBase64, actionType);
    setState(() {
      loading = false;
      if (result.isSuccess()) {
        _image =
            Image.memory(Base64Decoder().convert(result.data.result.image));
      } else {
        _image = Text(result.msg);
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
