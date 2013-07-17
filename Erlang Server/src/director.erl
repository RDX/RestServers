-module(director).
-export([start/0,
          get_version/0,
          get_project_items/0,
          get_all/0,
          get_all_lights/0]).

-include_lib("xmerl/include/xmerl.hrl"). 

start() ->
    dbg:tracer(),
    Pid = spawn(?MODULE, do_stuff, []),
    dbg:p(Pid, r).


get_version() ->
  connect( "<c4soap name=\"GetVersionInfo\" async=\"False\" seq=\"0\"/>\0" ).
  
get_project_items() ->
  connect( "<c4soap name=\"GetProjectItems\" async=\"False\" seq=\"0\"/>\0" ).
  
get_all() ->
  connect( "<c4soap name=\"GetItems\" async=\"False\"><param name=\"filter\" type=\"number\">27</param></c4soap>\0" ).
  
get_all_lights() ->
  connect( "<c4soap name=\"SendToDevice\" async=\"False\" seq=\"97\"><param name=\"iddevice\" type=\"number\">7</param><param name=\"data\" type=\"string\"><devicecommand><command>GET_LIGHT_DEVICES</command><params><param><name>storage</name><value type=\"INT\"><static>1</static></value></param></params></devicecommand></param></c4soap>\0" ).
  
    
connect(Command) ->
    case gen_tcp:connect("10.0.1.14", 5020, [{packet, 0}]) of
        {ok, Socket} ->
            gen_tcp:send(Socket, Command),
            escape(receive_data(Socket,[]));
        Error ->
            io:format("Error connecting to server: ~p~n", [Error])
    end.

receive_data(Socket, SoFar) ->
  receive
    {tcp,Socket,Bin} ->    %% (3)
      case lists:last(Bin) of
        0 ->
          SoFar ++ Bin;
        _ ->
          receive_data(Socket, SoFar ++ Bin)
      end;
      
    {tcp_closed,Socket} -> %% (4)
       SoFar %% (5)
  after 5000 ->
    SoFar %% (5)
  end.

  
%% @spec escape(string() | atom() | binary()) -> binary()
%% @doc Escape a string such that it's safe for XML (amp; lt; gt;).
escape(B) when is_binary(B) ->
    escape(binary_to_list(B), []);
escape(A) when is_atom(A) ->
    escape(atom_to_list(A), []);
escape(S) when is_list(S) ->
    escape(S, []).
    
escape([], Acc) ->
    list_to_binary(lists:reverse(Acc));
escape("&amp;lt;" ++ Rest, Acc) ->
    escape(Rest, lists:reverse("<", Acc));
escape("&amp;gt;" ++ Rest, Acc) ->
    escape(Rest, lists:reverse(">", Acc));
escape("&amp;" ++ Rest, Acc) ->
    escape(Rest, lists:reverse("&", Acc));
escape("&lt;" ++ Rest, Acc) ->
    escape(Rest, lists:reverse("<", Acc));
escape("&gt;" ++ Rest, Acc) ->
    escape(Rest, lists:reverse(">", Acc));

    
    
escape([C | Rest], Acc) ->
    escape(Rest, [C | Acc]).
    
    
    
    