1) Versão do device_preview estava acima da requerida no pubspec.yaml
2) subtitle no card da central_page estava com o texto fora do lugar
3) na rota para a DetalhePage() na central_page é preciso passar dentro da chamada da função a ocorrência o 

4) '!resolvido: (d['resolvido'] as bool? ?? false)' --> não pode ter o '!', pois é negação. Está em ocorrencia.dart
5) 'onChanged: (value) => setState(() => somenteAbertos = !value)' em central_page SwitchListTile está errado, não pode ter 0 '!'
6) 'await service.enviarPista(widget.ocorrencia.id, '');' em detalhe_page está errado, deveria ser await service.enviarPista(widget.ocorrencia.id, pista.text)