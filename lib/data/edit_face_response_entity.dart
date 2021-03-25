import 'package:face_transfer/generated/json/base/json_convert_content.dart';
import 'package:face_transfer/generated/json/base/json_field.dart';

class EditFaceResponseEntity with JsonConvert<EditFaceResponseEntity> {
	@JSONField(name: "error_code")
	late int errorCode;
	@JSONField(name: "error_msg")
	late String errorMsg;
	@JSONField(name: "log_id")
	late int logId;
	late int timestamp;
	late int cached;
	EditFaceResponseResult? result;
}

class EditFaceResponseResult with JsonConvert<EditFaceResponseResult> {
	late String image;
}
