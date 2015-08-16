%% SameGame solver by Prolog

%% +-+-+-+    +-+-+-+    +-+-+-+    +-+-+-+
%% |g|b|r|    | | |r|    | | | |    | | | |
%% +-+-+-+    +-+-+-+    +-+-+-+    +-+-+-+
%% |g|g|r| -> | |b|r| -> | |r| | -> | | | |
%% +-+-+-+    +-+-+-+    +-+-+-+    +-+-+-+
%% |r|b|b|    |r|b|b|    |r|r| |    | | | |
%% +-+-+-+    +-+-+-+    +-+-+-+    +-+-+-+

%% r ... red
%% g ... green
%% b ... blue

%% 上記のボードの定義
board([[g,b,r],
       [g,g,r],
       [r,b,b]]).

%% ボードの並び順を解きやすいように変換する
%%
%% ?- board(B), convert_board(B, R).
%% B = [[g, b, r], [g, g, r], [r, b, b]],
%% R = [[r, g, g], [b, g, b], [b, r, r]].
%%
convert_board(Board, Converted) :-
  reverse(Board, Reversed),       %% 逆順にして
  transpose(Reversed, Converted). %% 行列を入れ替える

%% 行列を入れ替える
transpose(Board, [HeadRow|TailTransposed]) :-
  headline(Board, HeadRow, TailBoard),
  transpose(TailBoard, TailTransposed), !.
transpose([[]|_], []).

%% 各行の先頭列を集める
headline([Row|Remain], [H|RemainHeadRow], [T|RemainTailBoard]) :-
  [H|T] = Row,
  headline(Remain, RemainHeadRow, RemainTailBoard).
headline([], [], []).

%% 位置を指定してコマを取得する
piece(Board, X, Y, P) :-
  nth0(Y, Board, Xs),
  nth0(X, Xs, P).

%% 左側に同じコマがあるかチェック
neighbor(l, Board, X, Y, Crumb, Neighbor) :-
  X1 is X - 1,
  not(member((X1,Y), Crumb)),
  piece(Board, X, Y, P),
  piece(Board, X1, Y, P),
  neighbor(Board, X1, Y, [(X1,Y)|Crumb], Neighbor).

%% 右側に同じコマがあるかチェック
neighbor(r, Board, X, Y, Crumb, Neighbor) :-
  X1 is X + 1,
  not(member((X1,Y), Crumb)),
  piece(Board, X, Y, P),
  piece(Board, X1, Y, P),
  neighbor(Board, X1, Y, [(X1,Y)|Crumb], Neighbor).

%% 上側に同じコマがあるかチェック
neighbor(u, Board, X, Y, Crumb, Neighbor) :-
  Y1 is Y - 1,
  not(member((X,Y1), Crumb)),
  piece(Board, X, Y, P),
  piece(Board, X, Y1, P),
  neighbor(Board, X, Y1, [(X,Y1)|Crumb], Neighbor).

%% 下側に同じコマがあるかチェック
neighbor(d, Board, X, Y, Crumb, Neighbor) :-
  Y1 is Y + 1,
  not(member((X,Y1), Crumb)),
  piece(Board, X, Y, P),
  piece(Board, X, Y1, P),
  neighbor(Board, X, Y1, [(X,Y1)|Crumb], Neighbor).

%% ボードをはみ出た場合はそこで再帰終了
neighbor(_, _, _, _, Neighbor, Neighbor).

%% 上下左右に同じコマがあるか再帰チェック
neighbor(Board, X, Y, Crumb, Neighbor) :-
  neighbor(l, Board, X, Y, Crumb, Crumb1),
  neighbor(r, Board, X, Y, Crumb1, Crumb2),
  neighbor(u, Board, X, Y, Crumb2, Crumb3),
  neighbor(d, Board, X, Y, Crumb3, Neighbor).
