% Search implementation: breadth-first search over (room, keys) states
% Produces the shortest list of moves Actions (as move(From,To)) to reach a room
% containing the treasure.

% Entry point
search(Actions) :-
initial(Init),
% collect any keys at the starting room
keys_at_room(Init, Ks0), sort(Ks0, KsStart),
bfs([state(Init, KsStart, [])], [], Actions).

% BFS over a queue of state(Room, Keys, PathSoFar)
bfs([state(Room, _Keys, Path)|_], _Visited, Path) :-
treasure(Room), !.

bfs([state(Room, Keys, Path)|RestQueue], Visited, Actions) :-
pair(Room, Keys, Rep),
( member(Rep, Visited) ->
bfs(RestQueue, Visited, Actions)
;
% generate successors
findall(state(NRoom, NKeys, Path2),
( neighbor(Room, NRoom, Lock),
  ( Lock == none -> true ; member(Lock, Keys) ),
  keys_at_room(NRoom, NewKeysHere),
  append(NewKeysHere, Keys, TempKeys), sort(TempKeys, NKeys),
  \+ seen_in_list(state(NRoom, NKeys, _), RestQueue, Visited),
  append(Path, [move(Room, NRoom)], Path2)
),
Succs),
append(RestQueue, Succs, Queue2),
bfs(Queue2, [Rep|Visited], Actions)
).

% neighbor(Room, NextRoom, LockColorOrNone)
% includes both unlocked doors and locked_door facts (undirected)
neighbor(A,B, none) :- ( door(A,B) ; door(B,A) ), \+ locked_door(A,B, _), \+ locked_door(B,A, _).
neighbor(A,B, Color) :- locked_door(A,B, Color).
neighbor(A,B, Color) :- locked_door(B,A, Color).

% collect keys (possibly zero or more) at a room
keys_at_room(Room, Ks) :- findall(C, key(Room, C), Ks).

% helper to represent visited pair (Room,Keys)
pair(Room, Keys, Room-Keys).

% check if a state with same Room and Keys is already in queue or visited
seen_in_list(state(R,K,_), Queue, Visited) :-
pair(R,K,Rep), ( member(Rep, Visited) ; list_has_pair(Queue, Rep) ).

list_has_pair([state(R,K,_)|_], Rep) :- pair(R,K,Rep), !.
list_has_pair([_|T], Rep) :- list_has_pair(T, Rep).
