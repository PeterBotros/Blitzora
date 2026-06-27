import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_remote_datasource.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource _remoteDataSource;
  ChatbotRepositoryImpl(this._remoteDataSource);

  @override
  Stream<String> sendMessage(String message) =>
      _remoteDataSource.sendMessage(message);
}
