CheckVersionRequest deserializeCheckVersionRequest(Map<String, dynamic> json) => CheckVersionRequest.fromJson(json);

Map<String, dynamic> serializeCheckVersionRequest(CheckVersionRequest data) => data.toJson();

class CheckVersionRequest {
  String? userId;
  String appVersion;
  String appPlatform;
  String? deviceToken;
  String selectedLanguage;

  CheckVersionRequest({this.userId, required this.appVersion, required this.appPlatform, required this.deviceToken, required this.selectedLanguage});

  factory CheckVersionRequest.fromJson(Map<String, dynamic> json) => CheckVersionRequest(
    userId: json['user_id'],
    appVersion: json['app_version'],
    appPlatform: json['app_platform'],
    deviceToken: json['device_token'],
    selectedLanguage: json['ln'],
  );

  Map<String, dynamic> toJson() => {
    if (userId != null) 'user_id': userId,
    'app_version': appVersion,
    'app_platform': appPlatform,
    if (deviceToken != null) 'device_token': deviceToken,
    'ln': selectedLanguage,
  };
}
