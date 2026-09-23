import 'package:central_missoes_firebase/models/missao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MissaoService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final String colecao = 'missao';

  Stream<List<Missao>> listarMissoes() {
    return _firebase.collection(colecao).snapshots().map((snapshot) {
      return snapshot.docs.map((documento) {
        return Missao.fromMap(
          documento.id,
          documento.data(),
        );
      }).toList();
    });
  }

  Future<void> adicionarMissao(String titulo, String dificuldade, int pontos) async {
    await _firebase.collection(colecao).add({
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': false
    });
  }

  Future<void> concluirMissao(Missao missao) async {
    await _firebase
        .collection((colecao))
        .doc(missao.id)
        .update({'concluida': !missao.concluida});
  }

  Future<void> excluirMissao(String id) async {
    await _firebase.collection((colecao)).doc(id).delete();
  }
}
