import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CepRepository {
  Future<CepModel> fetchCep(String cep) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json'));
      return CepModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
