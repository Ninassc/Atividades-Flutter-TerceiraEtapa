# MVVM, Provider e SQLite no Flutter

## 1. O que é MVVM?

MVVM é uma forma de organizar o código em três partes. O **Model** representa os dados, como uma classe `Pedido`. A **View** é a tela que o usuário vê e usa. A **ViewModel** recebe as ações da tela, trabalha com os dados e guarda as informações que precisam aparecer nela.

## 2. Qual é a função da Service?

A Service é a parte que acessa o banco de dados. Ela faz as operações de cadastrar, listar, editar e excluir no SQLite. A ViewModel chama os métodos da Service quando precisa dessas operações.

## 3. Por que não acessar o banco diretamente na View?

Porque a tela ficaria responsável por coisas demais. Além de mostrar os dados, ela também teria que cuidar do banco. Isso deixa o código mais confuso e dificulta fazer mudanças depois.

## 4. Para que serve o Provider?

O Provider permite que a View acesse a ViewModel e acompanhe as mudanças nos dados. Por exemplo, a tela pode chamar um método da ViewModel para cadastrar um pedido e depois mostrar a lista atualizada.

## 5. O que são `ChangeNotifier` e `notifyListeners()`?

`ChangeNotifier` permite que a ViewModel avise quando seus dados mudarem. O método `notifyListeners()` faz esse aviso para que os widgets que estão acompanhando a ViewModel possam atualizar a tela.

## 6. O que acontece se não chamar `notifyListeners()`?

Os dados podem até mudar dentro da ViewModel, mas a tela pode continuar mostrando os valores antigos, porque não recebeu o aviso para atualizar.

## 7. O que é SQLite?

SQLite é um banco de dados local. Ele salva os dados no próprio dispositivo, então o aplicativo pode acessar essas informações mesmo sem internet. Também não precisa de um servidor separado para funcionar.

## 8. Qual é a diferença entre guardar dados na RAM e no SQLite?

Os dados guardados apenas em variáveis ficam na memória enquanto o aplicativo está rodando. Quando ele fecha, esses dados podem ser perdidos. Os dados gravados no SQLite continuam salvos e podem ser carregados quando o aplicativo abrir de novo.

## 9. O que significa CRUD?

CRUD são as quatro operações básicas feitas com os dados:

- **Create:** criar um registro.
- **Read:** consultar um registro.
- **Update:** atualizar um registro.
- **Delete:** excluir um registro.

## 10. Para que servem `INSERT`, `SELECT`, `UPDATE` e `DELETE`?

- `INSERT` adiciona um registro no banco.
- `SELECT` consulta os registros.
- `UPDATE` altera um registro existente.
- `DELETE` exclui um registro.

## 11. Como funciona o cadastro de um registro?

O usuário preenche os dados na **View** e aperta o botão de cadastrar. A View chama a **ViewModel**, que pode validar os dados e chamar a **Service**. A Service usa o comando `INSERT` para salvar o registro no **SQLite**. Depois disso, a ViewModel atualiza os dados da lista e avisa a View para mostrar o novo registro.

## 12. Por que os dados podem sumir quando o aplicativo reinicia?

Uma possibilidade é que os registros tenham sido adicionados somente a uma lista na memória, sem serem salvos no SQLite. Ao abrir o aplicativo de novo, essa lista começa vazia.

## 13. Por que o banco foi atualizado, mas a tela ainda mostra o valor antigo?

Talvez a ViewModel não tenha carregado os dados novamente depois da alteração ou não tenha chamado `notifyListeners()`. Assim, a tela continua exibindo a lista antiga.

## 14 e 15. Qual é o problema nesse botão?

```dart
onPressed: () async {
  await BancoService().inserirPedido(
    nomeController.text,
  );
}
```

O botão está chamando a Service diretamente na View. No MVVM, a View deve chamar a ViewModel, e a ViewModel chama a Service. Por exemplo:

```dart
// Na View
onPressed: () async {
  await context.read<PedidoViewModel>().cadastrarPedido(
    nomeController.text,
  );
}
```

```dart
// Na ViewModel
Future<void> cadastrarPedido(String nome) async {
  await _service.inserirPedido(nome);
  await carregarPedidos();
}
```

Nesse exemplo, `carregarPedidos()` deve atualizar a lista da ViewModel e chamar `notifyListeners()` para atualizar a tela.

## 16. Quais são os benefícios de separar essas partes?

O código fica mais organizado e mais fácil de entender. Se for preciso mudar algo no banco, por exemplo, a alteração fica na Service. Também fica mais fácil testar cada parte e adicionar novas funções ao aplicativo sem misturar tudo na tela.
