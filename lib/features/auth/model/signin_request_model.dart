SignInRequestModel deserializeSignInRequestModel(Map<String, dynamic> json) => SignInRequestModel.fromJson(json);

Map<String, dynamic> serializeSignInRequestModel(SignInRequestModel data) => data.toJson();

class SignInRequestModel {
  final String emailAddress;
  final String password;
  final String deviceToken;
  final String deviceType;
  final String ln;

  const SignInRequestModel({
    required this.emailAddress,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    required this.ln,
  });

  factory SignInRequestModel.fromJson(Map<String, dynamic> json) => SignInRequestModel(
    emailAddress: json['email_address'],
    password: json['password'],
    deviceToken: json['device_token'],
    deviceType: json['device_type'],
    ln: json['ln'],
  );

  Map<String, dynamic> toJson() => {
    'email_address': emailAddress,
    'password': password,
    'device_token': deviceToken,
    'device_type': deviceType,
    'ln': ln,
  };
}
