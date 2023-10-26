:- consult('artistasRepo.pl'), consult('artistas.pl'), consult('musicafuncs.pl'), consult('util.pl'), consult('dashBoard.pl'), consult('bandas.pl'), consult('bandasfuncs.pl').
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
  writeln('6. Remover banda atual'),
  writeln('7. Alterar banda atual'),
  writeln('0. Voltar'),
  writeln('=================\n'),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoArtista(OpcaoUpper).

menu2('2'):-
  writeln('\n================='),
  writeln('1. Adicionar uma nova banda'),
  writeln('2. Buscar pelo banda pelo nome'),
  writeln('3. filtrar pelo artista '),
  writeln('4. filtrar pelo genero'),
  writeln('5. filtrar por instrumento '),
  writeln('6. filtrar por membros antigos'),
  writeln('7. Remover banda '),
  writeln('8. Alterar banda'),
  writeln('0. Voltar'),
  writeln('=================\n')
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

opcaoArtista('6') :-
  writeln('\n================='),
  write(' - ID do artista'),
  read(Id),
  write(' - Nome do artista'),
  read(Input),
  atom_string(Input, Nome),
  artistaValido(Id, Nome),
  removerBandaAtual(Id),
  writeln('\nBanda removida com sucesso!\n'),
  sleep(2),
  buscarArtistaPorNome(Nome).
opcaoArtista('6'):- writeln('\nErro ao tentar alterar a banda do artista\nVerifique se o artista consta em sistema ou se o nome ou o codigo de identificacao estao corretos.\n'), sleep(3), menu2('1').

opcaoArtista('7'):- 
  writeln('\n================='),
  write(' - ID do artista'),
  read(Id),
  write(' - Nome do artista'),
  read(Input),
  atom_string(Input, Nome),
  artistaValido(Id, Nome),
  write(' - Nome da nova banda atual'),
  read(Input2),
  atom_string(Input2, NovaBandaAtual),
  atualizarBandaAtual(Id, NovaBandaAtual),
  writeln('\nBanda atualizada com sucesso!\n'),
  sleep(2),
  buscarArtistaPorNome(Nome).

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
  writeln('Informe quantos artistas vao aparecer no TOP'),
  read(Total),
  topNArtistas(Total).
opcaoDashBoard('4') :-
  writeln('\n================='),
  lenArtistas(Len),
  random(1, Len, IdAleatorio),
  buscarArtistaPorId(IdAleatorio).
opcaoDashBoard('D') :-
  dadosGerais().

opcaoDashBoard('2') :-
  writeln('\n================='),
  writeln('Informe quantas musicas vao aparecer no Top'),
  read(Total),
  nMelhoresMusicas(Total, Resultado),
  printarGrafico(Resultado),
  sleep(5).

opcaoDashBoard('0') :- lyricsLab.
opcaoDashBoard(_) :- writeln('Opcao invalida'), sleep(2), menu2('4').


%AREA BANDA
 opcaoBanda(_):- writeln('Opcao invalida').
opcaoBanda('1') :-
  writeln('\n================='),
  writeln('Digite o nome da banda'),
  read(Nome),
  writeln('\n================='),
  writeln('Digite os membros atuais (Separados por virgula)'),
  read(Compatual),
  writeln('\n================='),
  writeln('Digite os membros anteriores (Separados por virgula , caso tenha )'),
  read(Compold),
  writeln('\n================='),
  writeln('Digite as músicas dessa banda (Separadas por vírgula , caso tenha )'),
  read(Musicas),
  writeln('\n================='),
  writeln('Digite os instrumentos dessa banda (Separados por vírgula , caso tenha )'),
  read(Instrumentos),
  writeln('\n================='),
  writeln('Digite a data de lançamento'),
  read(DataLancamento),
  writeln('\n================='),
  writeln('Digite o gênero'),
  read(Genero),
  writeln('\n================='),
  writeln('Digite a avaliação dela'),
  read(Avaliacao),
  
 
  split_string(Compatual, ',', ',', MembrosAtuais),
  split_string(Compold, ',', ',', MembrosAntigos),

 
  split_string(Musicas, ',', ',', MusicasLista),

 
  split_string(Instrumentos, ',', ',', InstrumentosLista),

  
  adicionar_banda(Nome, MembrosAtuais, MembrosAntigos, MusicasLista, InstrumentosLista, DataLancamento, Genero, Avaliacao).

opcaoBanda('2') :-
  writeln('\n================='),
  write(' - Nome da banda (serao apresentados todos os artistas de mesmo nome)'),
  read(Nome),
  buscar_banda_por_nome(Nome, Banda).


opcaoBanda('3') :-
  writeln('\n================='),
  write(' - Nome do artista (serao apresentados todas as bandas que esse artista esta no momento)'),
  read(Nome),
  filtrar_bandas_por_artista(Nome, BandasFiltradas).

opcaoBanda('4') :-
  writeln('\n================='),
  write(' - genero  (serao apresentados todas as bandas que possuem esse genero)'),
  read(Nome),
  filtrar_bandas_por_genero(Nome, BandasFiltradas).


opcaoBanda('5') :-
  writeln('\n================='),
  write(' - instrumento  (serao apresentados todas as bandas que possuem esse instrumento em sua composição)'),
  read(Nome),
  filtrar_bandas_por_instrumento(Nome, BandasFiltradas).

opcaoBanda('6') :-
  writeln('\n================='),
  write(' - digite o nome do antigo membro  (serao apresentados todas as bandas que possuiam esse membro)'),
  read(Nome),
  buscar_bandas_por_membro_antigo(Nome, BandasFiltradas).


opcaoBanda('7') :-
  writeln('\n================='),
  write(' - Nome da banda (essa banda sera removida do sistema)'),
  read(Nome),
  remover_banda(Nome).


opcaoBanda('8') :-
  writeln('\n================='),
  writeln('1. adicionar membro'),
  writeln('2. remover membro'),
  writeln('3. adicionar intrumento'),
  writeln('0. Voltar'),
  writeln('\n================='),
  read(Opcao),
  upperCase(Opcao, OpcaoUpper),
  opcaoalterar(OpcaoUpper).

opcaoBanda('0') :- lyricsLab.

opcaoalterar(_):- writeln('Opcao invalida').
opcaoalterar('1') :-
  writeln('\n================='),
  write(' - Nome da banda='),
  read(Bandanome),
  write(' - Nome do integrante'),
  read(Nome),
  adicionar_integrante(Nome,Bandanome).

opcaoalterar('2') :-
  writeln('\n================='),
  write(' - Nome da banda='),
  read(Bandanome),
  write(' - Nome do integrante'),
  read(Nome),
  remover_integrante(Nome,Bandanome).

opcaoalterar('3') :-
  writeln('\n================='),
  write(' - Nome da banda='),
  read(Bandanome),
  write(' - instrumento'),
  read(Nome),
  adicionar_instrumento(Nome,Bandanome).
opcaoalterar('0') :- lyricsLab.
  
