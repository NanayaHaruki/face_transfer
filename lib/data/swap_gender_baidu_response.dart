/// error_code : 0
/// error_msg : "SUCCESS"
/// log_id : 525791510175
/// timestamp : 1616556951
/// cached : 0
/// result : {"image":"123"}

class SwapGenderBaiduResponse {
  int _errorCode;
  String _errorMsg;
  int _logId;
  int _timestamp;
  int _cached;
  Result _result;

  int get errorCode => _errorCode;
  String get errorMsg => _errorMsg;
  int get logId => _logId;
  int get timestamp => _timestamp;
  int get cached => _cached;
  Result get result => _result;

  SwapGenderBaiduResponse({
      int errorCode, 
      String errorMsg, 
      int logId, 
      int timestamp, 
      int cached, 
      Result result}){
    _errorCode = errorCode;
    _errorMsg = errorMsg;
    _logId = logId;
    _timestamp = timestamp;
    _cached = cached;
    _result = result;
}

  SwapGenderBaiduResponse.fromJson(dynamic json) {
    _errorCode = json["error_code"];
    _errorMsg = json["error_msg"];
    _logId = json["log_id"];
    _timestamp = json["timestamp"];
    _cached = json["cached"];
    _result = json["result"] != null ? Result.fromJson(json["result"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["error_code"] = _errorCode;
    map["error_msg"] = _errorMsg;
    map["log_id"] = _logId;
    map["timestamp"] = _timestamp;
    map["cached"] = _cached;
    if (_result != null) {
      map["result"] = _result.toJson();
    }
    return map;
  }

}

/// image : "123"

class Result {
  String _image;

  String get image => _image;

  Result({
      String image}){
    _image = image;
}

  Result.fromJson(dynamic json) {
    _image = json["image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["image"] = _image;
    return map;
  }

}