import 'package:flutter/material.dart';
import 'package:your_app_buscacep/cep/cep_state.dart';
import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:your_app_buscacep/utils/api_buscacep.dart';

class CepProvider extends ChangeNotifier {
  CepRepository cepRepository = CepRepository();
  CepModel? address;
  bool loading = true;

  CepState state = CepState();

  Future<void> getAddress(String cep) async {
    state = state.copyWith(
      isLoading: true,
      isInitial: false,
    );
    notifyListeners();
    try {
      final address = await cepRepository.fetchCep(cep);
      state = state.copyWith(
        isLoading: false,
        isInitial: false,
        value: address,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isInitial: false,
        hasError: true,
      );
    } finally {
      notifyListeners();
    }
  }
}
