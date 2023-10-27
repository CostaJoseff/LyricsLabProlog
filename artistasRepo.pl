:- consult('artistas.pl'), consult('musicafuncs.pl'), consult('util.pl').
:- dynamic (artista/4).

lenArtistas(X) :-
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          TodosOsArtistas),
  length(TodosOsArtistas, X).

getAllArtistas(TodosOsArtistas) :-
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, Id],
          artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
          Lista),
          avaliacaoAppend(Lista, [], TodosOsArtistas), !.

avaliacaoAppend([], Temp, Temp).
avaliacaoAppend([H|T], Temp, Retorno):-
  nth0(0, H, Nome),
  mediaArtista(Nome, Media),
  append(H, [Media], NovoH),
  append(Temp, [NovoH], NovoTemp),
  avaliacaoAppend(T, NovoTemp, Retorno).

buscarArtistaPorId(Id):-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  artistaToScreen([[Nome, BandaAtual, BandasAnteriores, Funcoes]], 1, 1).

buscarArtistaPorId(Id, Artista):-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  Artista = [Nome, BandaAtual, BandasAnteriores, Funcoes].

buscarArtistaPorNome(NomeParaFiltrar) :-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  artistaToScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAtual(BandaParaFiltrar) :-
  upcase_atom(BandaParaFiltrar, BandaParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(BandaAtual, BandaAtualUpCase),
          BandaParaFiltrarUpCase == BandaAtualUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  artistaToScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorBandaAnterior('') :-
  findall([Nome, BandaAtual, [], Funcoes, _],
          artista(Nome, BandaAtual, [], Funcoes, _),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  artistaToScreen(ArtistasFiltrados, 1, Len).
buscarArtistasPorBandaAnterior(BandaAnteriorParaFiltrar) :-
  BandaAnteriorParaFiltrar \= '',
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(BandaAnteriorParaFiltrar, BandaAnteriorParaFiltrarUpCase),
          contem(BandaAnteriorParaFiltrarUpCase, BandasAnteriores)),
          ArtistasFiltrados),
  length(ArtistasFiltrados, Len),
  artistaToScreen(ArtistasFiltrados, 1, Len).

buscarArtistasPorFuncao(FuncoesParaFiltrar) :-
  upcase_atom(FuncoesParaFiltrar, FuncoesParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          contem(FuncoesParaFiltrarUpCase, Funcoes)),
          ArtistasFiltrados),
          length(ArtistasFiltrados, Len),
  artistaToScreen(ArtistasFiltrados, 1, Len).

setArtista(Nome, BandaAtual, ListaBandasAnteriores, Funcoes):-
  open('artistas.pl', append, Stream),
  lenArtistas(X),
  Id is X + 1,
  assertz(artista(Nome, BandaAtual, ListaBandasAnteriores, Funcoes, Id)),
  format(string(Modelo), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nome, BandaAtual, ListaBandasAnteriores, Funcoes, Id]),
  write(Stream, Modelo),
  close(Stream),
  format('\n\n~w e o Id do artista cadastrado.\nEsse ID e unico e extremamente importante para efetuar alteracoes.\n\n', Id).

artistaValido(Id, Nome) :- 
  artista(ANome, _, _, _, Id),
  upperCase(Nome, NomeUp),
  upperCase(ANome, ANomeUp),
  NomeUp == ANomeUp.

removerBandaAtual(Id) :-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  BandaAtual \= "",
  append([BandaAtual], BandasAnteriores, NovaBandasAnteriores),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, "", NovaBandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.
removerBandaAtual(_).

atualizarBandaAtual(Id, NovaBandaAtual):-
  artista(Nome, BandaAtual, BandasAnteriores, Funcoes, Id),
  BandaAtual \= "",
  append([BandaAtual], BandasAnteriores, NovaBandasAnteriores),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, NovaBandaAtual, NovaBandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.
atualizarBandaAtual(Id, NovaBandaAtual):-
  artista(Nome, _, BandasAnteriores, Funcoes, Id),
  retract(artista(_, _, _, _, Id)),
  assertz(artista(Nome, NovaBandaAtual, BandasAnteriores, Funcoes, Id)),
  open('artistas.pl', write, Exclude),
  close(Exclude),
  open('artistas.pl', append, Stream),
  forall(artista(Nm, BdAt, BdAnt, Func, Idnt), (format(string(Modelo2), 'artista(~q, ~q, ~q, ~q, ~q).~n', [Nm, BdAt, BdAnt, Func, Idnt]), write(Stream, Modelo2))),
  close(Stream),
  !.

contem(_, []):- false.
contem(Alvo, [H|_]):- upperCase(Alvo, AlvoUpper), upperCase(H, UpperH), AlvoUpper == UpperH.
contem(Alvo, [_|T]):- contem(Alvo, T). 

naoContemArtista(NomeParaFiltrar):-
  upcase_atom(NomeParaFiltrar, NomeParaFiltrarUpCase),
  findall([Nome, BandaAtual, BandasAnteriores, Funcoes, _],
          (artista(Nome, BandaAtual, BandasAnteriores, Funcoes, _),
          upcase_atom(Nome, NomeUpCase),
          NomeUpCase == NomeParaFiltrarUpCase),
          ArtistasFiltrados),
  length(ArtistasFiltrados, 0).

artistaToString(Artista):-
  nth0(0, Artista, Nome),
  atom_concat(" - Nome: ", Nome, L1),
  
  nth0(1, Artista, BandaAtual),
  atom_concat(" - Banda atual: ", BandaAtual, L2),
  
  nth0(2, Artista, BandasAnteriores),
  listToString(BandasAnteriores, '', STRBandasAnteriores),
  atom_concat(" - Bandas anteriores: ", STRBandasAnteriores, L3),
  
  nth0(3, Artista, Funcoes),
  listToString(Funcoes, '', STRFuncoes),
  atom_concat(" - Funcao na banda: ", STRFuncoes, L4),

  mediaArtista(Nome, Media),

  writeln('\n*=*=*=*=*=*=*=*=*=*'),
  writeln(L1),
  writeln(L2),
  writeln(L3),
  writeln(L4),
  format(' - Avaliacao ~2f \n', Media),
  writeln('*=*=*=*=*=*=*=*=*=*\n'),
  sleep(1).

artistaToScreen([], _, _):- writeln('\nNenhum artista para mostrar.\n'), sleep(3).
artistaToScreen([H|[]], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), !.
artistaToScreen([H|T], Indice, Len):- write(Indice), artistaToString(H), Time is 2/Len, sleep(Time), NovoIndice is Indice+1, artistaToScreen(T, NovoIndice, Len).

mediaArtista(Nome, Media) :-
  musicasPorArtista(Nome, ListaDeMusicas),
  length(ListaDeMusicas, Len),
  mediaDasMusicas(ListaDeMusicas, Len, 0, Media).
