:- consult('artistasRepo.pl'), consult('artistas.pl'), consult('musicafuncs.pl'), consult('util.pl'), consult('dashBoard.pl'), consult('bandas.pl'), consult('bandasRepo.pl').
:- dynamic (artista/5).
:- dynamic (banda/8).
:- use_module(library(http/json)).
:- initialization(lyricsLab).

lyricsLab :-
  writeln('\n================='),
  writeln('1. Artistas'),
  writeln('2. Bandas'),
  writeln('3. Musicas'),
  writeln('4. DashBoard'),
  writeln('0. Sair'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  menu2(OpcaoUpper),
  lyricsLab.

menu2('1') :- 
  writeln('\n================='),
  writeln('1. Adicionar um novo artista'),
  writeln('2. Buscar pelo NOME'),
  writeln('3. Buscar pela BANDA ATUAL'),
  writeln('4. Buscar por uma das BANDAS ANTERIORES'),
  writeln('5. Buscar por FUNCAO NA BANDA'),
  writeln('0. Voltar'),

  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoArtista(OpcaoUpper).

menu2('2'):-
  writeln('\n================='),
  writeln('1. Adicionar uma nova banda'),
  writeln('2. Buscar pelo NOME'),
  writeln('3. Buscar pelo GENERO'),
  writeln('4. Buscar pelo INSTRUMENTO utilizado'),
  writeln('5. Buscar por Artista (Atual ou antigo)'),
  writeln('6. Remover integrante'),
  writeln('7. Adicionar integrante'),
  writeln('0. Voltar'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoBanda(OpcaoUpper).
menu2('3') :- 
  writeln('\n================='),
  writeln('1. Adicionar uma nova musica'),
  writeln('2. Buscar Musica por Id.'),
  writeln('3. Buscar musicas por trecho.'),
  writeln('4. Buscar musicas por ritmo. '),
  writeln('5. Buscar musicas por instrumentos.'),
  writeln('6. Buscar musicas por nome'),
  writeln('0. Voltar'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoGrande),
  opcaoMusica(OpcaoGrande).
menu2('4') :-
  writeln('\n================='),
  writeln('D. Resumo geral'),
  writeln('1. Top N melhores artistas'),
  writeln('2. Top N melhores musicas'),
  writeln('3. Top N melhores bandas'),
  writeln('4. Sugestao aleatoria de artista'),
  writeln('5. Sugestao aleatoria de musica'),
  writeln('6. Sugestao aleatoria de banda'),
  writeln('0. Voltar'),
  writeln('\n================='),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoDashBoard(OpcaoUpper).

menu2('0') :- halt.
menu2(_) :- writeln('Opcao invalida'), sleep(2).


% Area Artistas
opcaoArtista('1') :-
  writeln('\n================='),
  write(' - Nome do artista'),
  read(Input),
  atom_string(Input, Nome),
  naoContemArtista(Nome),
  write(' - Banda atual'),
  read(Input2),
  atom_string(Input2, BandaAtual),
  write(' - Lista de bandas anteriores (separe com virgula e espaco ", " ou vazio caso nao tenha)'),
  read(BandasAnterioresString),
  splitVS(BandasAnterioresString, ListaBandasAnteriores),
  write(' - Quais as funcoes na banda atual (separe com virgulaa e espaco ", " ou vazio caso nao tenha)'),
  read(Funcoes),
  splitVS(Funcoes, ListaDeFuncoes),
  setArtista(Nome, BandaAtual, ListaBandasAnteriores, ListaDeFuncoes),
  sleep(2),
  buscarArtistaPorNome(Nome), !.
opcaoArtista('1') :- writeln('\nEsse nome existe na lista de artistas cadastrados!\n'), sleep(2).

opcaoArtista('2') :-
  writeln('\n================='),
  write(' - Nome do artista (serao apresentados todos os artistas de mesmo nome)'),
  read(Nome),
  buscarArtistaPorNome(Nome).

opcaoArtista('3') :-
  writeln('\n================='),
  write(' - Nome da banda atual do artista'),
  read(BandaAtual),
  buscarArtistasPorBandaAtual(BandaAtual).

opcaoArtista('4') :-
  writeln('\n================='),
  write(' - Nome de uma das bandas anteriores do artista'),
  read(BandaAnterior),
  buscarArtistasPorBandaAnterior(BandaAnterior).

opcaoArtista('5') :-
  writeln('\n================='),
  write(' - Funcao do artista'),
  read(Funcao),
  buscarArtistasPorFuncao(Funcao).

opcaoArtista('0') :- lyricsLab.
opcaoArtista(_):- writeln('Opcao invalida'), sleep(2), menu2('1').

%AREA MUSICAS.

opacaoMusica(_):- writeln("Opcao invalida").

opacaoMusica('0').

opcaoMusica('1'):- %Menu musica
  writeln('\n================='),
  writeln("Digite o nome da musica"),
  read(Nome),
  writeln('\n================='),
  writeln('Digite os instrumentos (Separados por virgula)'),
  read(Instrumentos),
  writeln('\n================='),
  writeln('Digite os participantes (Separados por virgula)'),
  read(Participantes),
  writeln('\n================='),
  writeln('Digite o ritmo'),
  read(Ritmo),
  writeln('\n================='),
  writeln('Digite a data de lancamento'),
  read(DataLancamento),
  writeln('\n================='),
  writeln('Digite a letra dela'),
  read(Letra),
  writeln('\n================='),
  write("Digite o nome da banda"),
  read(NomeBanda),
  writeln('\n================='),
  write('Digite a avaliacao dela'),
  read(Avaliacao),
  split_string(Instrumentos, ',', ',', InstrumentoSplitado),
  split_string(Participantes, ',', ',', ParticipantesSplitado),
  adicionaMusica(Nome, InstrumentoSplitado, ParticipantesSplitado, Ritmo, DataLancamento, Letra, NomeBanda, Avaliacao).

opcaoMusica('2'):-
  writeln('\n================='),
  writeln('Digite o Id da musica'),
  read(Id),
  selecionaMusica(Id, Resultado),
  exibirMusica(Resultado),
  sleep(5).

opcaoMusica('3') :-
  writeln('\n================='),
  writeln('Digite o trecho da musica'),
  read(Trecho),
  filtroMusicasPorTrecho(Trecho, Resultado),
  exibirMusicas(Resultado),
  sleep(5).

opcaoMusica('4') :-
  writeln('\n================='),
  writeln('Digite o ritmo'),
  read(Ritmo),
  filtroMusicasPorRitmo(Ritmo, Resultado),
  exibirMusicas(Resultado),
  sleep(5).

opcaoMusica('5') :-
  writeln('\n================='),
  writeln('Digite o Instrumento'),
  read(Instrumento),
  filtrarMusicasInstrumento(Instrumento, Resultado),
  exibirMusicas(Resultado),
  sleep(5).

opcaoMusica('6') :-
  writeln('\n================='),
  writeln('Digite o nome'),
  read(Nome), 
  filtroMusicasPorNome(Nome, Resultado),
  exibirMusicas(Resultado),
  sleep(5).

% Área DashBoard
opcaoDashBoard('1') :-
  writeln('\n================='),
  write('Informe quantos artistas vao aparecer no TOP'),
  read(Total),
  topNArtistas(Total).
opcaoDashBoard('4') :-
  writeln('\n================='),
  lenArtistas(Len),
  random(1, Len, IdAleatorio),
  buscarArtistaPorId(IdAleatorio).
opcaoDashBoard('D') :-
  dadosGerais(Dados),
  nth0(0, Dados, TotalDeArtistas),
  nth0(1, Dados, TotalDeFuncoes),
  nth0(2, Dados, TotalArtistasSolo),
  nth0(3, Dados, FuncoesDistintas),
  writeln('\n========Artistas========='),
  format('Existem ~w artistas registrados no LyricsLab\n', TotalDeArtistas), sleep(2),
  format('De todos os artistas existem ~w funcoes distintas\n', TotalDeFuncoes), sleep(2),
  writeln('Dentre essas funcoes, existem:'), sleep(2),
  funcoesDistintasToScreen(FuncoesDistintas),
  format('Dentre os artistas existem ~w que nao participam de uma banda especifica\n\n', TotalArtistasSolo), sleep(2),
  dadosGeraisMusica.

opcaoDashBoard('2') :-
  writeln('\n================='),
  writeln('Informe quantas musicas vao aparecer no Top'),
  read(Total),
  nMelhoresMusicas(Total, Resultado),
  printarGrafico(Resultado),
  sleep(5).

opcaoDashBoard('5') :- 
  sugerirMusica(Musica),
  exibirMusica(Musica),
  sleep(5).

opcaoDashBoard('0') :- lyricsLab.
opcaoDashBoard(_) :- writeln('Opcao invalida'), sleep(2), menu2('4').

funcoesDistintasToScreen([]).
funcoesDistintasToScreen([H|T]):-
  totalArtistasPorFuncao(H, Total),
  format(' - ~w ~ws\n', [Total, H]), sleep(1),
  funcoesDistintasToScreen(T).


%AREA BANDA
opcaoBanda('1'):-
  writeln('\n================='),
  write(' - Nome da Banda'),
  read(Input),
  atom_string(Input, Nome),
  naoContemBanda(Nome),
  write(' - Lista com nomes dos artistas que compoem a banda atualmente (separe com virgula e espaco ", ")'),
  read(ComposicaoAtual),
  splitVS(ComposicaoAtual, ListaComposicaoAtual),
  write(' - Lista com nomes dos antigos artistas da banda (separe com virgula e espaco ", " ou vazio caso nao tenha)'),
  read(ArtistasAnteriores),
  splitVS(ArtistasAnteriores, ListaArtistasAnteriores),
  write(' - Quais instrumentos sao ou foram utilizados na banda (separe com virgula e espaco ", ")'),
  read(InstrumentosUtilizados),
  splitVS(InstrumentosUtilizados, ListaInstrumentosUtilizados),
  write(' - Informe a data de funcacao:'),
  read(Input2),
  atom_string(Input2, DataDeFundacao),
  write(' - Informe o genero da banda'),
  read(Input3),
  atom_string(Input3, Genero),
  setBanda(Nome, ListaComposicaoAtual, ListaArtistasAnteriores, ListaInstrumentosUtilizados, DataDeFundacao, Genero),
  sleep(2),
  buscarBandaPorNome(Nome).
opcaoBanda('1'):- writeln('Este nome existe na lista de bandas cadastradas.\n'), sleep(2), menu2('2'). 
opcaoBanda('2'):-
  writeln('\n================='),
  write(' - Nome da banda'),
  read(Nome),
  buscarBandaPorNome(Nome).
opcaoBanda('3'):-
  writeln('\n================='),
  write(' - Genero para filtrar'),
  read(Genero),
  buscarBandaPorGenero(Genero).
opcaoBanda('4'):-
  writeln('\n================='),
  write(' - Instrumento para filtrar'),
  read(Instrumento),
  buscarBandaPorInstrumento(Instrumento).
opcaoBanda('5'):-
  writeln('\n================='),
  write(' - Artista para filtrar'),
  read(Artista),
  buscarBandaPorArtista(Artista).
opcaoBanda('6'):-
  writeln('\n================='),
  write(' - Id do integrante que sera removido'),
  read(IdArtista),
  write(' - Nome da banda que possui esse integrante'),
  read(Input),
  atom_string(Input, NomeBanda),
  removerIntegrante(IdArtista, NomeBanda).
opcaoBanda('7'):-
  writeln('\n================='),
  write(' - Id do novo integrante'),
  read(IdArtista),
  write(' - Nome da banda que recebera o novo integrante'),
  read(Input),
  atom_string(Input, NomeBanda),
  adicionarIntegrante(IdArtista, NomeBanda).
opcaoBanda('0'):- lyricsLab.
opcaoBanda(_):- writeln('Opcao invalida'), sleep(2), menu2('2').