%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(all_devices_resource).
-export([init/1, 
		 content_types_provided/2,
		 to_html/2,
		 allowed_methods/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.  %% debugging code

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
  {[{"text/html", to_html}], ReqData, Context}.

to_html(ReqData, State) ->
	{director:get_all(), ReqData, State}.
