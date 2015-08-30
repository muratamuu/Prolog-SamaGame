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

%%
%% 上下左右に同じコマがあるか再帰チェックして隣接コマを見つけ出す
%%
neighbor(Board, X, Y, Crumb, Neighbor) :-
  neighbor(l, Board, X, Y, Crumb, Crumb1),
  neighbor(r, Board, X, Y, Crumb1, Crumb2),
  neighbor(u, Board, X, Y, Crumb2, Crumb3),
  neighbor(d, Board, X, Y, Crumb3, Neighbor), !.

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

%%
%% 盤面上のコマの位置リストを作る
%%
poslist(Board, PosList) :-
  poslist(Board, 0, PosList).

%% Y座標を増やしながらリストを作る
poslist([H|T], Y, PosList) :-
  poslist(H, 0, Y, PosList1),
  Y1 is Y + 1,
  poslist(T, Y1, PosList2),
  append(PosList1, PosList2, PosList).
poslist([], _, []).

%% X座標を増やしながらリストを作る
poslist([_|T], X, Y, [(X,Y)|PosList]) :-
  X1 is X + 1,
  poslist(T, X1, Y, PosList).
poslist([], _, _, []).

%%
%% 盤面からコマを削除する
%%
remove(Board, DeleteList, RemovedBoard) :-
  remove(Board, DeleteList, 0, RemovedBoard1),
  delete(RemovedBoard1, [], RemovedBoard).

%% Y座標をインクリメントしながら指定コマを削除する
remove([Line|TailBoard], DeleteList, Y, [RemovedLine|RemovedBoard]) :-
  %% 行の中の削除対象コマを削除する
  remove(Line, DeleteList, 0, Y, RemovedLine),
  Y1 is Y + 1,
  remove(TailBoard, DeleteList, Y1, RemovedBoard). %% 次の行へ
remove([], _, _, []). %% ボード終端にマッチする番兵

%% 指定されたXY座標のコマを消したリストを返す
remove([_|T], DeleteList, X, Y, RemovedLine) :-
  member((X,Y), DeleteList), %% 削除リストに含まれる
  X1 is X + 1,
  remove(T, DeleteList, X1, Y, RemovedLine).

%% 指定されたXY座標のコマ(H)を残したリストを返す
remove([H|T], DeleteList, X, Y, [H|RemovedLine]) :-
  not(member((X,Y), DeleteList)), %% 削除リストに含まれない
  X1 is X + 1,
  remove(T, DeleteList, X1, Y, RemovedLine).

remove([], _, _, _, []). %% 行末[]にマッチする番兵

