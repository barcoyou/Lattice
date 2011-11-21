%% @author Barco You <barcojie@gmail.com>
%% @copyright 2011 Barco You
%%
%%    Licensed under the Apache License, Version 2.0 (the "License");
%%    you may not use this file except in compliance with the License.
%%    You may obtain a copy of the License at
%%
%%        http://www.apache.org/licenses/LICENSE-2.0
%%
%%    Unless required by applicable law or agreed to in writing, software
%%    distributed under the License is distributed on an "AS IS" BASIS,
%%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%    See the License for the specific language governing permissions and
%%    limitations under the License.

-module(lattice_path).
-author('Barco You <barcojie@gmail.com>').
-export([build/1,
		get_number_path/2,
	    get_number_path/3]).

%% @spec build(Dimensions::list()) -> list()
%% @doc Build a lattice with input as dimensions and the lattice point holding
%%      the value of the number of paths passing it from the origin.
%%      For the algorithm, please refer to http://mathworld.wolfram.com/LatticePath.html
build([]) -> 
	[];
build([H|T]) ->
	build([H|T], []).

%% @spec get_number_path(Index::list(), Lattice::list()) -> integer()
%% @doc Return the number of paths across the point at Index from the
%%      origin [0,0,0 ..] of the Lattice.
get_number_path([], _Lattice) ->
	0;
get_number_path([H|[]], Lattice) ->
	lists:nth(H+1, Lattice);
get_number_path([H|T], Lattice) ->
	get_number_path(T, lists:nth(H+1,Lattice)).

%% @spec get_number_path(Index1::list(), Index2::list(), Lattice::list()) -> integer()
%% @doc Return the number of paths across the point at Index2 from the point at 
%%      Index2 of the Lattice.
get_number_path([], [], _Lattice) ->
	0;
get_number_path([], Index, Lattice) when is_list(Index) ->
	get_number_path(Index, Lattice);
get_number_path(Index1, Index2, Lattice) when is_list(Index1) and is_list(Index2) ->
	Index = map(fun(X, Y) -> Y-Xzend, Index1, Index2),
	get_number_path(Index, Lattice).

%% Internal functions
build([H|[]], D) ->
	build_innerlist(H, D, []);
build([H|T], D) ->
	Bu = fun(X) -> build(T, [X|D]) end,
	build_outterlist(H, Bu, []).

build_innerlist(0, _D, L) ->
	L;
build_innerlist(N, D, L) when N > 0 ->
	build_innerlist(N-1, D, [factorial(N-1+lists:sum(D)-length(D))/lists:foldl(fun(E,A) -> A*factorial(E-1) end, factorial(N-1), D) | L]).

build_outterlist(0, _X, L) ->
	L;
build_outterlist(N, X, L) when N > 0 ->
	build_outterlist(N-1, X, [X(N)|L]).

factorial(0) ->
	1;
factorial(N) when N > 0 ->
	factorial(N,1).

factorial(0, V) -> 
	V;
factorial(N, V) ->
	factorial(N-1, N*V).

map(_Fun, [], []) ->
	[];
map(Fun, List1, List2) ->
	map(Fun, List1, List2, []).

map(_Fun, [], [], L) -> 
	lists:reverse(L);
map(Fun, [H1|T1], [H2|T2], L) ->
	map(Fun, T1, T2, [Fun(H1,H2)|L]).
