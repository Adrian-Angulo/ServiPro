import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class GetRequestByIdUsecase {
  final RequestRepository repository;

  GetRequestByIdUsecase({required this.repository});

  Future<Either<Failure, RequestEntity>> call(String id) async {
    return repository.getRequestById(id);
  }
}
