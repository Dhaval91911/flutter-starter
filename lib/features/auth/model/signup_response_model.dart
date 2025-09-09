SignupResponseModel deserializeSignupResponseModel(Map<String, dynamic> json) => SignupResponseModel.fromJson(json);

Map<String, dynamic> serializeSignupResponseModel(SignupResponseModel data) => data.toJson();

class SignupResponseModel {
  bool? success;
  int? statuscode;
  String? message;
  UserData? data;

  SignupResponseModel({this.success, this.statuscode, this.message, this.data});

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['statuscode'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statuscode'] = statuscode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? userType;
  String? fullName;
  String? emailAddress;
  String? mobileNumber;
  String? countryCode;
  String? countryStringCode;
  String? password;
  bool? isSocialLogin;
  String? socialId;
  String? socialPlatform;
  int? notificationBadge;
  Location? location;
  String? address;
  String? customerId;
  bool? isUserVerified;
  bool? isBlockedByAdmin;
  bool? isDeleted;
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? deviceToken;
  String? deviceType;
  String? userProfile;

  UserData({
    this.userType,
    this.fullName,
    this.emailAddress,
    this.mobileNumber,
    this.countryCode,
    this.countryStringCode,
    this.password,
    this.isSocialLogin,
    this.socialId,
    this.socialPlatform,
    this.notificationBadge,
    this.location,
    this.address,
    this.customerId,
    this.isUserVerified,
    this.isBlockedByAdmin,
    this.isDeleted,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.deviceToken,
    this.deviceType,
    this.userProfile,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    userType = json['user_type'];
    fullName = json['full_name'];
    emailAddress = json['email_address'];
    mobileNumber = json['mobile_number']?.toString();
    countryCode = json['country_code'];
    countryStringCode = json['country_string_code'];
    password = json['password'];
    isSocialLogin = json['is_social_login'];
    socialId = json['social_id'];
    socialPlatform = json['social_platform'];
    notificationBadge = json['notification_badge'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    address = json['address'];
    customerId = json['customer_id'];
    isUserVerified = json['is_user_verified'];
    isBlockedByAdmin = json['is_blocked_by_admin'];
    isDeleted = json['is_deleted'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    token = json['token'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    userProfile = json['user_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_type'] = userType;
    data['full_name'] = fullName;
    data['email_address'] = emailAddress;
    data['mobile_number'] = mobileNumber;
    data['country_code'] = countryCode;
    data['country_string_code'] = countryStringCode;
    data['password'] = password;
    data['is_social_login'] = isSocialLogin;
    data['social_id'] = socialId;
    data['social_platform'] = socialPlatform;
    data['notification_badge'] = notificationBadge;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['address'] = address;
    data['customer_id'] = customerId;
    data['is_user_verified'] = isUserVerified;
    data['is_blocked_by_admin'] = isBlockedByAdmin;
    data['is_deleted'] = isDeleted;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['token'] = token;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['user_profile'] = userProfile;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
