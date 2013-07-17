%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(login_resource).
-export([init/1, 
		to_html/2, 
		to_text/2, 
		content_types_provided/2]).
		 
-include_lib("webmachine/include/webmachine.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.
   
content_types_provided(ReqData, Context) ->
    {[{"text/html", to_html},{"text/plain",to_text}], ReqData, Context}.

to_text(ReqData, Context) ->
    Path = wrq:disp_path(ReqData),
    Body = io_lib:format("Hello ~s from webmachine.~n", [Path]),
    {Body, ReqData, Context}.
    
to_html(ReqData, Context) ->
    {Body, _RD, Ctx2} = to_text(ReqData, Context),
    HBody = io_lib:format("<html><body>~s</body></html>~n",
                          [erlang:iolist_to_binary(Body)]),
    {HBody, ReqData, Ctx2}.