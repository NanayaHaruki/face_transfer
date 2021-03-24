/// Response : {"ResultImage":"base64编码的图片","ResultUrl":"base64编码的图片","RequestId":"3c140219-cfe9-470e-b241-907877d6fb03"}

class SwapGenderEntity {
  Response _response;

  Response get response => _response;

  SwapGenderEntity({
      Response response}){
    _response = response;
}

  SwapGenderEntity.fromJson(dynamic json) {
    _response = json["Response"] != null ? Response.fromJson(json["Response"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_response != null) {
      map["Response"] = _response.toJson();
    }
    return map;
  }

}

/// ResultImage : "base64编码的图片"
/// ResultUrl : "base64编码的图片"
/// RequestId : "3c140219-cfe9-470e-b241-907877d6fb03"

class Response {
  String _resultImage;
  String _resultUrl;
  String _requestId;

  String get resultImage => _resultImage;
  String get resultUrl => _resultUrl;
  String get requestId => _requestId;

  Response({
      String resultImage, 
      String resultUrl, 
      String requestId}){
    _resultImage = resultImage;
    _resultUrl = resultUrl;
    _requestId = requestId;
}

  Response.fromJson(dynamic json) {
    _resultImage = json["ResultImage"];
    _resultUrl = json["ResultUrl"];
    _requestId = json["RequestId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ResultImage"] = _resultImage;
    map["ResultUrl"] = _resultUrl;
    map["RequestId"] = _requestId;
    return map;
  }

}