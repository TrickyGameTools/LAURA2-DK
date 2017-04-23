--[[
	LAURA II - Development Kit
	Form Script - Project Manager
	
	
	
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
Version: 17.04.22
]]

-- @USEDIR Forms/ProjectManagerUse

-- projectlist = MAAN_LoadVar("ProjectList.lua") or {}



-- Project manager

function FORM_ProjectManager_Close()
     MAAN_SaveVar(projectlist,"ProjectList.lua")
     os.exit()
end     


function OwnDirAllowed(destroy)
	MAAN_Enabled('KID_TEXTFIELD_ProjectCreateDir',MAAN_Checked('KID_RADIO_CreateIn#CustomDir'))
	-- --[[
	if MAAN_Checked('KID_RADIO_CreateIn#DefaultDir') then
		MAAN_Text('KID_TEXTFIELD_ProjectCreateDir',"$MyDocs$/LAURA2Projects/"..MAAN_Text('KID_TEXTFIELD_Title'))
	elseif destroy then
		MAAN_Text('KID_TEXTFIELD_ProjectCreateDir',"")
	end
	-- ]]
end; OwnDirAllowed()

function KID_RADIO_CreateIn_Action(idx)
	OwnDirAllowed(true)
end	

function KID_TEXTFIELD_Title_Action(idx)
	OwnDirAllowed()
end	

function KID_BUTTON_CreateProject_Action()
   local title = MAAN_Text('KID_TEXTFIELD_Title'):gsub("^%s*(.-)%s*$", "%1")
   -- If there is no title at all then no go!
   if title=="" then return alert("Sorry, I do need a title before I can create a project for you!") end
   -- Let's now see if the name can be allowed
   local allowed = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM 1234567890_-"
   allowstring = true  
   for i1=1,len(title) do
       allowchar = false 
       for i2=1,len(allowed) do
            allowchar = allowchar or (title:sub(i1,i1)==allowed:sub(i2,i2))
       end
       allowstring = allowstring and allowchar
   end
   if not allowstring then return alert("Sorry!\nI cannot accept that title.\nI only allow roman letters WITHOUT accepts or umlauts, spaces, numbers, dashes and underscores") end
   -- And now for the output dir
   local outdir = Dirry(MAAN_Text('KID_TEXTFIELD_ProjectCreateDir'):gsub("^%s*(.-)%s*$", "%1"))
   if outdir=="" then return alert("No output dir given") end
   if IsFile(outdir) then return alert("I'm afraid '"..outdir.."' is a file, and thus I cannot create a project on that location. You'll have to change that name") end
   if IsDir(outdir) then
      local IsProject = true
      IsProject = IsProject and IsFile(outdir.."/L2DKProject.lua")
      IsProject = IsProject and IsDir(outdir.."/JCR")
      if not IsProject then return alert("Sorry!\nIt seems this is an existing directory, and I don't know for what it's used, but it's not recognized as a valid LAURA II DK project.\nIf you really want to use that directory name, rename or remove the existing folder first and try it again") end
      if not Proceed("A directory named '"..outdir.."' has been found.\nI cannot create a new project here, but at least I can adopt this project if it was not yet in the project list\n\nDo you want me to?") then return end
      for pn,pdata in pairs(projectlist) do
          if pdata.dir==outdir then return alert("HAHAHA! I already got a project with that dir.") end
          if pn==title then return alert("I already have a project with that title.\nYou'll have to pick an other name") end
      end
   end
   local Template = MAAN_ItemText('KID_LISTBOX_Template')
   if Template=="" then return alert("Please select a template setting") end
   -- Extra user's permission
   if not Proceed("Understand I shall create a project titled '"..title.."' in the directory '"..outdir.."'. \n\nIs that okay?") then return end   
   CreateProject(outdir,Template)
end





-- Work panel

function KID_BUTTON_Start_Action()
     project = {}
     project.title = MAAN_ItemText('KID_LISTBOX_PickProject')
     if project.title=="" then return end
     project.dir = projectlist[project.title].dir
     project.data = MAAN_LoadVar(project.dir.."/L2DKProject.lua")
     if not project.data then alert("Couldn't load the project data") return end
     MAAN_Hide("KID_PANEL_PanelProjectManagement")
     MAAN_Show('KID_PANEL_WorkPanel')
     CSay("Did I show the work panel?")
     MAAN_Text('KID_LABEL_PrjStat',project.title)
end




-- Core load

function GALE_OnLoad()
  CSay("Script for project Manager loaded -- Configuring....")
  CSay("Are there any projects?")
  projectlist = MAAN_LoadVar("ProjectList.lua") 
  if not projectlist then projectlist = {} CSay("Nothing loaded, so creating new list") end
  for a,_ in spairs(projectlist) do
      MAAN_Add('KID_LISTBOX_PickProject',a)
      CSay("Added project: "..a)
  end    
  MAAN_Hide('KID_PANEL_WorkPanel')
end  
