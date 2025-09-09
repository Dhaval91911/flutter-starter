// To parse this JSON data, do
//
//     final checkAppVersionModel = checkAppVersionModelFromJson(jsonString);

CheckAppVersionModel deserializeCheckAppVersionModel(Map<String, dynamic> json) => CheckAppVersionModel.fromJson(json);

Map<String, dynamic> serializeCheckAppVersionModel(CheckAppVersionModel data) => data.toJson();

class CheckAppVersionModel {
  bool success;
  int statuscode;
  String message;
  Data data;

  CheckAppVersionModel({required this.success, required this.statuscode, required this.message, required this.data});

  // Factory method for parsing JSON to object
  factory CheckAppVersionModel.fromJson(Map<String, dynamic> json) =>
      CheckAppVersionModel(success: json['success'], statuscode: json['statuscode'], message: json['message'], data: Data.fromJson(json['data']));

  // Convert object to JSON
  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message, 'data': data.toJson()};
}

class Data {
  bool isNeedUpdate;
  bool isForceUpdate;
  bool isMaintenance;
  String termsAndConditions;
  String privacyPolicy;
  String about;

  Data({
    required this.isNeedUpdate,
    required this.isForceUpdate,
    required this.isMaintenance,
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.about,
  });

  // Factory method for parsing JSON to object
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isNeedUpdate: json['is_need_update'],
    // Updated field name
    isForceUpdate: json['is_force_update'],
    // Updated field name
    isMaintenance: json['is_maintenance'],
    // Updated field name
    termsAndConditions: json['terms_and_condition'],
    // Updated field name in JSON response
    privacyPolicy: json['privacy_policy'],
    about: json['about'], // Updated field name in JSON response
  );

  // Convert object to JSON
  Map<String, dynamic> toJson() => {
    'is_need_update': isNeedUpdate,
    // Updated field name
    'is_force_update': isForceUpdate,
    // Updated field name
    'is_maintenance': isMaintenance,
    // Updated field name
    'terms_and_condition': termsAndConditions,
    // Updated field name in JSON response
    'privacy_policy': privacyPolicy,
    'about': about,
    // Updated field name in JSON response
  };
}
