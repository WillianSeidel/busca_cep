import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:http/http.dart' as http;
import 'package:your_app_buscacep/utils/api_buscacep.dart';
import 'dart:convert';
import 'cep_repository_test.mocks.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('CepRepository', () {
    late CepRepository cepRepository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      cepRepository = CepRepository();
    });

    test('fetchCep retorna um CepModel se a chamada http for bem sucedida',
        () async {
      final mockResponse = {
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      };

      // Configurando o mock para retornar uma resposta bem sucedida
      when(mockClient.get(Uri.parse('https://viacep.com.br/ws/01001000/json')))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await cepRepository.fetchCep('01001000');

      // Verificando se o resultado é um CepModel esperado
      expect(result, isA<CepModel>());
      expect(result.cep, '01001-000');
      expect(result.logradouro, 'Praça da Sé');
      expect(result.localidade, 'São Paulo');
      expect(result.uf, 'SP');
    });

    test('fetchCep lança uma exceção se a chamada http falhar', () async {
      // Configurando o mock para retornar uma resposta com erro
      when(mockClient.get(Uri.parse('https://viacep.com.br/ws/01001000/json')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(cepRepository.fetchCep('01001000'), throwsException);
    });
  });
}
