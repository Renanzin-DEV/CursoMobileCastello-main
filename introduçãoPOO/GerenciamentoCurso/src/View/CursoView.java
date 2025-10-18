package View;

import java.util.Scanner;

import Controller.CursoController;
import Model.Aluno;
import Model.Professor;

public class CursoView {
    // atributos

    Professor jp = new Professor("João Pereira", "123.456.789-09", 15000.00);
    CursoController cursoJava = new CursoController("Programação", jp);
    Scanner sc = new Scanner(System.in);
    private int operacao;
    private boolean continuar = true;

    // métodos
    public void menu() {
        while (continuar) {

            System.out.println("==Gerenciamento do Curso");
            System.out.println("|1. Cadastrar Aluno");
            System.out.println("|2. Informações do Curso");
            System.out.println("|3. Lançar notas dos Alunos");
            System.out.println("|4. Status da turma");
            System.out.println("|5. Sair");
            System.out.println("==Escolha a Opção desejada==");
            operacao = sc.nextInt();
            switch (operacao) {
                case 1:
                    Aluno aluno = cadastrarAluno();
                    cursoJava.adicionarAluno(aluno);
                    break;

                case 2:
                    cursoJava.exibirInformacoesCurso();
                    break;

                case 3:
                    break;

                case 4:
                    break;

                case 5:
                    System.out.println("Saindo...");
                    continuar = false;
                    break;

                default:
                    break;
            }
        }
    }

    private Aluno cadastrarAluno() {
        System.out.println("Digite o nome do Aluno");
        String nome = sc.next();
        System.out.println("Informe o CPF do aluno");
        String cpf = sc.next();
        System.out.println("Informe a matricula do aluno");
        String matricula = sc.next();
        return new Aluno(nome, cpf, matricula);

    }

}
