SignupRequestModel deserializeSignupRequestModel(Map<String, dynamic> json) => SignupRequestModel.fromJson(json);

Map<String, dynamic> serializeSignupRequestModel(SignupRequestModel data) => data.toJson();

class SignupRequestModel {
  final String fullName;
  final String emailAddress;
  final String countryCode;
  final String countryStringCode;
  final int mobileNumber;
  final bool isSocialLogin;
  final String? socialId;
  final String? socialPlatform;
  final String password;
  final String deviceToken;
  final String deviceType;
  final String location;
  final String address;
  final String ln;

  const SignupRequestModel({
    required this.fullName,
    required this.emailAddress,
    required this.countryCode,
    required this.countryStringCode,
    required this.mobileNumber,
    required this.isSocialLogin,
    this.socialId,
    this.socialPlatform,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    required this.location,
    required this.address,
    required this.ln,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) => SignupRequestModel(
    fullName: json['full_name'],
    emailAddress: json['email_address'],
    countryCode: json['country_code'],
    countryStringCode: json['country_string_code'],
    mobileNumber: json['mobile_number'],
    isSocialLogin: json['is_social_login'],
    socialId: json['social_id'],
    socialPlatform: json['social_platform'],
    password: json['password'],
    deviceToken: json['device_token'],
    deviceType: json['device_type'],
    location: json['location'],
    address: json['address'],
    ln: json['ln'],
  );

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email_address': emailAddress,
    'country_code': countryCode,
    'country_string_code': countryStringCode,
    'mobile_number': mobileNumber,
    'is_social_login': isSocialLogin,
    if (socialId != null) 'social_id': socialId,
    if (socialPlatform != null) 'social_platform': socialPlatform,
    'password': password,
    'device_token': deviceToken,
    'device_type': deviceType,
    'location': location,
    'address': address,
    'ln': ln,
  };

  SignupRequestModel copyWith({
    String? fullName,
    String? emailAddress,
    String? countryCode,
    String? countryStringCode,
    int? mobileNumber,
    bool? isSocialLogin,
    String? socialId,
    String? socialPlatform,
    String? password,
    String? deviceToken,
    String? deviceType,
    String? location,
    String? address,
    String? ln,
  }) {
    return SignupRequestModel(
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      countryCode: countryCode ?? this.countryCode,
      countryStringCode: countryStringCode ?? this.countryStringCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isSocialLogin: isSocialLogin ?? this.isSocialLogin,
      socialId: socialId ?? this.socialId,
      socialPlatform: socialPlatform ?? this.socialPlatform,
      password: password ?? this.password,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceType: deviceType ?? this.deviceType,
      location: location ?? this.location,
      address: address ?? this.address,
      ln: ln ?? this.ln,
    );
  }
}
