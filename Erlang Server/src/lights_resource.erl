%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(lights_resource).
-export([init/1, 
		 content_types_provided/2,
		 to_json/2,
		 allowed_methods/2,
		 parse_xml_version/1]).

-include_lib("webmachine/include/webmachine.hrl").
-include_lib("xmerl/include/xmerl.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.  %% debugging code

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
%  {[{"text/html", to_html},{"application/json", to_json}], ReqData, Context}.
  {[{"application/json", to_json}], ReqData, Context}.


%to_html(ReqData, State) ->
%	{director:get_all_lights(), ReqData, State}.
	
to_json(ReqData, Result) ->
	Data = director:get_all_lights(),
	DecodedData = parse_xml_version(Data),
    {mochijson2:encode({struct, [{ids, DecodedData}]}), ReqData, Result}.
    
parse_xml_version( Data ) ->

  { Xml, _Rest } = xmerl_scan:string(binary_to_list(Data)),
  XmlTexts  = xmerl_xpath:string("/c4soap/sources/source/id/text()", Xml),
  [list_to_binary(X#xmlText.value) || X <- XmlTexts, is_record(X, xmlText)].
  