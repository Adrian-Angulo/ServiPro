import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class DeletedRequestUseCase {
  final RequestRepository repository;

  DeletedRequestUseCase({required this.repository});
  Future<void> call(String requestId) async {
    
    try {
      await repository.deleteRequest(requestId);
      
    } catch (e) {
      throw Exception("error al cancelar solicitud: $e");
    }
    
  }
}
