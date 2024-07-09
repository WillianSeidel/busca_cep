import 'package:flutter/material.dart';
import 'package:your_app_buscacep/cep/cep_provider.dart';
import 'package:your_app_buscacep/models/cep_model.dart';
import 'package:provider/provider.dart';

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
          title: const Text('Search Cep'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (_cepProvider.state.value != null) {
                    final value = _cepProvider.state.value;
                    return _buildCardResultAddress(value);
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

  Widget _buildCardResultAddress(CepModel? value) {
    return Center(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
              "${value!.cep}\n${value.bairro}, ${value.logradouro} - ${value.uf}.\n${value.localidade} - ${value.ddd} ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
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
                return "Cep Inválido";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(label: Text("CEP")),
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
          )
        ],
      ),
    );
  }
}
