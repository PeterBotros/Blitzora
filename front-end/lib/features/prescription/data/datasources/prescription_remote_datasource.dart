import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<PrescriptionModel> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    required String diagnosisDate,
    String? notes,
  });
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final ApiClient apiClient;

  PrescriptionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PrescriptionModel> uploadPrescription({
    required String patientName,
    required String address,
    required String filePath,
    required String diagnosisDate,
    String? notes,
  }) async {
    try {
      final String filename = filePath.split('/').last;
      
      // MultipartFile.fromFile is used for uploading local files in Dio
      final file = await MultipartFile.fromFile(
        filePath,
        filename: filename,
      );

      final formData = FormData.fromMap({
        'patient_name': patientName,
        'address': address,
        'diagnosis_date': diagnosisDate,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes,
        'file': file,
      });

      final response = await apiClient.rawDio.post(
        ApiConstants.prescriptions,
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PrescriptionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to upload prescription: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final detail = e.response?.data;
      String message;
      if (detail is Map) {
        message = detail['detail']?.toString() ?? e.message ?? 'Unknown server error';
      } else if (detail is String) {
        message = detail;
      } else {
        message = e.message ?? 'Unknown server error';
      }
      throw ServerException(message: message, statusCode: statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
