import 'dart:developer';
import 'package:financas_pessoais_flutter/modules/categoria/controllers/categoria_controller.dart';
import 'package:financas_pessoais_flutter/modules/categoria/models/categoria_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/models/conta_model.dart';
import 'package:financas_pessoais_flutter/modules/conta/repositiry/conta_repository.dart';
import 'package:financas_pessoais_flutter/utils/back_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContaController extends ChangeNotifier {
  List<Conta> contas = [];
  Categoria? categoriaSelecionada;
  bool? tipoSelecionado;
  bool? statusSelecionado;

  Future<List<Conta>?> findAll() async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository
          .getAll(BackRoutes.baseUrl + BackRoutes.CATEGORIA_ALL);
      if (response != null) {
        List<Conta> lista =
            response.map<Conta>((e) => Conta.fromMap(e)).toList();

        contas = lista;
        return contas;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> save(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.save(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_SAVE, conta);
      if (response != null) {
        Conta conta = Conta.fromMap(response as Map<String, dynamic>);
        contas.add(conta);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  create(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final categoriaController = TextEditingController();
    final tipoController = TextEditingController();
    final dataController = TextEditingController();
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();
    final destinoOrigemController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova Conta'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                items: Provider.of<CategoriaController>(context, listen: false)
                    .categorias
                    .map(
                      (e) => DropdownMenuItem<Categoria>(
                        child: Text(e.nome),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  categoriaSelecionada = value;
                },
              ),
              TextFormField(
                controller: dataController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descricaoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  var conta = Conta(
                    categoria: categoriaSelecionada,
                    tipo: tipoSelecionado,
                    data: dataController.text,
                    descricao: descricaoController.text,
                    valor: double.parse(valorController.text),
                    destinoOrigem: destinoOrigemController.text,
                    status: statusSelecionado,
                  );
                  await save(conta);
                  Navigator.of(context).pop();
                  notifyListeners();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Salvar'))
        ],
      ),
    );
  }

  edit(BuildContext context, Conta data) {
    final formKey = GlobalKey<FormState>();
    final dataController = TextEditingController(text: data.data);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Conta'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dataController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  data.data = dataController.text;
                  await update(data);
                  Navigator.of(context).pop();
                  notifyListeners();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Salvar'))
        ],
      ),
    );
  }

  delete(Conta data) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.delete(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_DELETE, data);
      if (response != null) {
        contas.remove(data);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(Conta conta) async {
    var contaRepository = ContaRepository();
    try {
      final response = await contaRepository.update(
          BackRoutes.baseUrl + BackRoutes.CATEGORIA_UPDATE, conta);
      if (response != null) {
        Conta contaEdit = Conta.fromMap(response as Map<String, dynamic>);
        contas.add(contaEdit);
        contas.remove(conta);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
