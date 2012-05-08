% SIGTRAN SGW AS supervisor

% (C) 2012 by Harald Welte <laforge@gnumonks.org>
%
% All Rights Reserved
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as
% published by the Free Software Foundation; either version 3 of the
% License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional Permission under GNU AGPL version 3 section 7:
%
% If you modify this Program, or any covered work, by linking or
% combining it with runtime libraries of Erlang/OTP as released by
% Ericsson on http://www.erlang.org (or a modified version of these
% libraries), containing parts covered by the terms of the Erlang Public
% License (http://www.erlang.org/EPLICENSE), the licensors of this
% Program grant you additional permission to convey the resulting work
% without the need to license the runtime libraries of Erlang/OTP under
% the GNU Affero General Public License. Corresponding Source for a
% non-source form of such a combination shall include the source code
% for the parts of the runtime libraries of Erlang/OTP used as well as
% that of the covered work.

-module(sg_as_sup).
-author('Harald Welte <laforge@gnumonks.org>').
-behaviour(supervisor).

-export([init/1, start_link/2]).

-export([get_as_fsm_name/1]).

init([Name, Options]) ->
	AsName = get_as_fsm_name(Name),
	StartArgs = [{local, AsName}, xua_as_fsm, [self()], Options],
	StartFunc = {gen_fsm, start_link, StartArgs},
	ChildSpec = {as_fsm, StartFunc, permanent, 4000, worker, [xua_as_fsm]},

	AspsName = list_to_atom("sg_asp_" ++ Name ++ "_sup"),
	StartFuncASPS = {supervisor, start_link, [{local, AspsName}, sg_asp_sup, [Name, self()]]},
	ChildSpecASPS = {asp_sup, StartFuncASPS, permanent, 4000, worker, [asp_sup]},
	{ok, {{one_for_all, 1, 1}, [ChildSpec, ChildSpecASPS]}}.

start_link(Name, Options) ->
	supervisor:start_link(?MODULE, [Name, Options]).

get_as_fsm_name(Name) ->
	list_to_atom("sg_as_" ++ Name ++ "_fsm").
