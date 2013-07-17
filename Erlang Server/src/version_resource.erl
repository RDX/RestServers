%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(version_resource).
-export([init/1, 
		 content_types_provided/2,
		 to_json/2,
		 allowed_methods/2]).

-include_lib("webmachine/include/webmachine.hrl").
-include_lib("xmerl/include/xmerl.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.  %% debugging code

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
  Path = wrq:disp_path(ReqData),
  io:format(Path),
  {[{"application/json", to_json}], ReqData, Context}.

to_html(ReqData, State) ->
	Data = director:get_version(),
	{Data, ReqData, State}.
    
to_json(ReqData, Result) ->
	Data = director:get_version(),
	DecodedData = parse_xml_version(Data),
    {mochijson2:encode({struct, [DecodedData] }), ReqData, Result}.

parse_xml_version( Data ) ->

  { Xml, _Rest } = xmerl_scan:string(binary_to_list(Data)),
  [ #xmlText{value=Rank} ]  = xmerl_xpath:string("//SalesRank/text()", Xml),
  [ #xmlText{value=Title} ] = xmerl_xpath:string("//Title/text()", Xml),
  { Title, Rank }.