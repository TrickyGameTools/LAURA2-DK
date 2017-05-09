--[[
	LAURA II - DK
	Content manager
	
	
	
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
MyDir = ""

AudioImport = {  allow='ogg', ConvertQuestion='The only supported format for audio is OGG Vorbis.\nWith the help of SOX I can try to convert this file into OGG Vorbis.',command="sox <original> <target>",packagename='SOX',codename='sox'}

ImportConvert = { AUDIO=AudioImport,
                  MUSIC=AudioImport,
                  VOCALS=AudioImport,
                  FONTS={allow='ttf',ConvertQuestion='The only allowed format for fonts is TrueTypeFont (TTF)\nUnfortunately I don\'t know a tool to do this automatically for you'},
                  GFX={allow='png',ConvertQuestion='The only supported format for graphics or images is the Portable Network Graphic (PNG)\n\nI can use ImageMagick in order to convert this file to the correct format',command='convert <original> <target>',packagename='ImageMagick',codename='imagemagick'},
                  KTHURA={block='Kthura maps cannot be imported. Just create a new map'},                  
                }

function AllowedFileName(f)
    local allow='1234567890-_qwertyuiopasdfghjklzxcvbnm QWERTYUIOPASDFGHJKLZXCVBNM'
    local ret,charcheck = true,false
    if left(f,1)==" " and right(f,1)==" " then return false end
    for i=1,#f do charcheck=false for ai=1,#allow do
        charcheck = charcheck or mid(f,i,1)==mid(allow,ai,1)
    end ret = ret and charcheck end
    return ret
end

function CurContentDir()
  local root=MAAN_ItemText('KID_LISTBOX_ContentRoot')
  local ret =  project.dir.."/JCR/"..root
  if MyDir~="" then ret = ret .."/"..MyDir end
  return ret
end

function ContentReadDir()
    local dir=DirList(CurContentDir())
    CSay('Reading dir:'..sval(dir))
    if not dir then alert('trying to read a dir without success -- '..CurContentDir()) return end
    MAAN_Clear('KID_LISTBOX_ContentFile')
    if MyDir~="" then MAAN_Add('KID_LISTBOX_ContentFile',"../") end
    for f in each(dir) do
        if IsDir(CurContentDir().."/"..f) then 
            MAAN_Add('KID_LISTBOX_ContentFile',f.."/")
        else    
            MAAN_Add('KID_LISTBOX_ContentFile',f)
        end
    end    
    MAAN_Text('KID_LABEL_ContPwd',MAAN_ItemText('KID_LISTBOX_ContentRoot')..":/"..MyDir)
end        

-- Root Selector
MAAN_Hide('KID_PANEL_ContentWorkPanel')

function RootSelector()
    local r='KID_LISTBOX_ContentRoot'
    local f='KID_LISTBOX_ContentFile'
    local p='KID_PANEL_ContentWorkPanel'
    local i=MAAN_Item(r)
    MAAN_SetVisible(p,i>=0)
    if i>=0 then
       MyDir=""
       ContentReadDir()
    end   
end

KID_LISTBOX_ContentRoot_SelectSingle=RootSelector
KID_LISTBOX_ContentRoot_SelectDouble=RootSelector


-- Import

function PerformImport(file,tgt)
    local root=MAAN_ItemText('KID_LISTBOX_ContentRoot')
    local c=ImportConvert[root]
    if c then
       if c.block then alert(c.block) return end
    else
       PCopy(file,CurContentDir().."/"..tgt) 
    end
end

function KID_BUTTON_ImportFileGo_Action()
     Installed = Installed or function() return false end
     PCls()
     local root=MAAN_ItemText('KID_LISTBOX_ContentRoot')
     local f=MAAN_Text('KID_TEXTFIELD_ImportFileName')
     local tgt=root..":/"..MyDir
     MAAN_Add(POutput,"Importing '"..f.."' to '"..tgt.."'\n\n")
     if IsDir(f) then
        if not Proceed(f.." is a directory.\nShould I try to import all files inside of it?") then return end
        --local tree=DirTree(f)
        --for entry in each(tree) do PerformImport(f.."/"..entry,ExtractDir(entry)) end
        PerformImport(f,"")
     elseif IsFile(f) then
        PerformImport(f,"")
     else
        alert("I cannot handle "..f.."\nDoes it actually exist?")
     end         
     MAAN_Add(POutput,"\n\nOperation completed")
end

function KID_BUTTON_ImportFileBrowse_Action()
   local f=RequestFile('What file should I import?')
   if f~="" then MAAN_Text('KID_TEXTFIELD_ImportFileName',f) end
end

-- File selector

function KID_LISTBOX_ContentFile_SelectDouble() -- Yeah... Only double counts this time :)
     CSay('File content double-clicked')
     local i=MAAN_Item('KID_LISTBOX_ContentFile'); if i<0 then return end
     local f=MAAN_ItemText('KID_LISTBOX_ContentFile')
     CSay(serialize('local f',f))
     if f=="../" then                 -- Parent
        CSay("Go to parent directory")
        local s=mysplit(MyDir,"/")
        local l=#s
        local n=""
        if l>1 then
           for i=1,l-1 do
               if i>1 then n=n.."/" end
               n = n .. s[i]
           end
        end
        MyDir = n
        ContentReadDir()
        return       
     elseif right(f,1)=="/" then      -- Change dir
        CSay("Go to dir: "..f)
        if MyDir~="" then MyDir = MyDir .. "/" end
        MyDir = MyDir .. left(f,#f-1) -- No slash
        ContentReadDir()
        return               
     else                             -- File
     end
end


-- Create Directory

function KID_BUTTON_CreateDir_Action()
   local f=trim(MAAN_Text('KID_TEXTFIELD_ContMkDir'))
   local root=MAAN_ItemText('KID_LISTBOX_ContentRoot'); if root=="" then return end   
   if f=="" then return end
   if not AllowedFileName(f) then return alert('Sorry!~nOnly numbers, Roman letters without accent marks/umlauts, the mark, underscore, and spaces allowed in directory names.') end
   CSay('Creating: '..CurContentDir().."/"..f)
   if not MkDir(CurContentDir().."/"..f) then alert('Creating directory "'..f.."' failed.") end
   ContentReadDir()
end   
