import 'package:batalha_ideias/model/ideia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IdeiaService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final String colecao = 'ideia';

   Stream<List<Ideia>> listarIdeias() {
    return _firebase.collection(colecao).snapshots().map((snapshot) {
      return snapshot.docs.map((documento) {
        return Ideia.fromMap(
          documento.id,
          documento.data(),
        );
      }).toList();
    });
  }

  Future<void> adicionarIdeia(String titulo, String descricao, String autor, int votos) async {
    await _firebase.collection(colecao).add({
      'titulo' : titulo,
      'descricao': descricao,
      'autor': autor,
      'quantidade_votos': votos,
    });
  }

  Future<void> votarIdeia(Ideia ideia) async {
    await _firebase
        .collection((colecao))
        .doc(ideia.id)
        .update({'quantidade_votos': ideia.quantidadeVotos += 1});
  }

  Future<void> excluirIdeia(String id) async {
    await _firebase.collection((colecao)).doc(id).delete();
  }
}