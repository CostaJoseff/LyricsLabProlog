:- use_module(library(csv)).
:-dynamic(musica/9).
:-initialization(carregaMusicas).


carregaMusicas :- 
    consult('musicas.pl'), consult('util.pl').

%Area CRUD

salvarMusicas :-
    open('musicas.pl', write, Stream),
    forall(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
           format(Stream, 'musica(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n', 
                  [Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao])),
    close(Stream).

adicionaMusica(Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    calculaId(Id),
    asserta(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)),
    salvarMusicas.
adicionaMusica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) :-
    asserta(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)),
    salvarMusicas.

calculaId(IdASerGerado) :-
    todasAsMusicas(Musicas),
    maiorId(Musicas, MaiorId),
    Resultado is MaiorId + 1,
    IdASerGerado = Resultado.

maiorId([], 1).
maiorId([musica(Id, _, _, _, _, _, _, _, _)], Id).
maiorId([musica(Id, _, _, _, _, _, _, _, _) | T], MaiorId) :-
    maiorId(T, MaiorResto),
    (Id > MaiorResto -> MaiorId = Id; MaiorId = MaiorResto).

selecionaMusica(Id, R) :-
 musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),R = musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao).


deletaMusica(Id):- 
 selecionaMusica(Id, Musica),
 retract(Musica),
 salvarMusicas.


atualizaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao):-
 deletaMusica(Id),
 adicionaMusica(Id, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, Banda, Avaliacao).


%Area filtros

musicasPorArtista(Artista, Resultado) :- % Retorna todas as musicas que tem o artista passado como participante dela.
    todasAsMusicas(Musicas),
    upperCase(Artista, ArtistaUper),
    recuperaMusicasComArtista(ArtistaUper, Musicas, Resultado).

recuperaMusicasComArtista(_, [], []).
recuperaMusicasComArtista(Artista, [musica(Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao) | T], [[Id,Nome,Instrumentos,Participantes,Ritmo,DataLancamento,Letra,NomeBanda,Avaliacao] | Resultado]) :-
    estaDentro(Participantes, Artista),
    recuperaMusicasComArtista(Artista, T, Resultado).
recuperaMusicasComArtista(Artista, [_|T], Resultado) :-
    recuperaMusicasComArtista(Artista, T, Resultado).


musicasPorBanda(Banda, Resultado) :- %Recupera Musicas que tem a mesma Banda.
    todasAsMusicas(Musicas),
    recuperaMusicasComBanda(Banda, Musicas, Resultado).


recuperaMusicasComBanda(_, [], []).
recuperaMusicasComBanda(Banda, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    ehDoMesmoJeito(Banda, NomeBanda),
    recuperaMusicasComBanda(Banda, T, Resultado).
recuperaMusicasComBanda(Banda, [_ | T], Resultado) :-
    recuperaMusicasComBanda(Banda, T, Resultado).



    

%Filtros de musica

filtroMusicasPorTrecho(Trecho, Resultado) :- %Filtra musicas que tem coincidencia da letra com o trecho
    todasAsMusicas(Musicas), 
    filtroMusicasPorTrecho2(Trecho, Musicas, Resultado).

filtroMusicasPorTrecho2(_, [], []).
filtroMusicasPorTrecho2(Trecho, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    temCoincidencia(Trecho  , Letra),
    filtroMusicasPorTrecho2(Trecho, T, Resultado).
filtroMusicasPorTrecho2(Trecho, [_| T], Resultado) :-
    filtroMusicasPorTrecho2(Trecho, T, Resultado).


filtroMusicasPorRitmo(Ritmo, Resultado) :- % Filtra musicas que tem o mesmo ritmo.
    todasAsMusicas(Musicas),
    filtroMusicasPorRitmo2(Ritmo, Musicas, Resultado).

filtroMusicasPorRitmo2(_, [], []).
filtroMusicasPorRitmo2(Ritmo2, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    ehDoMesmoJeito(Ritmo2, Ritmo),
    filtroMusicasPorRitmo2(Ritmo2, T, Resultado).
filtroMusicasPorRitmo2(Ritmo, [_ | T], Resultado):-
    filtroMusicasPorRitmo2(Ritmo, T, Resultado).




filtrarMusicasInstrumento(Instrumento, Resultado) :- % Filtra musicas que tem o mesmo instrumento.
    todasAsMusicas(Musicas),
    upperCase(Instrumento, Aumentado),
    filtrarMusicasInstrumento2(Aumentado, Musicas, Resultado).

filtrarMusicasInstrumento2(_, [], []).
filtrarMusicasInstrumento2(Instrumento,[musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    estaDentro(Instrumentos, Instrumento),
    filtrarMusicasInstrumento2(Instrumento, T, Resultado).
filtrarMusicasInstrumento2(Instrumento, [_ | T], Resultado):-
    filtrarMusicasInstrumento2(Instrumento, T, Resultado).


filtroMusicasPorNome(Nome, Resultado) :- % Filtra musicas que tem coincidencia nome.
    todasAsMusicas(Musicas),
    filtroMusicasPorNome2(Nome, Musicas, Resultado).

filtroMusicasPorNome2(_, [], []).
filtroMusicasPorNome2(Nome2, [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], [musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | Resultado]) :-
    temCoincidencia(Nome2, Nome),
    filtroMusicasPorNome2(Nome2, T, Resultado).
filtroMusicasPorNome2(Nome2, [_ | T], Resultado):-
    filtroMusicasPorNome2(Nome2, T, Resultado).


%TopMusicas para o dashBoard


maiorAvaliacao([musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)], musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)).
maiorAvaliacao([musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) | T], Resultado ) :-
    maiorAvaliacao(T, musica(Id2, Nome2, Instrumentos2, Participantes2, Ritmo2, DataLancamento2, Letra2, NomeBanda2, Avaliacao2)),
    (Avaliacao > Avaliacao2 -> Resultado = musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao) ;  Resultado = musica(Id2, Nome2, Instrumentos2, Participantes2, Ritmo2, DataLancamento2, Letra2, NomeBanda2, Avaliacao2)).




nMelhoresMusicas(N, Resultado) :-
    todasAsMusicas(Musicas),
    nMelhoresMusicas2(N, Musicas, Resultado).


nMelhoresMusicas2(0, _, []).
nMelhoresMusicas2(N, Musicas, [H1 | Resto]) :-
    maiorAvaliacao(Musicas, H1),
    NovoN is N - 1,
    removeDeUmaLista(H1, Musicas, NovaMusicas),
    nMelhoresMusicas2(NovoN, NovaMusicas, Resto).


%Micelaneas.

printarMusicas :-
    todasAsMusicas(Musicas),
    write(Musicas).


todasAsMusicas(Musicas) :- 
    findall(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao),
            Musicas).


