import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../features/auth/model/forgot_password_models.dart';
import '../../features/auth/model/signin_request_model.dart';
import '../../features/auth/model/signup_request_model.dart';
import '../../features/auth/model/signup_response_model.dart';
import '../../features/auth/model/validation_models.dart';
import '../../features/check_version/model/check_version_model.dart';
import '../../features/check_version/model/check_version_req_model.dart';
import '../../features/pagination/model/user_model.dart';
import '../../features/people/model/people_model.dart';

part 'api_service.g.dart';

@RestApi(parser: Parser.FlutterCompute)
@i.lazySingleton
@i.injectable
abstract class ApiService {
  @i.factoryMethod
  factory ApiService(Dio dio, @Named('baseUrl') String baseUrl) => _ApiService(dio, baseUrl: baseUrl);

  @POST('/v1/app/appVersion/app_version_check')
  Future<CheckAppVersionModel> checkVersion(@Body() CheckVersionRequest request);

  @GET('/users')
  Future<PeopleListModel> getPeoples();

  @GET('/users')
  Future<UserListModel> getUsers(@Query('limit') int limit, @Query('skip') int skip);

  @POST('/v1/app/user/sign_up')
  Future<SignupResponseModel> signUp(@Body() SignupRequestModel request);

  // Social sign up (flexible body)
  @POST('/v1/app/user/sign_up')
  Future<SignupResponseModel> signUpSocial(@Body() Map<String, dynamic> body);

  // Email and Mobile validation
  @POST('/v1/app/user/check_email_address')
  Future<CheckEmailResponseModel> checkEmailAddress(@Body() CheckEmailRequest request);

  @POST('/v1/app/user/check_mobile_number')
  Future<CheckMobileResponseModel> checkMobileNumber(@Body() CheckMobileRequest request);

  @POST('/v1/app/user/sign_in')
  Future<SignupResponseModel> signIn(@Body() SignInRequestModel request);

  // Social sign in (flexible body)
  @POST('/v1/app/user/sign_in')
  Future<SignupResponseModel> signInSocial(@Body() Map<String, dynamic> body);

  // Forgot password
  @POST('/v1/app/user/send_otp_forgot_password')
  Future<SendOtpResponseModel> sendOtpForgot(@Body() SendOtpRequest request);

  @POST('/v1/app/user/verify_otp')
  Future<DefaultResponseModel> verifyOtp(@Body() VerifyOtpRequest request);

  @POST('/v1/app/user/reset_password')
  Future<DefaultResponseModel> resetPassword(@Body() ResetPasswordRequest request);

  // Change password
  @POST('/v1/app/user/change_password')
  Future<DefaultResponseModel> changePassword(@Body() ChangePasswordRequest request);

  // Logout
  @POST('/v1/app/user/logout')
  Future<LogoutResponseModel> logout(@Body() LogoutRequest request);

  // Upload media (profile image)
  @MultiPart()
  @POST('/v1/app/user/upload_media')
  Future<DefaultResponseModel> uploadMedia(
    @Header('Authorization') String authHeader,
    @Part(name: 'album_type') String albumType,
    @Part(name: 'album') MultipartFile album,
    @Part(name: 'ln') String ln,
  );

  // Fetch updated user data
  @POST('/v1/app/user/user_updated_data')
  Future<SignupResponseModel> fetchUpdatedUser(@Body() Map<String, dynamic> body);

  // Delete account
  @POST('/v1/app/user/delete_account')
  Future<DefaultResponseModel> deleteAccount(@Body() Map<String, dynamic> body);

  // Edit profile - flexible map to send only changed fields
  @POST('/v1/app/user/edit_profile')
  Future<SignupResponseModel> editProfile(@Body() Map<String, dynamic> body);

  // @POST("/user/add_support")
  // Future<DefaultResponseModel> addSupport(@Body() request);

  // @POST("http://192.168.29.59:4444/moderate-video")
  // Future checkVideoSensitive(
  //   @Part(name: "video_file_name") String file,
  // );

  // @POST("https://luuverr.com:1400/admin_api/v1/moderate/check_video")
  // Future checkVideoSensitive(@Part(name: "video_file_name") String file);

  // @POST("/template/create_template")
  // Future<DefaultResponseModel> createATemplate(
  //   @Part(name: "template_file") File file,
  //   @Part(name: "template_thumbnail") File thumbnail,
  //   @Part(name: "base_video_file") File baseFile,
  //   @Part(name: "template_hashtag_id") String hashTagID,
  //   @Part(name: "template_object") String templateObject,
  //   @Part(name: "ln") String ln,
}
