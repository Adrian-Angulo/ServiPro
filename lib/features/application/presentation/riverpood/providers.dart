import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/application/data/repositories/application_repository_impl.dart';
import 'package:servi_pro/features/application/domain/usecases/add_application_usecase.dart';

final repoApplicationProvider = Provider((ref) {
  return ApplicationRepositoryImpl();
});

final addApliUsecaseProvider = Provider((ref) {
  return AddApplicationUsecase(repository: ref.read(repoApplicationProvider));
});
