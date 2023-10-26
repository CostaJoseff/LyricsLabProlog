:- consult('bandas.pl')

% Predicado para salvar uma banda
salva_banda(Banda) :-
    assertz(banda(Banda)), % Adicionar a banda à base de conhecimento.
    writeln('Banda salva com sucesso.').
    
% Predicado para listar todas as bandas
listar_bandas :-
    findall(B, banda(B), Bandas), % Coletar todas as bandas da base de conhecimento.
    listar_bandas_aux(Bandas).

listar_bandas_aux([]).
listar_bandas_aux([Banda | Resto]) :-
    writeln(Banda), % Exibir a banda.
    listar_bandas_aux(Resto).

% Predicado para recuperar uma banda por nome
recuperar_por_nome(NomeBanda, Banda) :-
    banda(Banda), % Verificar se a banda existe na base de conhecimento.
    nome(Banda, NomeBanda), % Verificar se o nome da banda corresponde ao fornecido.
    writeln('Banda encontrada.').
recuperar_por_nome(_, Banda) :-
    writeln('Banda não encontrada.'),
    Banda = banda('null', ['null', 'null'], ['null'], ['null'], ['null'], 'null', 'null').

% Predicado para verificar se uma banda existe
existe_banda(NomeBanda) :-
    banda(Banda), % Verificar se a banda existe na base de conhecimento.
    nome(Banda, NomeBanda), % Verificar se o nome da banda corresponde ao fornecido.
    writeln('A banda existe.').
existe_banda(_) :-
    writeln('A banda não existe.').

% Predicado para adicionar um instrumento a uma banda
adicionar_instrumento(Instrumento, NomeBanda) :-
    banda(Banda), % Verificar se a banda existe na base de conhecimento.
    nome(Banda, NomeBanda), % Verificar se o nome da banda corresponde ao fornecido.
    instrumentos(Banda, InstrumentosAtuais),
    append(InstrumentosAtuais, [Instrumento], NovosInstrumentos),
    retract(banda(Banda)), % Remover a versão anterior da banda da base de conhecimento.
    assertz(banda(banda(NomeBanda, Compositores, Musicos, Musicas, NovosInstrumentos, DataFundacao, Genero))),
    writeln('Instrumento adicionado com sucesso à banda.').
adicionar_instrumento(_, _) :-
    writeln('Banda não encontrada ou instrumento não adicionado.').

% Predicado para adicionar um novo integrante a uma banda
adicionar_integrante(Integrante, NomeBanda) :-
    banda(Banda), % Verificar se a banda existe na base de conhecimento.
    nome(Banda, NomeBanda), % Verificar se o nome da banda corresponde ao fornecido.
    composicao_atual(Banda, IntegrantesAtuais),
    append(IntegrantesAtuais, [Integrante], NovosIntegrantes),
    retract(banda(Banda)), % Remover a versão anterior da banda da base de conhecimento.
    assertz(banda(banda(NomeBanda, Compositores, NovosIntegrantes, Musicas, Instrumentos, DataFundacao, Genero))),
    writeln('Integrante adicionado com sucesso à banda.').
adicionar_integrante(_, _) :-
    writeln('Banda não encontrada ou integrante não adicionado.').

% Predicado para remover um integrante de uma banda
remover_integrante(Integrante, NomeBanda) :-
    banda(Banda),
    nome(Banda, NomeBanda),
    composicao_atual(Banda, IntegrantesAtuais),
    member(Integrante, IntegrantesAtuais), % Verifica se o integrante está na lista atual
    delete(IntegrantesAtuais, Integrante, NovosIntegrantes),
    artistas_anteriores(Banda, IntegrantesAntigos),
    append([Integrante], IntegrantesAntigos, NovosIntegrantesAntigos), % Adiciona o integrante à lista de antigos
    retract(banda(Banda)),
    assertz(banda(banda(NomeBanda, Compositores, NovosIntegrantes, Musicas, Instrumentos, DataFundacao, Genero, NovosIntegrantesAntigos))),
    writeln('Integrante movido para a lista de antigos integrantes com sucesso.').

remover_integrante(_, _) :-
    writeln('Banda não encontrada ou integrante não removido.').


% Predicado para remover uma banda
remover_banda(NomeBanda) :-
    retract(banda(banda(NomeBanda, _, _, _, _, _, _))), % Remover a banda da base de conhecimento.
    writeln('Banda removida com sucesso.').
remover_banda(_) :-
    writeln('Banda não encontrada ou não removida.').

% Predicado para atualizar uma banda
atualizar_banda(NomeBanda, BandaNova) :-
    retract(banda(banda(NomeBanda, _, _, _, _, _, _))), % Remover a versão anterior da banda da base de conhecimento.
    assertz(BandaNova), % Adicionar a nova versão da banda à base de conhecimento.
    writeln('Banda atualizada com sucesso.').

% Predicado para filtrar bandas por instrumento
filtrar_bandas_por_instrumento(Instrumento, BandasFiltradas) :-
    findall(B, (banda(B), instrumentos(B, Instrumentos), member(Instrumento, Instrumentos)), BandasFiltradas).

% Predicado para filtrar bandas por gênero
filtrar_bandas_por_genero(Genero, BandasFiltradas) :-
    findall(B, (banda(B), genero(B, Genero)), BandasFiltradas).

% Predicado para filtrar bandas por artista
filtrar_bandas_por_artista(Artista, BandasFiltradas) :-
    findall(B, (banda(B), (composicao_atual(B, IntegrantesAtual); artistas_anteriores(B, IntegrantesAnteriores)),
        member(Artista, IntegrantesAtual); member(Artista, IntegrantesAnteriores)), BandasFiltradas).


% Predicado para buscar uma banda pelo nome
buscar_banda_por_nome(NomeBanda, Banda) :-
    banda(NomeBanda, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao),
    Banda = [NomeBanda, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao].

% Predicado para buscar bandas por membro antigo
buscar_bandas_por_membro_antigo(NomeMembroAntigo, BandasEncontradas) :-
    findall(Banda, (banda(Banda), artistas_anteriores(Banda, MembrosAntigos), member(NomeMembroAntigo, MembrosAntigos)), BandasEncontradas).



