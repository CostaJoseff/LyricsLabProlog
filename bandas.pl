:- dynamic banda/8.
banda('Nome da Banda', ['Membro1', 'Membro2', 'Membro3'], ['AntigoMembro1'], ['Música1', 'Música2'], ['Instrumento1', 'Instrumento2'], 'Data', 'Gênero' , 'avaliação').
banda('The Beatles', ['John Lennon', 'Paul McCartney', 'George Harrison', 'Ringo Starr'], [], ['Hey Jude', 'Let It Be', 'Yesterday'], ['Guitar', 'Bass', 'Guitar', 'Drums'], '1960', 'Rock' , '5').
banda('Pink Floyd', ['Roger Waters', 'David Gilmour', 'Richard Wright', 'Nick Mason'], [], ['Comfortably Numb', 'Wish You Were Here', 'Money'], ['Guitar', 'Guitar', 'Keyboard', 'Drums'], '1965', 'Rock', '5').
banda('Queen', ['Freddie Mercury', 'Brian May', 'John Deacon', 'Roger Taylor'], [], ['Bohemian Rhapsody', 'We Will Rock You', 'Radio Ga Ga'], ['Vocals', 'Guitar', 'Bass', 'Drums'], '1970', 'Rock', '5').
banda('Slipknot', ['Corey Taylor', 'Jim Root', 'Shawn Crahan', 'Jay Weinberg', 'Alessandro Venturella', 'Sid Wilson', 'Craig Jones', 'Tortilla Man'], ['Joey Jordison', 'Paul Gray'], ['Psychosocial', 'Duality', 'Before I Forget'], ['Vocals', 'Guitar', 'Percussion', 'Drums', 'Bass', 'Turntables', 'Samples', 'Keyboards'], '1995', 'Metal', '5').

% Inicializa uma lista vazia para armazenar as bandas.
:- dynamic bandas/1.
assertz(bandas([])).

% Predicado para adicionar uma banda
adicionar_banda(Nome, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao) :-
    retract(bandas(Lista)),
    assertz(bandas([[Nome, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao] | Lista])).

% Predicado para listar todas as bandas
listar_banda :-
    banda(Nome, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao),
    format("Nome: ~w~nComposição Atual: ~w~nArtistas Anteriores: ~w~nMúsicas: ~w~nInstrumentos: ~w~nData de Fundação: ~w~nGênero: ~w~nAvaliação: ~w~n~n",
        [Nome, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao]).

% Predicado para listar todas as bandas
listar_bandas :-
    bandas(Lista),
    write("Lista de bandas:\n"),
    listar_bandas_aux(Lista).

listar_bandas_aux([]).
listar_bandas_aux([Banda | Resto]) :-
    write(Banda), nl,
    listar_bandas_aux(Resto).

% Predicado para obter uma banda da lista
get_banda(NomeBanda, Banda) :-
    bandas(Lista),
    member([NomeBanda, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao], Lista),
    Banda = [NomeBanda, Membros, ArtistasAnteriores, Musicas, Instrumentos, DataFundacao, Genero, Avaliacao].

% Predicado para definir uma banda na lista
set_banda(NomeBanda, NovaBanda) :-
    bandas(Lista),
    subtract(Lista, [[NomeBanda, _, _, _, _, _, _, _]], ListaAtual), % Remove a banda existente (se houver)
    append(ListaAtual, [NovaBanda], NovaLista), % Adiciona a nova banda
    retract(bandas(_)), % Remove a lista de bandas atual
    assertz(bandas(NovaLista)). % Define a nova lista de bandas
