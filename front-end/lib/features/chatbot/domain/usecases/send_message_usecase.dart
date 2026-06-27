import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;
  SendMessageUseCase(this.repository);

  Stream<String> call(String message) => repository.sendMessage(message);
}
