:- consult('artistasRepo.pl'), consult('util.pl').

topNArtistas(0):- !.
topNArtistas(N) :-
  getAllArtistas(TodosOsArtistas),
  ordenarArtistas(TodosOsArtistas, [], ArtistasOrdenados),
  length(ArtistasOrdenados, Len),
  Minimo is min(N, Len),
  dashBoartArtistaToScreen(ArtistasOrdenados, 1, Minimo),!.

dashBoartArtistaToScreen([], _, _):- !.
dashBoartArtistaToScreen(_, Indice, Limite):-
  Indice > Limite, !.
dashBoartArtistaToScreen([H|T], Indice, Limite):-
  Indice =< Limite,
  dashBoartArtistaToString(H, Indice),
  Time is 2/Limite, sleep(Time),
  NovoIndice is Indice + 1,
  dashBoartArtistaToScreen(T, NovoIndice, Limite), !.

dashBoartArtistaToString(Artista, Indice):-
  write('\n'), write(Indice), writeln(' Lugar'),
  nth0(0, Artista, Nome),
  nth0(5, Artista, Avaliacao),

  musicasPorArtista(Nome, ListaDeMusicas),
  ordenarMusicas(ListaDeMusicas, [], MusicasOrdenadas),
  nth0(0, MusicasOrdenadas, MelhorMusica),
  nth0(1, MelhorMusica, NomeMusica),
  nth0(8, MelhorMusica, AvaliacaoMusica),

  writeln('#=#=#=#=#=#=#=#=#=#'),
  write(Nome), write(' com '), format('~2f', Avaliacao), writeln(' de avaliacao'),
  write(NomeMusica), write(' e a melhor musica do artista com '), write(AvaliacaoMusica), writeln(' de avaliacao'),
  writeln('#=#=#=#=#=#=#=#=#=#').

totalArtistasPorFuncao(Funcao, Total):-
  upcase_atom(Funcao, FuncaoUpCase),
  findall([Funcoes],
          (artista(_, _, _, Funcoes, _),
          contem(FuncaoUpCase, Funcoes)),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Total).

dadosGerais(Dados) :-
  getAllArtistas(TodosOsArtistas),
  length(TodosOsArtistas, TotalDeArtistas),
  append([], [TotalDeArtistas], L1),
  contarFuncoes(TodosOsArtistas, [], TotalDeFuncoes),
  append(L1, [TotalDeFuncoes], L2),
  contarArtistasSolo(TotalArtistasSolo),
  append(L2, [TotalArtistasSolo], L3),
  getFuncoesDistintas(TodosOsArtistas, [], FuncoesDistintas),
  append(L3, [FuncoesDistintas], Dados).

getFuncoesDistintas([], Temp, Temp).
getFuncoesDistintas([H|T], Temp, Retorno):-
  nth0(3, H, Funcoes),
  inserirDistintos(Funcoes, Temp, NovaTemp),
  getFuncoesDistintas(T, NovaTemp, Retorno).

contarFuncoes([], Temp, Total):- length(Temp, Total).
contarFuncoes([H|T], Temp, Total):-
  nth0(3, H, Funcoes),
  inserirDistintos(Funcoes, Temp, NovaTemp),
  contarFuncoes(T, NovaTemp, Total).

contarArtistasSolo(Total):-
  findall([Id],
          (artista(_, BandaAtual, _, _, Id),
          upperCase(BandaAtual, BandaAtualUpCase),
          BandaAtualUpCase = 'SOLO'),
          ArtistasSolo),
  length(ArtistasSolo, Total).