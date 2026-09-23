import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tarefa.dart';

class TarefaService {
  //Acessa o firebase Firestore
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final String colecao = 'tarefas';

  
  Stream<List<Tarefa>> listarTarefas() {
    return _firebase.collection(colecao).snapshots().map((snapshot) {
      return snapshot.docs.map((documento) {
        return Tarefa.fromMap(
          documento.id,
          documento.data(), //
        );
      }).toList();
    });
  }

  Future<void> adicionarTarefa(String titulo) async {
    await _firebase.collection(colecao).add({
      'titulo': titulo,
      'concluida': false,
    });
  }

  Future<void> alterarStatus(Tarefa tarefa) async {
    await _firebase.collection(colecao).doc(tarefa.id).update({
      'concluida': !tarefa.concluida,
    });
  }

  Future<void> excluirTarefa(String id) async {
    await _firebase.collection(colecao).doc(id).delete();
  }
}
