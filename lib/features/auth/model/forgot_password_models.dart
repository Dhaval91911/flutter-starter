// ---------- RESPONSES ----------
SendOtpResponseModel deserializeSendOtpResponseModel(Map<String, dynamic> json) => SendOtpResponseModel.fromJson(json);
DefaultResponseModel deserializeDefaultResponseModel(Map<String, dynamic> json) => DefaultResponseModel.fromJson(json);

class SendOtpResponseModel {
  bool? success;
  int? statuscode;
  String? message;
  int? data;

  SendOtpResponseModel({this.success, this.statuscode, this.message, this.data});

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) => SendOtpResponseModel(
    success: json['success'],
    statuscode: json['statuscode'],
    message: json['message'],
    data: (json['data'] is int) ? json['data'] : int.tryParse('${json['data']}'),
  );

  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message, 'data': data};
}

class DefaultResponseModel {
  bool? success;
  int? statuscode;
  String? message;
  dynamic data;

  DefaultResponseModel({this.success, this.statuscode, this.message, this.data});

  factory DefaultResponseModel.fromJson(Map<String, dynamic> json) =>
      DefaultResponseModel(success: json['success'], statuscode: json['statuscode'], message: json['message'], data: json['data']);

  Map<String, dynamic> toJson() => {'success': success, 'statuscode': statuscode, 'message': message, 'data': data};
}

class SendOtpRequest {
  final String emailAddress;
  final String ln;
  const SendOtpRequest({required this.emailAddress, required this.ln});

  Map<String, dynamic> toJson() => {'email_address': emailAddress, 'ln': ln};
}

// top-level for retrofit compute
Map<String, dynamic> serializeSendOtpRequest(SendOtpRequest data) => data.toJson();

class VerifyOtpRequest {
  final int otp;
  final String emailAddress;
  final String ln;
  const VerifyOtpRequest({required this.otp, required this.emailAddress, required this.ln});

  Map<String, dynamic> toJson() => {'otp': otp, 'email_address': emailAddress, 'ln': ln};
}

Map<String, dynamic> serializeVerifyOtpRequest(VerifyOtpRequest data) => data.toJson();

class ResetPasswordRequest {
  final String emailAddress;
  final String newPassword;
  final String ln;
  const ResetPasswordRequest({required this.emailAddress, required this.newPassword, required this.ln});

  Map<String, dynamic> toJson() => {'email_address': emailAddress, 'new_password': newPassword, 'ln': ln};
}

Map<String, dynamic> serializeResetPasswordRequest(ResetPasswordRequest data) => data.toJson();

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String ln;
  const ChangePasswordRequest({required this.oldPassword, required this.newPassword, required this.ln});

  Map<String, dynamic> toJson() => {'old_password': oldPassword, 'new_password': newPassword, 'ln': ln};
}

Map<String, dynamic> serializeChangePasswordRequest(ChangePasswordRequest data) => data.toJson();
