class PublicArgs{
  String action;
  String region;
  int timestamp;
  String version;
  String auth;
  String token;

  PublicArgs(this.action,this.region,this.version,this.timestamp);

  Map<String,dynamic> toMap(){
    var map =  {
      "X-TC-Action": action,
      "X-TC-Timestamp": timestamp,
      "X-TC-Version": version,
      "X-TC-Authorization": auth,
    };

    if(region!=null) {
      map["X-TC-Region"]=region;
    }
    if(token!=null) {
      map["X-TC-Token"]=token;
    }
    return map;
  }
}