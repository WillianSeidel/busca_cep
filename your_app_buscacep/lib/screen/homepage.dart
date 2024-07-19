import 'package:flutter/material.dart';
import 'package:your_app_buscacep/cep/cep_provider.dart';
import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GlobalKey<FormState> _formKey;
  late final CepProvider _cepProvider;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _loadSavedAddress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cepProvider = Provider.of<CepProvider>(context, listen: false);
  }

  Future<void> _loadSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCep = prefs.getString('cep');
    if (savedCep != null) {
      _cepProvider.getAddress(savedCep);
    }
  }

  Future<void> _saveAddress(CepModel value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cep', value.cep!);
    await prefs.setString('bairro', value.bairro!);
    await prefs.setString('logradouro', value.logradouro!);
    await prefs.setString('uf', value.uf!);
    await prefs.setString('localidade', value.localidade!);
    await prefs.setString('ddd', value.ddd!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Endereço salvo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 102, 148, 235),
          centerTitle: true,
          title: const Text('Busca CEP'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              _buildFormCep(),
              AnimatedBuilder(
                animation: _cepProvider,
                builder: (context, _) {
                  if (_cepProvider.state.isInitial) {
                    return const Text('');
                  } else if (_cepProvider.state.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 45),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (_cepProvider.state.value != null) {
                    final value = _cepProvider.state.value!;
                    return Column(
                      children: [
                        _buildResultBox(value),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _saveAddress(value),
                              child: const Text('Salvar Endereço'),
                            ),
                            SizedBox(width: 3),
                            ElevatedButton(
                              onPressed: () => _shareAddress(value),
                              child: const Text('Compartilhar End'),
                            )
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBox(CepModel value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultRow('CEP', value.cep),
          _buildResultRow('Logradouro', value.logradouro),
          _buildResultRow('Complemento', value.complemento),
          _buildResultRow('Bairro', value.bairro),
          _buildResultRow('Localidade', value.localidade),
          _buildResultRow('UF', value.uf),
          _buildResultRow('DDD', value.ddd),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
              child: Text(
            value ?? '',
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // Limite de linhas para o texto
          ))
        ],
      ),
    );
  }

  Widget _buildFormCep() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              _cepProvider.getAddress(value!);
            },
            validator: (value) {
              if (value!.length != 8) {
                return "CEP Inválido";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(label: Text("Digite o CEP:")),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
            },
            child: const Text('Consultar'),
          ),
        ],
      ),
    );
  }

  void _shareAddress(CepModel value) {
    final address = '''
CEP: ${value.cep}
Logradouro: ${value.logradouro}
Complemento: ${value.complemento}
Bairro: ${value.bairro}
Localidade: ${value.localidade}
UF: ${value.uf}
DDD: ${value.ddd}
''';
    Share.share(address);
  }
}
