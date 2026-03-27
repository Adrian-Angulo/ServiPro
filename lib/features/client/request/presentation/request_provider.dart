import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestFormState {
  final String? category;
  final String description;
  final String? zone;

  const RequestFormState({
    this.category,
    this.description = '',
    this.zone,
  });

  bool get isValid => category != null;

  RequestFormState copyWith({
    String? category,
    String? description,
    String? zone,
  }) {
    return RequestFormState(
      category: category ?? this.category,
      description: description ?? this.description,
      zone: zone ?? this.zone,
    );
  }
}

class RequestFormNotifier extends StateNotifier<RequestFormState> {
  RequestFormNotifier() : super(const RequestFormState());

  void selectCategory(String category) =>
      state = state.copyWith(category: category);

  void setDescription(String description) =>
      state = state.copyWith(description: description);

  void selectZone(String? zone) =>
      state = state.copyWith(zone: zone);
}

final requestFormProvider =
    StateNotifierProvider.autoDispose<RequestFormNotifier, RequestFormState>(
  (ref) => RequestFormNotifier(),
);
