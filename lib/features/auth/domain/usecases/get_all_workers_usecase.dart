import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class GetAllWorkersUsecase {
  final AuthRepository _repository;

  GetAllWorkersUsecase({required AuthRepository repository})
    : _repository = repository;

  Future<List<Trabajador>> call() async {
    final users = await _repository.getAllWorkers();
    return users.whereType<Trabajador>().toList();
  }
}
