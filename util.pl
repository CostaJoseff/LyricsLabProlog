upperCase(String, Uppercase) :-
  atom_string(Atom, String),
  upcase_atom(Atom, Uppercase).

listToString([], Resultado, Resultado):- !.
listToString([H|[]], Resultado, Retorno):- atom_concat(H, "", UltimoResultado), atom_concat(Resultado, UltimoResultado, Retorno), !.
listToString([H|T], Resultado, Retorno):-
  atom_concat(H, " | ", NovoElemento),
  atom_concat(Resultado, NovoElemento, NovoResultado),
  listToString(T, NovoResultado, Retorno).

splitVS('', []).
splitVS(String, Retorno) :-
  split_string(String, ",", " ", Retorno).
  
limitarCasasDecimais(Numero, NumeroFormatado) :-
  atomic_list_concat(['~2f', Numero], '', Formato),
  format(atom(NumeroFormatado), Formato, [Numero]).

% Ordena a lista de artistas de forma decrescente
ordenarArtistas([], Temp, Temp).
ordenarArtistas([H|T], Temp, Sorted) :-
  inserirArtistaOrdenado(H, Temp, [], InseridoH),
  ordenarArtistas(T, InseridoH, Sorted).

inserirArtistaOrdenado(Alvo, [], [], [Alvo]).
inserirArtistaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(5, Alvo, AvaliacaoAlvo),
  nth0(5, H, AvaliacaoH),
  AvaliacaoAlvo < AvaliacaoH,
  append(Temp, [H], Esquerdo),
  inserirArtistaOrdenado(Alvo, T, Esquerdo, Resultado).
inserirArtistaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(5, Alvo, AvaliacaoAlvo),
  nth0(5, H, AvaliacaoH),
  AvaliacaoAlvo >= AvaliacaoH,
  append(Temp, [Alvo], X),
  append(X, [H|T], Resultado).
inserirArtistaOrdenado(Alvo, [], Temp, Resultado):-
  append(Temp, [Alvo], Resultado).

% Ordena a lista de musicas de forma decrescente
ordenarMusicas([], Temp, Temp).
ordenarMusicas([H|T], Temp, Sorted):-
  inserirMusicaOrdenado(H, Temp, [], InseridoH),
  ordenarMusicas(T, InseridoH, Sorted).

inserirMusicaOrdenado(Alvo, [], [] ,[Alvo]).
inserirMusicaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(8, Alvo, AvaliacaoAlvo),
  nth0(8, H, AvaliacaoH),
  AvaliacaoAlvo < AvaliacaoH,
  append(Temp, [H], Esquerdo),
  inserirMusicaOrdenado(Alvo, T, Esquerdo, Resultado).
inserirMusicaOrdenado(Alvo, [H|T], Temp, Resultado):-
  nth0(8, Alvo, AvaliacaoAlvo),
  nth0(8, H, AvaliacaoH),
  AvaliacaoAlvo >= AvaliacaoH,
  append(Temp, [Alvo], X),
  append(X, [H|T], Resultado).
inserirMusicaOrdenado(Alvo, [], Temp, Resultado):-
  append(Temp, [Alvo], Resultado).

inserirDistintos([], Temp, Temp).
inserirDistintos([F|Ft], Temp, Resultado):-
  naoContem(Temp, F),
  append(Temp, [F], NovoTemp),
  inserirDistintos(Ft, NovoTemp, Resultado).
inserirDistintos([_|Ft], Temp, Resultado):- inserirDistintos(Ft, Temp, Resultado).

naoContem([], _):- !.
naoContem([H|T], Alvo):-
  H \= Alvo, naoContem(T, Alvo).

mediaDasMusicas(_, 0, _, 0).
mediaDasMusicas([], Len, Somatorio, Media):- Media is Somatorio/Len.
mediaDasMusicas([H|T], Len, Somatorio, Media):- 
  nth0(8, H, Avaliacao),
  NovoSomatorio is Somatorio+Avaliacao,
  mediaDasMusicas(T, Len, NovoSomatorio, Media).

removerDaLista(_, [], Temp, Temp).
removerDaLista(Alvo, [H|T], Temp, Resultado):-
  upperCase(H, HUpper),
  Alvo == HUpper,
  append(Temp, T, Resultado), !.
removerDaLista(Alvo, [H|T], Temp, Resultado):-
  append(Temp, [H], NovoTemp),
  removerDaLista(Alvo, T, NovoTemp, Resultado).