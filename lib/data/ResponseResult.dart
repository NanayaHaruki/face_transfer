class ResponseResult<T>{
  int code;
  String msg;
  T data;
  ResponseResult(this.code,this.msg,this.data);

  bool isSuccess() => code == SUCCESS;
  static final SUCCESS = 0;
  static final FAILED = -1;

  static ResponseResult failed(String msg) => ResponseResult(FAILED, msg, null);
  static ResponseResult success(data) => ResponseResult(SUCCESS, null, data);
}