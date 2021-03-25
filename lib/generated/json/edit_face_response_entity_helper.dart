import 'package:face_transfer/data/edit_face_response_entity.dart';

editFaceResponseEntityFromJson(EditFaceResponseEntity data, Map<String, dynamic> json) {
	if (json['error_code'] != null) {
		data.errorCode = json['error_code'] is String
				? int.tryParse(json['error_code'])
				: json['error_code'].toInt();
	}
	if (json['error_msg'] != null) {
		data.errorMsg = json['error_msg'].toString();
	}
	if (json['log_id'] != null) {
		data.logId = json['log_id'] is String
				? int.tryParse(json['log_id'])
				: json['log_id'].toInt();
	}
	if (json['timestamp'] != null) {
		data.timestamp = json['timestamp'] is String
				? int.tryParse(json['timestamp'])
				: json['timestamp'].toInt();
	}
	if (json['cached'] != null) {
		data.cached = json['cached'] is String
				? int.tryParse(json['cached'])
				: json['cached'].toInt();
	}
	if (json['result'] != null) {
		data.result = EditFaceResponseResult().fromJson(json['result']);
	}
	return data;
}

Map<String, dynamic> editFaceResponseEntityToJson(EditFaceResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['error_code'] = entity.errorCode;
	data['error_msg'] = entity.errorMsg;
	data['log_id'] = entity.logId;
	data['timestamp'] = entity.timestamp;
	data['cached'] = entity.cached;
	data['result'] = entity.result?.toJson();
	return data;
}

editFaceResponseResultFromJson(EditFaceResponseResult data, Map<String, dynamic> json) {
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	return data;
}

Map<String, dynamic> editFaceResponseResultToJson(EditFaceResponseResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['image'] = entity.image;
	return data;
}