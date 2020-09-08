#!/usr/bin/env wsapi.cgi

module(..., package.seeall)

local util = require"wsapi.util"
local auth = require"wsapi.basic_auth"

function my_run(wsapi_env)
  local headers = { ["Content-type"] = "text/plain" }

	local function table_tostring(tbl,pre)
		local buf = ""
		local function tbl_helper(t, prefix)
			local k,v
			if prefix == nil then prefix = " " end
			for k,v in pairs(t) do
				if type(v) == "table" then 
					tbl_helper(v," "..prefix..k..".")
				else
					if type(v) == "function" then v = "(function)" end
					buf = buf .. prefix..k.."= "..v.."\n" 
				end
			end
		end
		tbl_helper(tbl, pre)
		return buf
	end
  
  local function handler()
	coroutine.yield(table_tostring(wsapi_env))
  end
  return 200, headers, coroutine.wrap(handler)
end

function my_check_user_pass(user, pass)
	return user=="test1" and pass=="test2"
end

function run(wsapi_env)
  return auth.run(wsapi_env, "my site", my_run, my_check_user_pass)
end
