package Model;

public class Professor extends Pessoa {
    // atributos(encapsulamento)
    private double salario;

    // métodos
    // construtor
   
    public Professor(String nome, String cpf, double salario) {
        super(nome, cpf);
        this.salario = salario;
    }


        //getters and setters

public double getSalario() {
        return salario;
    }


public void setSalario(double salario) {
        this.salario = salario;
    }

}
