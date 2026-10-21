import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muralapp/models/comentario.dart';
import 'package:muralapp/services/comentario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaComentarios extends StatelessWidget {
  final String publicacaoId;

  const TelaComentarios({super.key, required this.publicacaoId});

  @override
  Widget build(BuildContext context) {
    final service = ComentarioService();
    final TextEditingController controllerComentario = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentários'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: controllerComentario,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Comentário:",
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final texto = controllerComentario.text.trim();
                  final usuarioAtual = FirebaseAuth.instance.currentUser;
                  final nomeUsuario = usuarioAtual?.displayName ??
                      usuarioAtual?.email?.split('@').first ??
                      'Usuário';
                  final novoComentario = Comentario(
                    id: '', // O Firestore criará o ID automaticamente
                    texto: texto,
                    nomeUsuario: nomeUsuario,
                    idPublicacao: publicacaoId,
                    criadoEm: DateTime.now(),
                  );
                  await service.adicionarComentario(
                      publicacaoId, novoComentario);

                  controllerComentario.clear();
                },
                child: Text("Comentar")),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                // Busca os comentários relacionados à publicação
                stream: service.acompanharComentarios(publicacaoId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comentarios = snapshot.data!.docs;

                  if (comentarios.isEmpty) {
                    return const Center(
                        child: Text('Nenhum comentário ainda.'));
                  }

                  return ListView.builder(
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      final dados = comentarios[index].data();
                      return ListTile(
                        leading: const CircleAvatar(
                            child: Icon(Icons.person, size: 18)),
                        title: Text(dados['nome_usuario'] ?? 'Anônimo'),
                        subtitle: Text(dados['texto'] ?? ''),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
