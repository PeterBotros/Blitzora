import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    int skip = 0,
    int limit = 20,
  });
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;
  ProductRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{'skip': skip, 'limit': limit};
      if (categoryId != null) params['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) params['search'] = search;
      final response = await _apiClient.get(ApiConstants.products, queryParameters: params);
      final list = response.data as List<dynamic>;
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on ServerException { rethrow; }
    catch (e) { throw ServerException(message: e.toString()); }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.products}/$id');
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException { rethrow; }
    catch (e) { throw ServerException(message: e.toString()); }
  }
}
