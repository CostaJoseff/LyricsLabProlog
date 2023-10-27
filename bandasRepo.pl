:- consult('util.pl'), consult('musicafuncs.pl'), consult('bandas.pl'), consult('artistasRepo.pl').
:- dynamic (banda/6).

lenBandas(X):-
  findall([Nome],
          banda(Nome, _, _, _, _, _),
          TodasAsBandas),
  length(TodasAsBandas, X).

naoContemBanda(NomeDaBanda):-
  upperCase(NomeDaBanda, NomeBandaUpCase),
  findall([Nome],
          (banda(Nome, _, _, _, _, _),
          upperCase(Nome, NomeUpper),
          NomeUpper == NomeBandaUpCase),
          BandasFiltradas),
  length(BandasFiltradas, 0).

setBanda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero):-
  open('bandas.pl', append, Stream),
  assertz(banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero)),
  format(string(Modelo), 'banda(~q, ~q, ~q, ~q, ~q, ~q).~n', [Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero]),
  write(Stream, Modelo),
  close(Stream).

buscarBandaPorNome(NomeParaFiltrar):-
  upperCase(NomeParaFiltrar, NomeParaFiltrarUpper),
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          upperCase(Nome, NomeUpper),
          NomeUpper == NomeParaFiltrarUpper),
          BandasFiltradas),
  length(BandasFiltradas, Len),
  bandaToScreen(BandasFiltradas, 1, Len).

buscarBandaPorNome(NomeParaFiltrar, Retorno):-
  upperCase(NomeParaFiltrar, NomeParaFiltrarUpper),
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          upperCase(Nome, NomeUpper),
          NomeUpper == NomeParaFiltrarUpper),
          Lista),
  nth0(0, Lista, Retorno).

buscarBandaPorInstrumento(InstrumentoParaFiltrar):-
  InstrumentoParaFiltrar \= '',
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          upperCase(InstrumentoParaFiltrar, InstrumentoParaFiltrarUpCase),
          contem(InstrumentoParaFiltrarUpCase, InstrumentosUtilizados)),
          BandasFiltradas),
  length(BandasFiltradas, Len),
  bandaToScreen(BandasFiltradas, 1, Len).

buscarBandaPorGenero(GeneroParaFiltrar):-
  GeneroParaFiltrar \= '',
  upperCase(GeneroParaFiltrar, GeneroParaFiltrarUpCase),
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          upperCase(Genero, GeneroUpCase),
          GeneroUpCase == GeneroParaFiltrarUpCase),
          BandasFiltradas),
  length(BandasFiltradas, Len),
  bandaToScreen(BandasFiltradas, 1, Len).

removerIntegrante(IdArtista, NomeBanda):-
  buscarArtistaPorId(IdArtista, Artista),
  nth0(0, Artista, NomeArtista),
  upperCase(NomeArtista, NomeArtistaUpperCase),
  buscarBandaPorNome(NomeBanda, Banda),
  nth0(0, Banda, NomeCorretoBanda),
  nth0(1, Banda, Integrantes),
  nth0(2, Banda, AntigosIntegrantes),
  nth0(3, Banda, Instrumentos),
  nth0(4, Banda, Data),
  nth0(5, Banda, Genero),
  removerDaLista(NomeArtistaUpperCase, Integrantes, [], NovosIntegrantes),
  append(AntigosIntegrantes, [NomeArtista], NovosAntigosIntegrantes),
  retract(banda(NomeCorretoBanda,_,_,_,_,_)),
  assertz(banda(NomeCorretoBanda, NovosIntegrantes, NovosAntigosIntegrantes, Instrumentos, Data, Genero)),
  open('bandas.pl', write, Exclude),
  close(Exclude),
  open('bandas.pl', append, Stream),
  forall(banda(Nm, Int, Antg, Inst, Dt, Gnr), (format(string(Modelo), 'banda(~q, ~q, ~q, ~q, ~q, ~q).~n', [Nm, Int, Antg, Inst, Dt, Gnr]), write(Stream, Modelo))),
  close(Stream),
  removerBandaAtual(IdArtista),
  !.

