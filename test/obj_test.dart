import 'package:flutter_test/flutter_test.dart';

// classe abstrata, não dá pra criar Pessoa direto, só Aluno ou Professor
abstract class Pessoa {
  late int _id;
  String nome;

  Pessoa(this.nome);

  int get id => _id;

  // set valida antes de gravar no atributo privado
  set id(int id) {
    if (id > 0) {
      _id = id;
    } else {
      throw ArgumentError('Identificador deve ser não negativo.');
    }
  }
}

// mixin reaproveita o ano em classes que não têm herança entre si
mixin Ano {
  late int _ano;

  int get ano => _ano;

  set ano(int ano) {
    if (ano > 0) {
      _ano = ano;
    } else {
      throw ArgumentError('Ano deve ser não negativo.');
    }
  }
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Professor extends Pessoa {
  Professor(super.nome);
}

class Disciplina {
  String nome;
  Disciplina(this.nome);
}

class Turma with Ano {
  Disciplina disciplina;
  Professor professor;
  final List<Aluno> _alunos = [];

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
  }

  void matricular(Aluno aluno) {
    if (aluno.ano == ano) {
      _alunos.add(aluno);
    } else {
      throw ArgumentError('Ano deve ser mesmo.');
    }
  }
}

class Historico extends Turma {
  Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  // sobrescreve a matrícula pra já criar a lista de notas do aluno
  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  double media(Aluno aluno) {
    List<double> notasAluno = notas[aluno]!;
    if (notasAluno.isEmpty) {
      return 0;
    }
    double media = 0;
    for (double nota in notasAluno) {
      media += nota;
    }
    media /= notasAluno.length;
    return media;
  }

  bool isAprovado(Aluno aluno) {
    return media(aluno) > 6;
  }
}

void main() {
  test('Testar matrícula de alunos', () {
    Disciplina disciplina1 = Disciplina('Flutter');
    Professor professor1 = Professor('Edilson');
    professor1.id = 1;
    Historico historico1 = Historico(disciplina1, professor1, 2023);
    expect(historico1.professor.nome, 'Edilson');
    // Cadastrar primeiro aluno sem erros
    Aluno aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;
    historico1.matricular(aluno1);
    expect(historico1.media(aluno1), 0.0);
    // Cadastrar segundo aluno com erros
    Aluno aluno2 = Aluno('Paula', 2022);
    try {
      aluno2.id = 0;
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
    try {
      historico1.matricular(aluno2);
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
  });

  test('Testar professor', () {
    Professor professor1 = Professor('Edilson');
    professor1.id = 2;
    expect(professor1.nome, 'Edilson');
    expect(professor1.id, 2);
    try {
      professor1.id = -1;
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
  });

  test('Testar aprovação', () {
    Disciplina disciplina1 = Disciplina('Flutter');
    Professor professor1 = Professor('Edilson');
    Historico historico1 = Historico(disciplina1, professor1, 2023);
    Aluno aluno1 = Aluno('Maria', 2023);
    Aluno aluno2 = Aluno('Paula', 2023);
    historico1.matricular(aluno1);
    historico1.matricular(aluno2);
    // média 8, aprovada
    historico1.notas[aluno1]!.addAll([7.0, 9.0]);
    expect(historico1.media(aluno1), 8.0);
    expect(historico1.isAprovado(aluno1), isTrue);
    // média 5, reprovada
    historico1.notas[aluno2]!.addAll([4.0, 6.0]);
    expect(historico1.media(aluno2), 5.0);
    expect(historico1.isAprovado(aluno2), isFalse);
  });
}
