import 'package:flutter/material.dart';
import 'package:your_app_buscacep/cep/cep_provider.dart';
import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cepProvider = Provider.of<CepProvider>(context, listen: false);
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
                    final value = _cepProvider.state.value;
                    return Column(
                      children: [
                        _buildResultBox(value!),
                        ElevatedButton(
                          onPressed: () => _shareAddress(value),
                          child: const Text('Compartilhar Endereço'),
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
          Text(
            "${value.cep}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "${value.bairro}, ${value.logradouro} - ${value.uf}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            "${value.localidade} - ${value.ddd}",
            style: TextStyle(fontSize: 16),
          ),
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
