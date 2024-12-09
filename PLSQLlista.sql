--procedure para excluir aluno
CREATE OR REPLACE PROCEDURE excluir_aluno(p_id_aluno NUMBER) AS
BEGIN
    -- deleta as matrículas do aluno
    DELETE FROM matricula WHERE id_aluno = p_id_aluno;

    -- deleta o aluno
    DELETE FROM aluno WHERE id_aluno = p_id_aluno;
END;

--cursor de listagem de alunos maiores de 18 anos
DECLARE
    CURSOR cur_alunos_maiores IS
        SELECT nome, data_nascimento
        FROM aluno
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
    
    v_nome aluno.nome%TYPE;
    v_data_nascimento aluno.data_nascimento%TYPE;
BEGIN
    OPEN cur_alunos_maiores;
    LOOP
        FETCH cur_alunos_maiores INTO v_nome, v_data_nascimento;
        EXIT WHEN cur_alunos_maiores%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome || ', Data de Nascimento: ' || v_data_nascimento);
    END LOOP;
    CLOSE cur_alunos_maiores;
END;


--cursor com filtro por curso 
DECLARE
    CURSOR cur_alunos_por_curso(p_id_curso NUMBER) IS
        SELECT DISTINCT a.nome
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        JOIN disciplina d ON m.id_disciplina = d.id_disciplina
        WHERE d.id_curso = p_id_curso;
    
    v_nome aluno.nome%TYPE;
BEGIN
    OPEN cur_alunos_por_curso(2);
    LOOP
        FETCH cur_alunos_por_curso INTO v_nome;
        EXIT WHEN cur_alunos_por_curso%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nome do Aluno: ' || v_nome);
    END LOOP;
    CLOSE cur_alunos_por_curso;
END;

--procedure de cadastro de disciplina 
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    -- Procedure para cadastrar uma nova disciplina
    PROCEDURE cadastrar_disciplina(
        p_nome VARCHAR2,
        p_descricao CLOB,
        p_carga_horaria NUMBER
    );
END PKG_DISCIPLINA;

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(
        p_nome VARCHAR2,
        p_descricao CLOB,
        p_carga_horaria NUMBER
    ) IS
    BEGIN
        INSERT INTO disciplina (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);
        
        DBMS_OUTPUT.PUT_LINE('Disciplina "' || p_nome || '" cadastrada com sucesso!');
    END cadastrar_disciplina;
END PKG_DISCIPLINA;

BEGIN
    PKG_DISCIPLINA.cadastrar_disciplina(
        p_nome => 'English for IT',
        p_descricao => 'Inglês direcionado para o mercado de tecnologia.',
        p_carga_horaria => 120
    );
END;

select * from disciplina;

--cursor para total de alunos por disciplina 
DECLARE
    CURSOR cur_total_alunos IS
        SELECT d.nome, COUNT(m.id_aluno) AS total_alunos
        FROM disciplina d
        JOIN matricula m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.id_disciplina, d.nome
        HAVING COUNT(m.id_aluno) > 10;
    
    v_nome disciplina.nome%TYPE;
    v_total_alunos NUMBER;
BEGIN
    OPEN cur_total_alunos;
    LOOP
        FETCH cur_total_alunos INTO v_nome, v_total_alunos;
        EXIT WHEN cur_total_alunos%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Disciplina: ' || v_nome || ', Total de Alunos: ' || v_total_alunos);
    END LOOP;
    CLOSE cur_total_alunos;
END;


--cursor com média de idade por disciplina 
DECLARE
    CURSOR cur_media_idade(p_id_disciplina NUMBER) IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;
    
    v_media_idade NUMBER;
BEGIN
    OPEN cur_media_idade(1); -- Substituir pelo ID da disciplina desejada
    FETCH cur_media_idade INTO v_media_idade;
    DBMS_OUTPUT.PUT_LINE('Média de Idade: ' || v_media_idade);
    CLOSE cur_media_idade;
END;


--listar alunos de uma disciplina 
CREATE OR REPLACE PROCEDURE listar_alunos_disciplina(p_id_disciplina NUMBER) AS
    CURSOR cur_alunos IS
        SELECT a.nome
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;
    
    v_nome aluno.nome%TYPE;
BEGIN
    OPEN cur_alunos;
    LOOP
        FETCH cur_alunos INTO v_nome;
        EXIT WHEN cur_alunos%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Nome do Aluno: ' || v_nome);
    END LOOP;
    CLOSE cur_alunos;
END;

--mostrar o total de turmas por professor 
DECLARE
    CURSOR cur_turmas_professor IS
        SELECT p.nome, COUNT(t.id_turma) AS total_turmas
        FROM professor p
        JOIN turma t ON p.id_professor = t.id_professor
        GROUP BY p.id_professor, p.nome
        HAVING COUNT(t.id_turma) > 1;
    
    v_nome professor.nome%TYPE;
    v_total_turmas NUMBER;
BEGIN
    OPEN cur_turmas_professor;
    LOOP
        FETCH cur_turmas_professor INTO v_nome, v_total_turmas;
        EXIT WHEN cur_turmas_professor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Professor: ' || v_nome || ', Total de Turmas: ' || v_total_turmas);
    END LOOP;
    CLOSE cur_turmas_professor;
END;

--mostrar o total de turmas de um professor 
CREATE OR REPLACE FUNCTION total_turmas_professor(p_id_professor NUMBER) RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM turma
    WHERE id_professor = p_id_professor;
    RETURN v_total;
END;

--professor de uma disciplina 
CREATE OR REPLACE FUNCTION professor_da_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2 IS
    v_nome_professor professor.nome%TYPE;
BEGIN
    SELECT p.nome INTO v_nome_professor
    FROM professor p
    JOIN turma t ON p.id_professor = t.id_professor
    WHERE t.id_disciplina = p_id_disciplina;
    RETURN v_nome_professor;
END;












