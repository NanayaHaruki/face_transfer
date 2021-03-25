class ResponseResult<T> {
  int code;
  String? msg;
  T? data;

  ResponseResult(this.code, this.msg, this.data);

  bool isSuccess() => code == SUCCESS;
  static const SUCCESS = 0;
  static const FAILED = -1;

  static ResponseResult<T> failed<T>(String msg) =>
      ResponseResult(FAILED, msg, null);

  static ResponseResult<T> success<T>(data) =>
      ResponseResult(SUCCESS, null, data);
}
