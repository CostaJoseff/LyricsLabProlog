:- use_module(library(csv)).
:-dynamic(banda/9).
:-initialization(carregaBandas).


carregaBandas :- 
    consult('bandas.pl'), consult('util.pl').

%Area CRUD

salvarBandas :-
    open('bandas.pl', write, Stream),
    forall(banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao),
           format(Stream, 'banda(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n', 
                  [Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao])),
    close(Stream).

adicionaBanda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) :-
    calculaId(Id),
    asserta(banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao)),
    salvarBandas.
adicionaBanda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) :-
    asserta(banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao)),
    salvarBandas.

calculaId(IdASerGerado) :-
    todasAsBandas(Bandas),
    maiorId(Musicas, MaiorId),
    Resultado is MaiorId + 1,
    IdASerGerado = Resultado.

maiorId([], 1).
maiorId([banda(Id, _, _, _, _, _, _, _, _)], Id).
maiorId([banda(Id, _, _, _, _, _, _, _, _) | T], MaiorId) :-
    maiorId(T, MaiorResto),
    (Id > MaiorResto -> MaiorId = Id; MaiorId = MaiorResto).

selecionabanda(Id, R) :-
 banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao),R = banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao).


deletabanda(Id):- 
 selecionabanda(Id, Banda),
 retract(Banda),
 salvarBandas.


atualizabandas(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao):-
 deletabanda(Id),
 adicionaBanda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao).


%Area filtros

bandasPorArtista(Artista, Resultado) :- 
    todasAsBandas(bandas),
    upperCase(Artista, ArtistaUper),
    recuperaBandaComArtista(ArtistaUper, bandas, Resultado).

recuperaBandaComArtista(_, [], []).
recuperaBandaComArtista(Artista, [banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) | T], [[Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao] | Resultado]) :-
    estaDentro(MembrosAtuais, Artista),
    recuperaBandaComArtista(Artista, T, Resultado).
recuperaBandaComArtista(Artista, [_|T], Resultado) :-
    recuperaBandaComArtista(Artista, T, Resultado).



bandasPorArtistaantigo(Artistaantigo, Resultado) :- % Retorna todas as bandas que tem o artista como ex participante dela.
    todasAsBandas(bandas),
    upperCase(Artista, ArtistaUper),
    recuperaBandaComantigoArtista(ArtistaUper, bandas, Resultado).

recuperaBandaComantigoArtista(_, [], []).
recuperaBandaComantigoArtista(Artista, [banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) | T], [[Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao] | Resultado]) :-
    estaDentro(MembrosAntigos, Artista),
    recuperaBandaComantigoArtista(Artista, T, Resultado).
recuperaBandaComantigoArtista(Artista, [_|T], Resultado) :-
    recuperaBandaComantigoArtista(Artista, T, Resultado).




bandasPorInstrumento(instrumento, Resultado) :- % Retorna todas as bandas que tem o instrumento no repertorio.
    todasAsBandas(bandas),
    upperCase(Intrumento, IntrumentoUper),
    recuperaBandaComIntrumento(IntrumentoUper, bandas, Resultado).

recuperaBandaComIntrumento(_, [], []).
recuperaBandaComIntrumento(Intrumento, [banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) | T], [[Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao] | Resultado]) :-
    estaDentro(Instrumentos, instrumento),
    recuperaBandaComIntrumento(Intrumento, T, Resultado).
recuperaBandaComIntrumento(Intrumento, [_|T], Resultado) :-
    recuperaBandaComIntrumento(Intrumento, T, Resultado).


filtroBandasPorGenero(Genero, Resultado) :- 
    todasAsBandas(Bandas),
    acharBandasGenero(Genero2, Bandas, Resultado).

acharBandasGenero(_, [], []).
acharBandasGenero(Genero, [banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao) | T], [[Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao] | Resultado]) :-
    ehDoMesmoJeito(Genero2, Genero),
    acharBandasGenero(Genero2, T, Resultado).
acharBandasGenero(Genero, [_ | T], Resultado):-
    acharBandasGenero(Genero, T, Resultado).

%Micelaneas.

printarBandas :-
    todasAsBandas(Bandas),
    write(Bandas).


todasAsBandas(Bandas) :- 
    findall(banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao),
            banda(Id, Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, Avaliacao),
            Bandas).
buscarBandaPorNome(NomeParaFiltrar) :-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (banda(Nome,MembrosAtuais, MembrosAntigos, Musicas , Instrumentos, Lancamento, Genero, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          BandasFiltrados),
          length(BandasFiltrados, Len),
  artistaToScreen(BandasFiltrados, 1, Len).

