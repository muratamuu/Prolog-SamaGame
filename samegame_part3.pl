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

