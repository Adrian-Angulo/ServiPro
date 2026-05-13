import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/reviews/data/datasources/review_firebase_datasource.dart';
import 'package:servi_pro/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/domain/repositories/review_repository.dart';
import 'package:servi_pro/features/reviews/domain/usecases/add_review_usecase.dart';
import 'package:servi_pro/features/reviews/domain/usecases/get_reviews_by_worker_usecase.dart';

final reviewDatasourceProvider = Provider((ref) {
  return ReviewFirebaseDatasource();
});

final repoReviewProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    ref.read(reviewDatasourceProvider),
    ref.read(authRepositoryProvider),
  );
});

final addReviewUsecaseProvider = Provider((ref) {
  return AddReviewUsecase(ref.read(repoReviewProvider));
});

final getReviewsByWorkerUsecaseProvider = Provider((ref) {
  return GetReviewsByWorkerUsecase(ref.read(repoReviewProvider));
});

final reviewsByWorkerProvider = FutureProvider.family<List<ReviewEntity>, String>((ref, workerId) async {
  final usecase = ref.read(getReviewsByWorkerUsecaseProvider);
  final result = await usecase(workerId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (reviews) => reviews,
  );
});

class AddReviewNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addReview(ReviewEntity review) async {
    state = const AsyncLoading();
    final usecase = ref.read(addReviewUsecaseProvider);
    final result = await usecase(review);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final addReviewNotifierProvider = AsyncNotifierProvider<AddReviewNotifier, void>(() {
  return AddReviewNotifier();
});

/// Invalida caches que muestran calificación o listas de trabajadores.
void invalidateWorkerRatingCaches(WidgetRef ref, String workerId) {
  ref.invalidate(reviewsByWorkerProvider(workerId));
  ref.invalidate(workerByIdProvider(workerId));
  ref.invalidate(allWorkersProvider);
  ref.invalidate(recommendedWorkersProvider);
}
