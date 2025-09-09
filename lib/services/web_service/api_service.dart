import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../features/auth/model/signup_request_model.dart';
import '../../features/auth/model/signup_response_model.dart';
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
