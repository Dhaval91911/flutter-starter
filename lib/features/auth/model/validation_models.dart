// ---------- REQUEST MODELS ----------
CheckEmailRequest deserializeCheckEmailRequest(Map<String, dynamic> json) => CheckEmailRequest.fromJson(json);
CheckMobileRequest deserializeCheckMobileRequest(Map<String, dynamic> json) => CheckMobileRequest.fromJson(json);

class CheckEmailRequest {
  final String emailAddress;
  final String ln;

  const CheckEmailRequest({required this.emailAddress, required this.ln});

  factory CheckEmailRequest.fromJson(Map<String, dynamic> json) => CheckEmailRequest(emailAddress: json['email_address'], ln: json['ln']);

  Map<String, dynamic> toJson() => {'email_address': emailAddress, 'ln': ln};
}

class CheckMobileRequest {
  final int mobileNumber;
  final String ln;

  const CheckMobileRequest({required this.mobileNumber, required this.ln});

  factory CheckMobileRequest.fromJson(Map<String, dynamic> json) => CheckMobileRequest(mobileNumber: json['mobile_number'], ln: json['ln']);

  Map<String, dynamic> toJson() => {'mobile_number': mobileNumber, 'ln': ln};
}

// ---------- RESPONSE MODELS ----------
CheckEmailResponseModel deserializeCheckEmailResponseModel(Map<String, dynamic> json) => CheckEmailResponseModel.fromJson(json);
CheckMobileResponseModel deserializeCheckMobileResponseModel(Map<String, dynamic> json) => CheckMobileResponseModel.fromJson(json);

class CheckEmailResponseModel {
  bool? success;
  int? statuscode;
  String? message;

  CheckEmailResponseModel({this.success, this.statuscode, this.message});

  factory CheckEmailResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckEmailResponseModel(success: json['success'], statuscode: json['statuscode'], message: json['message']);

  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message};
}

class CheckMobileResponseModel {
  bool? success;
  int? statuscode;
  String? message;

  CheckMobileResponseModel({this.success, this.statuscode, this.message});

  factory CheckMobileResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckMobileResponseModel(success: json['success'], statuscode: json['statuscode'], message: json['message']);

  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message};
}

// ---------- LOGOUT MODELS ----------
LogoutRequest deserializeLogoutRequest(Map<String, dynamic> json) => LogoutRequest.fromJson(json);
LogoutResponseModel deserializeLogoutResponseModel(Map<String, dynamic> json) => LogoutResponseModel.fromJson(json);

class LogoutRequest {
  final String deviceToken;
  final String ln;

  const LogoutRequest({required this.deviceToken, required this.ln});

  factory LogoutRequest.fromJson(Map<String, dynamic> json) => LogoutRequest(deviceToken: json['device_token'], ln: json['ln']);

  Map<String, dynamic> toJson() => {'device_token': deviceToken, 'ln': ln};
}

class LogoutResponseModel {
  bool? success;
  int? statuscode;
  String? message;

  LogoutResponseModel({this.success, this.statuscode, this.message});

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      LogoutResponseModel(success: json['success'], statuscode: json['statuscode'], message: json['message']);

  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message};
}

// ---------- SERIALIZATION FUNCTIONS ----------
Map<String, dynamic> serializeCheckEmailRequest(CheckEmailRequest data) => data.toJson();
Map<String, dynamic> serializeCheckMobileRequest(CheckMobileRequest data) => data.toJson();
Map<String, dynamic> serializeLogoutRequest(LogoutRequest data) => data.toJson();
