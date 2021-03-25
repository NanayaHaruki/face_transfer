import 'package:dio/dio.dart';
import 'package:face_transfer/data/ResponseResult.dart';
import 'package:face_transfer/generated/json/base/json_convert_content.dart';
import 'package:face_transfer/net/HttpManager.dart';
import 'package:face_transfer/data/edit_face_response_entity.dart';

class Api {
  static String? baiduToken;

  static Future fetchBaiduToken() async {
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

  static ResponseResult<T> createRemoteResponseResult<T>(Response response) {
    if (response.statusCode == 200) {
      T data = JsonConvert.fromJsonAsT<T>(response.data);
      return ResponseResult.success(data);
    } else {
      return ResponseResult.failed(
          "${response.statusCode}: ${response.statusMessage}");
    }
  }

  static Future<ResponseResult<EditFaceResponseEntity>> swapGenderByBaidu(
      String imgBase64, String actionType) async {
    if (baiduToken == null) {
      await fetchBaiduToken();
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
