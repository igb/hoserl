-module(hoserl).
-export([start/0]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.



start()->
	{ok,[[ConsumerKey]]}=init:get_argument(consumer_key),
	{ok,[[ConsumerSecret]]}=init:get_argument(consumer_secret),
	{ok,[[AccessToken]]}=init:get_argument(access_token),
        {ok,[[AccessTokenSecret]]}=init:get_argument(access_token_secret),
	connect(ConsumerKey, ConsumerSecret, AccessToken, AccessTokenSecret).



%





connect(ConsumerKey, ConsumerSecret, AccessToken, AccessTokenSecret)->
	Consumer = {ConsumerKey, ConsumerSecret, hmac_sha1},
	Url="https://stream.twitter.com/1.1/statuses/sample.json",
	httpc:request(get, {Url, [{"Authorization", lists:append("OAuth ", oauth:header_params_encode(oauth:sign("GET", Url, [], Consumer, AccessToken, AccessTokenSecret)))}, {"Accept", "*/*"}, {"Host","stream.twitter.com"}]}, [], [{headers_as_is, true}, {stream, self}, {sync, false}]),
	handle(),
				
	ok.

handle()->
	receive
		 {http, {RequestId, stream_start, Headers}} ->
		  	io:format("~p~n~n", [stream_start]);
		 {http, {RequestId, stream, BinBodyPart}} ->
		 	io:format("~p", [BinBodyPart]);
		{http, {RequestId, stream_end, Headers}} ->
		       io:format("~p~n~n", [stream_end])
        end,
	handle().


-ifdef(TEST).

-endif.