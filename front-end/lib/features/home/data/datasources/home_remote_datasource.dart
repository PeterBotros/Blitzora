import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/offer_model.dart';
import '../models/pharmacy_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<PharmacyModel>> getPharmacies();
  Future<List<OfferModel>> getFeaturedOffers();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;
  HomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.categories);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PharmacyModel>> getPharmacies() async {
    try {
      final response = await _apiClient
          .get(ApiConstants.pharmacies, queryParameters: {'limit': 5});
      final list = response.data as List<dynamic>;
      return list
          .map((e) => PharmacyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<OfferModel>> getFeaturedOffers() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: {'is_featured': true, 'limit': 5},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
