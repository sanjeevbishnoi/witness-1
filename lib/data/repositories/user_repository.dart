import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nice_shot/core/error/failure.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/data/model/api/data_model.dart';
import 'package:nice_shot/data/model/api/login_model.dart';
import 'package:nice_shot/data/network/end_points.dart';
import 'package:nice_shot/data/network/remote/dio_helper.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/error/exceptions.dart';

typedef Response = Either<Failure, Data<UserModel>>;

abstract class UserRepository {
  Future<Response> createUser({required UserModel userModel});

  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  });

  Future<Response> getUserData({required String id});
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<Response> createUser({required UserModel userModel}) async {
    var data = FormData.fromMap({
      'name': userModel.name,
      'user_name': userModel.userName,
      'email': userModel.email,
      'mobile': userModel.mobile,
      'nationality': userModel.nationality,
      'birth_date': userModel.birthDate,
      'password': userModel.password,
      'logo': await MultipartFile.fromFile(
        userModel.logo!.path,
      ),
    });
    var result = await DioHelper.postData(
      url: Endpoints.createAccount,
      data: data,
    );
    return _mapToEither(result: result);
  }

  @override
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    var data = FormData.fromMap({
      'email': email,
      'password': password,
    });
    try {
      var result = await DioHelper.postData(
        url: Endpoints.login,
        data: data,
      );
      return Right(LoginModel.fromJson(result.data));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Response> getUserData({required String id}) async {
    var result = await DioHelper.getData(
      url: "${Endpoints.createAccount}/$id",
    );
    return _mapToEither(result: result);
  }

  Future<Response> _mapToEither({required var result}) async {
    try {
      return Right(Data<UserModel>.fromJson(result.data));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
