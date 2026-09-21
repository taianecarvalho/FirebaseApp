import 'package:flutter_test/flutter_test.dart';

// chave é o nome da aluna e o valor a lista de notas
Map<String, List<double>> alunos = {
  'Maria': [8.0, 9.0],
  'Bruna': [7.0, 7.0],
  'Carla': [10.0, 9.0],
};

void main() {
  test('Adicionar elemento', () {
    // putIfAbsent só adiciona se a chave ainda não existe, recebe uma função
    alunos.putIfAbsent('Elena', () => [9.0, 8.0]);
    expect(alunos.containsKey('Elena'), isTrue);
    expect(alunos['Elena'], [9.0, 8.0]);
  });

  test('Adicionar outro dicionário', () {
    alunos.addAll({
      'Elena': [9.0, 8.0],
      'Luiza': [8.0, 9.0],
    });
    expect(alunos.containsKey('Elena'), isTrue);
    expect(alunos.containsKey('Luiza'), isTrue);
  });

  test('Remover elemento', () {
    alunos.remove('Bruna');
    expect(alunos.containsKey('Bruna'), isFalse);
  });

  test('Atualizar elemento', () {
    // update recebe o valor atual e devolve o novo, ou pode atribuir direto pela chave
    alunos.update('Carla', (value) => [9.0, 8.0]);
    expect(alunos['Carla'], [9.0, 8.0]);
    alunos['Carla'] = [8.0, 9.0];
    expect(alunos['Carla'], [8.0, 9.0]);
  });

  test('Testar percorrer dicionário', () {
    expect(alunos.keys, ['Maria', 'Carla', 'Elena', 'Luiza']);
    expect(alunos.values, [
      [8.0, 9.0],
      [8.0, 9.0],
      [9.0, 8.0],
      [8.0, 9.0],
    ]);
    // forEach passa chave e valor, o for de dentro soma as notas de cada uma
    double soma = 0;
    alunos.forEach((key, value) {
      for (double nota in value) {
        soma += nota;
      }
    });
    expect(soma, 68.0);
  });

  test('Calcular médias', () {
    Map<String, double> medias = {};
    // soma as notas de cada aluna e divide pela quantidade
    alunos.forEach((nome, notas) {
      medias[nome] = notas.reduce((a, b) => a + b) / notas.length;
    });
    expect(medias, {'Maria': 8.5, 'Carla': 8.5, 'Elena': 8.5, 'Luiza': 8.5});
  });
}
