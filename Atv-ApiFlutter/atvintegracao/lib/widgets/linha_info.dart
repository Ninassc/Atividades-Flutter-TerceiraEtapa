import 'package:flutter/material.dart';

class LinhaInfo extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final dynamic valor; 
  const LinhaInfo({super.key, required this.icone, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(
            icone,
            size: 28,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 13,
                   color: const Color.fromARGB(255, 243, 238, 238),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  valor?.toString() ?? "Não informado",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}