%Funcoes Auxiliares.

temCoincidencia(String1, String2) :- %Verifica se a primeira string esta contida na segunda.
    upperCase(String1, String11),
    upperCase(String2, String22),
    atom_chars(String11, String1Formatada),
    atom_chars(String22, String2Formatada),
    temCoincidencia2(String1Formatada, String2Formatada, String1Formatada).

temCoincidencia2([], _, _). 

temCoincidencia2([_ | _], [_ | T2], Clone) :-
    temCoincidencia2(Clone, T2, Clone).

temCoincidencia2([H | T], [H | T2], Clone) :-
    temCoincidencia2(T, T2, Clone).


ehDoMesmoJeito(String1, String2) :-
    upperCase(String1, R1),
    upperCase(String2, R2),
    ehIgual(R1, R2).

ehIgual(String, String).


estaDentro([X], Y):- upperCase(X, UperX), UperX = Y.
estaDentro([X | _], Y):- upperCase(X, UperX), UperX = Y.
estaDentro([_ | T], Y):-
    estaDentro(T, Y).

ln :- write('\n').

exibirMusica(musica(Id, Nome, Instrumentos, Participantes, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao)) :- %Exibicao de musicas
    writeln("============================"),
    write("Id: "), write(Id),
    ln,
    write("Nome: "), write(Nome),
    ln,
    write("Instrumentos: "), write(Instrumentos),
    ln,
    write("Participantes: "), write(Participantes),
    ln,
    write("Ritmo: "), write(Ritmo),
    ln,
    write("Data de lancamento: "), write(DataLancamento),
    ln,
    write("Letra: "), write(Letra),
    ln,
    write("Nome da banda: "), write(NomeBanda),
    ln,
    write("Avaliacao: "), write(Avaliacao),
    ln,
    writeln("============================").


exibirMusicas([]). %Exibicao de varias musicas.
exibirMusicas([H | T]) :-
    exibirMusica(H),
    exibirMusicas(T).

    
removeDeUmaLista(_, [], []).
removeDeUmaLista(Elemento, [H | T], [H | Resultado]) :-
    Elemento \= H,
    removeDeUmaLista(Elemento, T, Resultado).
removeDeUmaLista(Elemento, [Elemento | T], Resultado) :-
    removeDeUmaLista(Elemento, T, Resultado).


%DashBoard


test :-
    nMelhoresMusicas(5, Resultado),
    printarGrafico(Resultado).

