%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(control4_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.  %% debugging code

to_html(ReqData, State) ->
    {"<html><body>Control4</body></html>", ReqData, State}.
