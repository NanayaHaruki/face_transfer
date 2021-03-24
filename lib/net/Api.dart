import 'package:dio/dio.dart';
import 'package:face_transfer/data/ResponseResult.dart';
import 'package:face_transfer/data/swap_gender_baidu_response.dart';
import 'package:face_transfer/data/swap_gender_entity.dart'
    as tencentSwapGenderDTO;
import 'package:face_transfer/net/HttpManager.dart';
import 'package:face_transfer/net/PublicArgs.dart';

class Api {
  static Future<tencentSwapGenderDTO.SwapGenderEntity> swapGenderByTencent(
      String imgBase64,
      {String resImgType = 'base64'}) async {
    var header = PublicArgs("SwapGenderPic", "ap-shanghai", "2020-03-04",
            DateTime.now().microsecondsSinceEpoch * 1000)
        .toMap();

    var data = {
      "Image": imgBase64,
      "RspImgType": resImgType,
      "GenderInfos": [
        {"Gender": 0}
      ]
    };
    header["Image"] = imgBase64;
    header["RspImgType"] = resImgType;
    var response = await HttpManager().http.post(
        "https://ft.tencentcloudapi.com",
        data: data,
        options: Options(headers: header));
    return tencentSwapGenderDTO.SwapGenderEntity.fromJson(response.data);
  }

  static String baiduToken;

  static void fetchBaiduToken() async {
    if (baiduToken == null) {
      var tokenParams = {
        "grant_type": "client_credentials",
        "client_id": "DHv2e54LrMgdFzNO7EQGinQG",
        "client_secret": "RuRxrykv11AmLCGctfeHiz4w1zY7b8ZN",
      };
      try {
        var tokenResponse = await HttpManager().http.post(
            "https://aip.baidubce.com/oauth/2.0/token",
            queryParameters: tokenParams);
        if (tokenResponse.statusCode == 200) {
          baiduToken = tokenResponse.data["access_token"];
        } else {
          print(tokenResponse.statusMessage);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static ResponseResult createRemoteResponseResult(Response response) {
    if (response.statusCode == 200) {
      SwapGenderBaiduResponse swapGenderBaiduResponse =
          SwapGenderBaiduResponse.fromJson(response.data);
      return ResponseResult.success(swapGenderBaiduResponse);
    } else {
      return ResponseResult.failed(
          "${response.statusCode}: ${response.statusMessage}");
    }
  }

  static Future<ResponseResult<SwapGenderBaiduResponse>> swapGenderByBaidu(
      String imgBase64, String actionType) async {
    if (baiduToken == null) {
      fetchBaiduToken();
      if (baiduToken == null) {
        return ResponseResult.failed("获取token失败");
      }
    }
    var queryParams = {"access_token": baiduToken};
    var params = {
      "image": imgBase64,
      "image_type": "BASE64",
      "quality_control": "NORMAL",
      "action_type": actionType
    };
    try {
      Response response = await HttpManager().http.post(
          "https://aip.baidubce.com/rest/2.0/face/v1/editattr",
          queryParameters: queryParams,
          data: params);
      return createRemoteResponseResult(response);
    }catch(e){
      return ResponseResult.failed(e.toString());
    }
  }
}
