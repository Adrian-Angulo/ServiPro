import 'package:servi_pro/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDatasource _datasource;

  OnboardingRepositoryImpl({OnboardingLocalDatasource? datasource})
    : _datasource = datasource ?? OnboardingLocalDatasource();

  @override
  Future<bool> isFirstLaunch() => _datasource.isFirstLaunch();

  @override
  Future<void> markOnboardingComplete() => _datasource.markOnboardingComplete();
}
