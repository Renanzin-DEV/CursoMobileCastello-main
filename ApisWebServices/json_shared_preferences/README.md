# json_shared_preferences

A new Flutter project.


Shared Prefrences (Armazenamento Interno do Aplicativo)

Aramzenamento   Chave -> Valor
                "config" -> "Texto" texto em formato Json

O que é um Texto em Formato Json -> 
[
    config:{
        "NomedoUsuario" : "nome do usuário",
        "IdadedoUsuaro" : 25,
        "TemaEscuro" : true,
    }
]

dart -> linguagem de programação do Flutter não lê JSON
     -> converter 
     => ( json.decode => converte texto:JSON em map:DART )
     => ( json.encode => converte map:DART em texto:JSON )


     flutter create json_path_provider --platforms=android --empt