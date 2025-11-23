import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/example_model.dart';

abstract class ExampleRemoteDataSource {
  Future<ExampleModel> getExample();
}

class ExampleRemoteDataSourceImpl implements ExampleRemoteDataSource {
  final Dio dio;

  ExampleRemoteDataSourceImpl({required this.dio});

  @override
  Future<ExampleModel> getExample() async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}/example');
      return ExampleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('Unknown error occurred');
    }
  }
}
