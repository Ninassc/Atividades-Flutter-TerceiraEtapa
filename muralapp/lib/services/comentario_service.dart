import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muralapp/models/comentario.dart';

class ComentarioService {
  Future<void> adicionarComentario(
      String idPublicacao, Comentario comentario) async {
    await FirebaseFirestore.instance
        .collection('publicacoes')
        .doc(idPublicacao)
        .collection('comentarios')
        .add(comentario.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> acompanharComentarios(
      String idPublicacao) {
    return FirebaseFirestore.instance
        .collection('publicacoes')
        .doc(idPublicacao)
        .collection('comentarios')
        .orderBy('criado_em', descending: false)
        .snapshots();
  }
}
