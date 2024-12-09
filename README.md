# plsql-lista
Trabalho realizado pelo João Victor Silva Lima:

PKG_ALUNO
o procedimento de exclusão de aluno remove o registro do aluno na tabela aluno com base no id_aluno e apaga todas as matrículas associadas a ele na tabela matricula. Há também uma funcionalidade que lista os nomes e as datas de nascimento de todos os alunos com mais de 18 anos. Além disso, um cursor permite filtrar e retornar os nomes dos alunos matriculados em um curso específico, utilizando o id_curso como critério.

PKG_DISCIPLINA
há um procedimento para cadastrar disciplinas, que insere na tabela disciplina os dados de nome, descrição e carga horária. Outro procedimento calcula o total de alunos matriculados em cada disciplina e exibe apenas aquelas com mais de 10 alunos. Existe também um cursor que calcula a média de idade dos alunos matriculados em uma disciplina específica, identificada pelo id_disciplina, e retorna o valor arredondado para o inteiro mais próximo. Por fim, há uma funcionalidade que lista os nomes dos alunos matriculados em uma disciplina, com base no id_disciplina.

PKG_PROFESSOR
procedimento que exibe os professores e o total de turmas que cada um leciona, incluindo apenas aqueles com mais de uma turma. Existe também uma funcionalidade para obter a quantidade de turmas lecionadas por um professor específico, utilizando o id_professor como referência. Por último, há um procedimento que retorna o nome do professor responsável por uma disciplina específica, identificado pelo id_disciplina.
