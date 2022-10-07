import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nice_shot/core/error/failure.dart';
import 'package:nice_shot/core/util/global_variables.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/data/model/api/data_model.dart';
import 'package:nice_shot/data/model/api/login_model.dart';
import 'package:nice_shot/data/network/end_points.dart';
import 'package:nice_shot/data/network/remote/dio_helper.dart';
import '../../core/error/exceptions.dart';
import 'package:http_parser/http_parser.dart';
typedef MyResponse = Either<Failure, Response>;

abstract class UserRepository {
  Future<MyResponse> createUser({required UserModel userModel});

  Future<Either<Failure, Response>> login({
    required String email,
    required String password,
  });

  Future<MyResponse> getUserData({required String id});

  Future<MyResponse> updateUserData({required UserModel userModel});

  Future<Either<Failure, Response>> resetPassword({
    required String oldPassword,
    required String newPassword,
  });
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<MyResponse> createUser({required UserModel userModel}) async {
    var data = FormData.fromMap({
      'name': userModel.name,
      'user_name': userModel.userName,
      'email': userModel.email,
      'mobile': userModel.mobile,
      'nationality': userModel.nationality,
      'birth_date': userModel.birthDate,
      'password': userModel.password,
      'file': await MultipartFile.fromFile(
        userModel.logo!.path,
        filename: "upload.jpg",
        contentType: MediaType("jpeg", "jpg"),
      ),
    });
    var response = await DioHelper.postData(
      url: Endpoints.user,
      data: data,
    );
    return _responseState(response: response);
  }

  @override
  Future<Either<Failure, Response>> login({
    required String email,
    required String password,
  }) async {
    var data = FormData.fromMap({
      'email': email,
      'password': password,
    });
    var response = await DioHelper.postData(
      url: Endpoints.login,
      data: data,
    );
    try {
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<MyResponse> getUserData({required String id}) async {
    var response = await DioHelper.getData(
      url: "${Endpoints.user}/$id",
    );
    try {
      return Right(response);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<MyResponse> updateUserData({required UserModel userModel}) async {
    var response = await DioHelper.putData(
      url: "${Endpoints.user}/$userId",
      data: {
        'name': userModel.name,
        'user_name': userModel.userName,
        'email': userModel.email,
        'mobile': userModel.mobile,
        'nationality': userModel.nationality,
        'birth_date': userModel.birthDate,
      },
    );
    try {
      return Right(response);
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: Endpoints.passwordReset,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      return Right(response);
    } on ServerException{
      return Left(ServerFailure());
    }
  }

  Future<MyResponse> _responseState({required var response}) async {
    try {
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
