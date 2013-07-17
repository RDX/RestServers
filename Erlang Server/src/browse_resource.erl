%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(browse_resource).
-export([init/1, 
		 content_types_provided/2,
		 to_json/2,
		 to_html/2,
		 allowed_methods/2,
		 is_authorized/2, 
		 expires/2]).
		 
-include_lib("kernel/include/file.hrl").
-include_lib("webmachine/include/webmachine.hrl").

init(Config) ->
   {{trace, "/tmp"}, Config}.
   
content_types_provided(RD, Ctx) ->
    {[{"application/json", to_json}], RD, Ctx}.

to_html(ReqData, State) ->
	Path = wrq:disp_path(ReqData),
	Sub_Path = get_sub_folders(Path),
	{Sub_Path, ReqData, State}.

allowed_methods(ReqData, Context) ->
    {['GET'], ReqData, Context}.
    
to_json(ReqData, Result) ->
	Path = wrq:disp_path(ReqData),
	Sub_Path = get_sub_folders("/" ++ Path),
    {mochijson2:encode({struct, [{directories, Sub_Path }] }), ReqData, Result}.
    
get_sub_folders(Path) ->
	DirFilter = fun(X) -> filelib:is_dir(X) end,
	ToBinary = fun(X) ->
				Label = filename:basename(X),
				{struct,
					[{label,list_to_binary(Label)},
					{path,list_to_binary(X)}]
				} end,
	All_Sub_Folders = lists:filter(DirFilter, filelib:wildcard(Path ++ "/*")),
	lists:map(ToBinary, All_Sub_Folders).
	
is_authorized(ReqData, Context) ->

    case wrq:get_req_header("authorization", ReqData) of
        "Basic "++Base64 ->
            Str = base64:mime_decode_to_string(Base64),
            case string:tokens(Str, ":") of
                ["authdemo", "demo1"] ->
                    {true, ReqData, Context};
                _ ->
                    {"Basic realm=webmachine", ReqData, Context}
            end;
        _ ->
            {"Basic realm=webmachine", ReqData, Context}
    end.


expires(ReqData, Context) -> {{{2010,1,1},{0,0,0}}, ReqData, Context}.