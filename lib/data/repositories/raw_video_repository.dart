import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nice_shot/core/error/exceptions.dart';
import 'package:nice_shot/core/error/failure.dart';
import 'package:nice_shot/data/model/api/data_model.dart';
import 'package:nice_shot/data/model/api/video_model.dart';
import 'package:nice_shot/data/network/end_points.dart';
import 'package:nice_shot/data/network/remote/dio_helper.dart';

typedef Generic = Either<Failure, Data<VideoModel>>;

abstract class RawVideosRepository {
  Future<Generic> uploadVideo({required VideoModel video});
}

class RawVideosRepositoryImpl extends RawVideosRepository {
  @override
  Future<Generic> uploadVideo({required VideoModel video}) async {
    try {
      var data = FormData.fromMap({
        "name": video.name,
        "user_id": video.userId,
        "category_id": video.categoryId,
        "file": await MultipartFile.fromFile(
          video.file!.path,
        ),
      });
      var result = await DioHelper.postData(
        url: Endpoints.editedVideos,
        data: data,
      );
      return Right(Data.fromJson(result.data));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
