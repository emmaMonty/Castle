% First castle for testing
% The castle is a set of room facts of the form
% room(Castle, FromRoom, ToRoom, cost)

room(dunstanburgh, enter, foyer, 1).
room(dunstanburgh, foyer, livingRoom, 1).
room(dunstanburgh, foyer, hall, 2).
room(dunstanburgh, hall, kitchen, 4).
room(dunstanburgh, hall, garage, 3).
room(dunstanburgh, kitchen, exit, 1).

% Second castle for testing
room(windsor, enter, foyer, 1).
room(windsor, foyer, hall, 2).
room(windsor, foyer, dungeon, 1).
room(windsor, hall, throne, 1).
room(windsor, hall, stairs, 4).
room(windsor, stairs, dungeon, 3).
room(windsor, throne, stairs, 1).
room(windsor, dungeon, escape, 5).
room(windsor, escape, exit, 1).

% Third castle for testing
room(alnwick, enter, foyer, 1).
room(alnwick, foyer, hall, 2).
room(alnwick, hall, throne, 1).
room(alnwick, hall, stairs, 4).
room(alnwick, stairs, dungeon, 3).
room(alnwick, dungeon, foundry, 5).
room(alnwick, foyer, passage, 1).
room(alnwick, passage, foundry, 1).
room(alnwick, foundry, exit, 4).

%helper code that generates permutations
%https://stackoverflow.com/questions/9134380/how-to-access-list-permutations-in-prolog
takeout(X, [X|R], R).
takeout(X,[F |R], [F|S]) :-
    takeout(X,R,S).

%permutations function
perm([X|Y],Z):-
    perm(Y,W),
    takeout(X,Z,W).
perm([],[]).

%solveRooms(Castle, Rooms)
solveRooms(_,[]).
solveRooms(Castle,Rooms):-
    solveRoom(Castle,Rooms,Path),
    printList(Path).

%helper function
solveRoom(_, [],[]).
solveRoom(Castle, Rooms,Path):-
    perm(Rooms, PermutedRooms),
    findTour(Castle, enter, PermutedRooms,Path).

solveRoomsWithinCost(Castle, Cost):-
    solveRoom(Castle, [enter], Path),
    pathCost(Castle, Path, PathCost),
    PathCost =< Cost,
    write("Cost is"),
    write(PathCost),
    write("with limit"),
    writeln(Cost),
    printList(Path).

pathCost(_,[],1).
pathCost(Castle, [FirstRoom | RestRoom], Total):-
    RestRoom = [SecondRoom | _ ],
    room(Castle,FirstRoom,SecondRoom, RoomCost),
    pathCost(Castle, RestRoom, RestCost),
    Total is RoomCost + RestCost.

%findTour(Castle, AtRoom, Rooms)
findTour(Castle, AtRoom, [], PathAtExit):-
    reachable(Castle, AtRoom, exit, PathAtExit).

findTour(Castle, AtRoom, [OneRoom | RestRooms], Path):-
    reachable(Castle, AtRoom, OneRoom, PathAtOne),
    findTour(Castle, OneRoom, RestRooms, PathRest),
    append(PathAtOne, PathRest, Path).

%this is the print function
printList([]).
printList([F | R]):- 
    writeln(F), 
    printList(R).

%True if there is a path from to to
%reachable(Castle, FromRoom, ToRoom)
reachable(_,Room, Room, []).
reachable(Castle, FromRoom, ToRoom,[FromRoom | PathNextTo]):-
	room(Castle, FromRoom, NextRoom, _),
    reachable(Castle, NextRoom, ToRoom, PathNextTo).