adicionarIntegrante(IdArtista, NomeBanda):-
  buscarArtistaPorId(IdArtista, Artista),
  nth0(0, Artista, NomeArtista),
  upperCase(NomeArtista, NomeArtistaUpperCase),
  buscarBandaPorNome(NomeBanda, Banda),
  nth0(0, Banda, NomeCorretoBanda),
  nth0(1, Banda, Integrantes),
  nth0(2, Banda, AntigosIntegrantes),
  nth0(3, Banda, Instrumentos),
  nth0(4, Banda, Data),
  nth0(5, Banda, Genero),
  removerDaLista(NomeArtistaUpperCase, AntigosIntegrantes, [], NovosAntigosIntegrantes),
  append(Integrantes, [NomeArtista], NovosIntegrantes),
  retract(banda(NomeCorretoBanda,_,_,_,_,_)),
  assertz(banda(NomeCorretoBanda, NovosIntegrantes, NovosAntigosIntegrantes, Instrumentos, Data, Genero)),
  open('bandas.pl', write, Exclude),
  close(Exclude),
  open('bandas.pl', append, Stream),
  forall(banda(Nm, Int, Antg, Inst, Dt, Gnr), (format(string(Modelo), 'banda(~q, ~q, ~q, ~q, ~q, ~q).~n', [Nm, Int, Antg, Inst, Dt, Gnr]), write(Stream, Modelo))),
  close(Stream),
  atualizarBandaAtual(IdArtista, NomeCorretoBanda),
  !.

buscarBandaPorArtista(Artista):-
  Artista \= '',
  upperCase(Artista, ArtistaUpper),
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          contem(ArtistaUpper, ComposicaoAtual)),
          BandasFiltradas),
  filtrarBandaPorArtistasAnteriores(Artista, BandasFiltradas2),
  append(BandasFiltradas, BandasFiltradas2, Resultado),
  length(Resultado, Len),
  bandaToScreen(Resultado, 1, Len).

filtrarBandaPorArtistasAnteriores(Artista, Resultado):-
  Artista \= '',
  upperCase(Artista, ArtistaUpper),
  findall([Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero],
          (banda(Nome, ComposicaoAtual, ArtistasAnteriores, InstrumentosUtilizados, DataDeFundacao, Genero),
          contem(ArtistaUpper, ArtistasAnteriores)),
          Resultado).

bandaToScreen([], _, _):- writeln('\nNenhuma banda para mostrar.\n'), sleep(3).
bandaToScreen([H|[]], Indice, Len):- write(Indice), bandaToString(H), Time is 2/Len, sleep(Time), !.
bandaToScreen([H|T], Indice, Len):-  write(Indice), bandaToString(H), Time is 2/Len, sleep(Time), NovoIndice is Indice+1, bandaToScreen(T, NovoIndice, Len), !.

bandaToString(Banda):-
  nth0(0, Banda, Nome),
  nth0(1, Banda, ComposicaoAtual),
  listToString(ComposicaoAtual, '', STRComposicaoAtual),
  nth0(2, Banda, ArtistasAnteriores),
  listToString(ArtistasAnteriores, '', STRArtistasAnteriores),
  nth0(3, Banda, Instrumentos),
  listToString(Instrumentos, '', STRInstrumentos),
  nth0(4, Banda, DataDeFundacao),
  nth0(5, Banda, Genero),

  mediaBanda(Nome, _),

  writeln('\n*=*=*=*=*=*=*=*=*=*'),
  format(' - Nome: ~s\n', Nome),
  format(' - Composicao atual: ~s\n', STRComposicaoAtual),
  format(' - Integrantes antigos: ~s\n', STRArtistasAnteriores),
  format(' - Instrumentos utilizados: ~s\n', STRInstrumentos),
  format(' - Data de fundacao: ~s\n', DataDeFundacao),
  format(' - Genero: ~s\n', Genero),
  format(' - Avaliacao: Indisponivel\n'),
  writeln('*=*=*=*=*=*=*=*=*=*\n'),
  sleep(1).

mediaBanda(Nome, Media):-
  musicasPorBanda(Nome, ListaDeMusicas),
  length(ListaDeMusicas, Len),
  mediaDasMusicas(ListaDeMusicas, Len, 0, Media).
