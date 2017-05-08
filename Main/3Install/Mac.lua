--[[
	LAURA II - Development Kit
	Calls to be made for 3rd party install from Mac
	
	
	
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
Version: 17.05.08
]]
-- content comes later


withstuff = {sox='--with-lame --with-flac --with-libvorbis'}

function unixtype(c)
   local bt = io.popen('type '..c,r)
   local a  = trim(bt:read('*all'))
   local nf = "not found"
   bt:close()
   return right(a,#nf)~=nf
end   
   

function HomeBrew(c,m)
    local iscript = ""
    if not Proceed(m.."\n\nDo you want me to install '"..c.."'?") then return false end
    if not unixtype('brew') then
       if Proceed("In order to install the required software for you I need to install the package manager HomeBrew.\n\nDo you want me to install HomeBrew?") then 
          iscript = "usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\";"
       else
          return false
       end
    end
    iscript = iscript .."brew install "..c.." "..(withstff[c] or "")..";python 'LAURA II - Development Kit/Content/Resources/End.py';exit"
    os.execute("'LAURA II - Development Kit/Content/Resources/OpenTerminal.sh' '"..iscript.."'")         
end

function Installed(c,p,m)
    return unixtype(c) or HomeBrew(p or c,m)        
end


CSay('Mac content ready!')
