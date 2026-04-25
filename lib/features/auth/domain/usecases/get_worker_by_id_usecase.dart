import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class GetWorkerByIdUsecase {
  final AuthRepository _repository;

  GetWorkerByIdUsecase({required AuthRepository repository})
    : _repository = repository;

  Future<Trabajador?> call({required String id}) async {
    final user = await _repository.getWorkerById(id: id);
    if (user == null) return null;
    if (user is Trabajador) return user;
    return null;
  }
}