printarGrafico([]). 
printarGrafico([musica(Id, Nome, _, _, _, _, _, _, Avaliacao) | T]) :-

    write('___________________________________'),ln,
    printarNBarrasRetas(Avaliacao, Barras),
    tranformaEmUmaUnicaString(Id, Nome, String),
    format('~q ~q', [String, Barras]),ln,
    printarGrafico2(T).


printarGrafico2([]) :- write('___________________________________').
printarGrafico2([musica(Id, Nome, _, _, _, _, _, _, Avaliacao) | T]) :-
    printarNBarrasRetas(Avaliacao, Barras),
    tranformaEmUmaUnicaString(Id, Nome, String),
    format('~q ~q', [String, Barras]),ln,
    printarGrafico2(T).
    


%Funcoes Auxiliares

printarNBarrasRetas(N, Resultado) :-
    printarNBarrasRetas2(N, Barras),
    string_chars(Resultado, Barras).

printarNBarrasRetas2(0, []).
printarNBarrasRetas2(N, ['|' | T]) :-
    NovoN is N - 1,
    printarNBarrasRetas2(NovoN, T).


tranformaEmUmaUnicaString(String1, String2, Resultado) :-
    concat(String1, ' - ', String1form),
    concat(String1form, String2, TrabN),
    atom_chars(TrabN, Stringform),
    reduzString(Stringform, 15, Resposta),
    string_chars(Resultado,Resposta).



reduzString(_, 0, []).
reduzString([], N, [' ' | T]) :-
    NovoN is N - 1,
    reduzString([], NovoN, T).
reduzString([H | T1], N, [H | T2]) :-
    NovoN is N - 1,
    reduzString(T1, NovoN, T2).

%Sugerir Musica

sugerirMusica(Musica) :-
    todasAsMusicas(Musicas),
    length(Musicas, Tamanho),
    random(0, Tamanho, ValorRandomizado),
    nth0(ValorRandomizado, Musicas, Musica).

%Dados Gerais

dadosGeraisMusica :-
    todasAsMusicas(Musicas),
    length(Musicas, TantoDeMusicas),
    writeln('================================Quantidade de Musicas================================='),
    write(TantoDeMusicas), ln,
    writeln('======================================================================================'),
    totalInsMusic.

%Quantidade de musicas com os diversos instrumentos cadastrados
    
totalInsMusic :- 
    diferentesInstrumento(Instrumentos),
    qtdRegistradaDeInstrumentos(Instrumentos, Resultado),
    writeln('============Quantidade de musicas com os diversos instrumentos cadastrados============'),
    printarInsMusic(Instrumentos, Resultado),
    writeln('======================================================================================').

printarInsMusic([], []).
printarInsMusic([H1 | T1], [H2 | T2]) :-
    format('~q : ~q', [H1, H2]),ln,
    printarInsMusic(T1, T2).


qtdRegistradaDeInstrumentos([], []).
qtdRegistradaDeInstrumentos([Instrumento | T] , [HRs | TRs]) :-
    qtdResistradaIns(Instrumento, HRs),
    qtdRegistradaDeInstrumentos(T, TRs).



qtdResistradaIns(Instrumento, Resultado) :-
    todasAsMusicas(Musicas),
    qtdResistradaIns2(Instrumento, Musicas, Resultado).

qtdResistradaIns2(_, [], 0).
qtdResistradaIns2(Instrumento, [musica(_, _, Instrumentos, _, _, _, _, _, _) | T],
    Resultado) :-
        member(Instrumento, Instrumentos),
        qtdResistradaIns2(Instrumento, T, Resto),
        NovoResultado is Resto + 1,
        Resultado = NovoResultado.
qtdResistradaIns2(Instrumento, [musica(_, _, Instrumentos, _, _, _, _, _, _) | T],
    Resultado) :-
        not(member(Instrumento, Instrumentos)),
        qtdResistradaIns2(Instrumento, T, Resultado).
    



diferentesInstrumento(Diferentes):-
    todasAsMusicas(Musicas),
    igInstrumentos(Musicas, Iguais),
    removeDuplicatas(Iguais, Diferentes).

igInstrumentos([], []).
igInstrumentos([musica(_,_,Instrumentos,_,_,_,_,_,_) | T], Resultado) :-
    igInstrumentos(T, Resto),
    append(Instrumentos, Resto, Resultado).



removeDuplicatas( [] , []).
removeDuplicatas([Diff | T], [Diff | Resultado]):-
    not(temMais(Diff,T)),
    removeDuplicatas(T, Resultado).
removeDuplicatas([H1 | T1], Resultado) :-
    temMais(H1, T1),
    removeDuplicatas(T1, Resultado).


temMais(Instrumento, [Instrumento | _]).
temMais(Instrumento, [_ | T]) :-
    temMais(Instrumento, T).


