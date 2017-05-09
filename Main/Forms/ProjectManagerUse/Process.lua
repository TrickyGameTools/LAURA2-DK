--[[
	LAURA II DK
	Process manager
	
	
	
	(c) Jeroen P. Broks, 2017, All rights reserved
	
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see <http://www.gnu.org/licenses/>.
		
	Exceptions to the standard GNU license are available with Jeroen's written permission given prior 
	to the project the exceptions are needed for.
Version: 17.05.09
]]
POutput = 'KID_TEXTAREA_Output'
PTab=-1
for i=0,MAAN_ItemCount('KID_TABBER_WorkTabber')-1 do
    if MAAN_ItemText('KID_TABBER_WorkTabber',i)=="Output" then PTab=i end
    CSay("Tab found: "..MAAN_ItemText('KID_TABBER_WorkTabber',i).." (on "..i..")")
end
assert(PTab>=0,"There is no output tab")

function PSwitch()
    MAAN_Item('KID_TABBER_WorkTabber',PTab)
    Poll()
end

function PCls(noswitch)
    if not noswitch then PSwitch() end
    MAAN_Text(POutput,"")
    Poll()
end

function Process(cmd,noswitch)
    CSay("Process>"..sval(cmd))
    local bt=io.popen(cmd)
    if not bt then 
       MAAN_Add(POutput,"ERROR: Process could not be created\n\n>>"..sval(cmd))
    end
    for l in bt:lines() do
       MAAN_Add(POutput,l.."\n")
       Poll()
    end
    bt:close()   
end        

-- Since Windows uses DOS Commands in stead of Unix commands, I guess I have to do a few things differently... :(


function PCopy(original,target)
    PSwitch()
    local cmd="cp -v -R '"..original.."' '"..target.."'"
    -- @IF $WINDOWS
    cmd = 'copy "'..original..'" "'..target..'"'
    if IsDir(original) then
       if not MkDir(target,true) then
          MAAN_Add("ERROR: I cannot create directory: "..target.."\n")
          return
       end
       cmd='xcopy /e "'..original..'" "'..target..'"'
    end   
    -- @FI
    Process(cmd)
end
