import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<ProductModel>> getFavorites();
  Future<ProductModel> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiClient _apiClient;
  FavoriteRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ProductModel>> getFavorites() async {
    try {
      final response = await _apiClient.get('/favorites/');
      final list = response.data as List<dynamic>;
      final products = list
          .map((e) => e['product'] != null
              ? ProductModel.fromJson(e['product'] as Map<String, dynamic>)
              : null)
          .whereType<ProductModel>()
          .toList();
      return products;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> addFavorite(String productId) async {
    try {
      final response = await _apiClient.post('/favorites/$productId');
      final productJson = response.data['product'] as Map<String, dynamic>;
      return ProductModel.fromJson(productJson);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeFavorite(String productId) async {
    try {
      await _apiClient.delete('/favorites/$productId');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
