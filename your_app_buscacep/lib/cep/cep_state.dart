import 'package:your_app_buscacep/models/cep_model.dart';

class CepState {
  final CepModel? value;
  final bool isLoading;
  final bool isInitial;
  final bool hasError;

  CepState({
    this.value,
    this.isInitial = true,
    this.isLoading = false,
    this.hasError = false,
  });

  CepState copyWith({
    CepModel? value,
    bool? isLoading,
    bool? isInitial,
    bool? hasError,
  }) {
    return CepState(
      value: value ?? this.value,
      isLoading: isLoading ?? this.isLoading,
      isInitial: isInitial ?? this.isInitial,
      hasError: hasError ?? this.hasError,
    );
  }
}
