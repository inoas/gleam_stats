-module(gleam@int).
-compile(no_auto_import).

-export([absolute_value/1, parse/1, to_string/1, to_base_string/2, to_base2/1, to_base8/1, to_base16/1, to_base36/1, to_float/1, clamp/3, compare/2, min/2, max/2, is_even/1, is_odd/1, negate/1, sum/1, product/1, digits/2, undigits/2, random/2]).
-export_type([invalid_base/0]).

-type invalid_base() :: invalid_base.

-spec absolute_value(integer()) -> integer().
absolute_value(Num) ->
    case Num >= 0 of
        true ->
            Num;

        false ->
            Num * -1
    end.

-spec parse(binary()) -> {ok, integer()} | {error, nil}.
parse(String) ->
    gleam_stdlib:parse_int(String).

-spec to_string(integer()) -> binary().
to_string(Int) ->
    erlang:integer_to_binary(Int).

-spec to_base_string(integer(), integer()) -> {ok, binary()} |
    {error, invalid_base()}.
to_base_string(Int, Base) ->
    case (Base >= 2) andalso (Base =< 36) of
        true ->
            {ok, erlang:integer_to_binary(Int, Base)};

        false ->
            {error, invalid_base}
    end.

-spec to_base2(integer()) -> binary().
to_base2(Int) ->
    erlang:integer_to_binary(Int, 2).

-spec to_base8(integer()) -> binary().
to_base8(Int) ->
    erlang:integer_to_binary(Int, 8).

-spec to_base16(integer()) -> binary().
to_base16(Int) ->
    erlang:integer_to_binary(Int, 16).

-spec to_base36(integer()) -> binary().
to_base36(Int) ->
    erlang:integer_to_binary(Int, 36).

-spec to_float(integer()) -> float().
to_float(Int) ->
    erlang:float(Int).

-spec clamp(integer(), integer(), integer()) -> integer().
clamp(N, Min_bound, Max_bound) ->
    _pipe = N,
    _pipe@1 = min(_pipe, Max_bound),
    max(_pipe@1, Min_bound).

-spec compare(integer(), integer()) -> gleam@order:order().
compare(A, B) ->
    case A =:= B of
        true ->
            eq;

        false ->
            case A < B of
                true ->
                    lt;

                false ->
                    gt
            end
    end.

-spec min(integer(), integer()) -> integer().
min(A, B) ->
    case A < B of
        true ->
            A;

        false ->
            B
    end.

-spec max(integer(), integer()) -> integer().
max(A, B) ->
    case A > B of
        true ->
            A;

        false ->
            B
    end.

-spec is_even(integer()) -> boolean().
is_even(X) ->
    (X rem 2) =:= 0.

-spec is_odd(integer()) -> boolean().
is_odd(X) ->
    (X rem 2) /= 0.

-spec negate(integer()) -> integer().
negate(X) ->
    -1 * X.

-spec sum(list(integer())) -> integer().
sum(Numbers) ->
    _pipe = Numbers,
    do_sum(_pipe, 0).

-spec do_sum(list(integer()), integer()) -> integer().
do_sum(Numbers, Initial) ->
    case Numbers of
        [] ->
            Initial;

        [X | Rest] ->
            do_sum(Rest, X + Initial)
    end.

-spec product(list(integer())) -> integer().
product(Numbers) ->
    case Numbers of
        [] ->
            0;

        _@1 ->
            do_product(Numbers, 1)
    end.

-spec do_product(list(integer()), integer()) -> integer().
do_product(Numbers, Initial) ->
    case Numbers of
        [] ->
            Initial;

        [X | Rest] ->
            do_product(Rest, X * Initial)
    end.

-spec digits(integer(), integer()) -> {ok, list(integer())} |
    {error, invalid_base()}.
digits(Number, Base) ->
    case Base < 2 of
        true ->
            {error, invalid_base};

        false ->
            {ok, do_digits(Number, Base, [])}
    end.

-spec do_digits(integer(), integer(), list(integer())) -> list(integer()).
do_digits(Number, Base, Acc) ->
    case absolute_value(Number) < Base of
        true ->
            [Number | Acc];

        false ->
            do_digits(case Base of
                    0 -> 0;
                    Gleam@denominator -> Number div Gleam@denominator
                end, Base, [case Base of
                                0 -> 0;
                                Gleam@denominator@1 -> Number rem Gleam@denominator@1
                            end | Acc])
    end.

-spec undigits(list(integer()), integer()) -> {ok, integer()} |
    {error, invalid_base()}.
undigits(Numbers, Base) ->
    case Base < 2 of
        true ->
            {error, invalid_base};

        false ->
            do_undigits(Numbers, Base, 0)
    end.

-spec do_undigits(list(integer()), integer(), integer()) -> {ok, integer()} |
    {error, invalid_base()}.
do_undigits(Numbers, Base, Acc) ->
    case Numbers of
        [] ->
            {ok, Acc};

        [Digit | _@1] when Digit >= Base ->
            {error, invalid_base};

        [Digit@1 | Rest] ->
            do_undigits(Rest, Base, (Acc * Base) + Digit@1)
    end.

-spec random(integer(), integer()) -> integer().
random(Boundary_a, Boundary_b) ->
    {Min, Max} = case {Boundary_a, Boundary_b} of
        {A, B} when A =< B ->
            {A, B};

        {A@1, B@1} when A@1 > B@1 ->
            {B@1, A@1}
    end,
    Min@1 = begin
        _pipe = to_float(Min),
        gleam@float:ceiling(_pipe)
    end,
    Max@1 = begin
        _pipe@1 = to_float(Max),
        gleam@float:floor(_pipe@1)
    end,
    _pipe@2 = gleam@float:random(Min@1, Max@1),
    _pipe@3 = gleam@float:floor(_pipe@2),
    gleam@float:round(_pipe@3).
