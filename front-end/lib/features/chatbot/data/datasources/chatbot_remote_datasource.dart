import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/storage_service.dart';

abstract class ChatbotRemoteDataSource {
  Stream<String> sendMessage(String message);
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final StorageService _storageService;
  ChatbotRemoteDataSourceImpl(this._storageService);

  @override
  Stream<String> sendMessage(String message) async* {
    final token = _storageService.getToken();
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatbot}');

    final request = http.Request('POST', url)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'text/plain';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.body = jsonEncode({'message': message});

    final client = http.Client();
    try {
      final streamed = await client.send(request);
      await for (final chunk in streamed.stream.transform(utf8.decoder)) {
        yield chunk;
      }
    } catch (e) {
      throw Exception('Chatbot streaming error: $e');
    } finally {
      client.close();
    }
  }
}
