%%%%%%%%%%%%%%%%%
% Parser implementation (no DCG)
% Grammar (start symbol: Lines)
%
% Lines -> Line ; Lines | Line
% Line  -> Num , Line | Num
% Num   -> Digit | Digit Num
% Digit -> 0 | 1 | ... | 9

% parse/1 succeeds exactly when the input token list matches Lines
parse(X) :-
    lines(X, []).

% lines(Input, Rest): parses one Line then either a semicolon and more Lines or finishes
lines(Input, Rest) :-
    line(Input, R1),
    ( R1 = [';'|R2] -> lines(R2, Rest) ; Rest = R1 ).

% line(Input, Rest): parses a Num then optionally a comma and another Line
line(Input, Rest) :-
    num(Input, R1),
    ( R1 = [','|R2] -> line(R2, Rest) ; Rest = R1 ).

% num(Input, Rest): at least one digit, possibly more
num(Input, Rest) :-
    digit(Input, R1),
    num_tail(R1, Rest).

% num_tail consumes zero or more additional digits
num_tail(Input, Rest) :-
    digit(Input, R1), !,
    num_tail(R1, Rest).
num_tail(Rest, Rest).

% digit(Input, Rest): consumes a single digit token
digit([D|Rest], Rest) :-
    ( D = '0' ; D = '1' ; D = '2' ; D = '3' ; D = '4'
    ; D = '5' ; D = '6' ; D = '7' ; D = '8' ; D = '9' ).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.

%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- ????

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
