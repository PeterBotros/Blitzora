import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartItemModel> addItem(
      {required String productId, required int quantity});
  Future<CartItemModel> updateItem(
      {required String productId, required int quantity});
  Future<void> removeItem(String productId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient _apiClient;
  CartRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await _apiClient.get(ApiConstants.cart);
      return CartModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CartItemModel> addItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.cartAdd,
        data: {'product_id': productId, 'quantity': quantity},
      );
      return CartItemModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CartItemModel> updateItem({
    required String productId, // backend uses product_id in the path
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.put(
        '/cart/item/$productId',
        data: {'quantity': quantity},
      );
      return CartItemModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeItem(String productId) async {
    try {
      await _apiClient.delete('/cart/item/$productId');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
