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
Version: 17.04.23
]]

-- @USEDIR Libs
-- @USEDIR Forms/ProjectManagerUse

-- projectlist = MAAN_LoadVar("ProjectList.lua") or {}



-- Project manager

globalfile = Dirry('$AppSupport$/LAURA2DK/GlobalConfig.lua')
CSay('Reading: '..globalfile)
--local ok
varglobal = MAAN_LoadVar(globalfile)
--[[
if not ok then
   CSay("ERROR -- Global File -- "..varglobal)
else
   CSay('LVSuc')   
end   
if not varglobal then 
   CSay("I could not load, so let's just create an empty record")
   varglobal = {}
end   
]]
CFG = {[true]=varglobal}


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

function GrabIDFromGUI()
  local pd = project.data.ID
  CSay("Grabbing ID Data from GUI")
  for g in each(MAAN_Indexes('KID_TEXTFIELD_IDField')) do
      pd[g] = MAAN_Text('KID_TEXTFIELD_IDField#'..g)
  end
  ---CSay(serialize(Prj,project))
end

function AssocUpdate(idx)
    for g in each(MAAN_Indexes('KID_TEXTFIELD_AsValue'))  do
        local b = MAAN_Checked('KID_CHECKBOX_AsGlob#'..g)
        project.data.CFGIG[g] = b
        CFG[b][g]=MAAN_Text('KID_TEXTFIELD_AsValue#'..g)
    end
    CSay(serialize("projectdata",project.data))
end

function AssocRead()
    --CSay(serialize("projectdata",project.data))
    --CSay(serialize('CFG        ',CFG))
    for g in each(MAAN_Indexes('KID_TEXTFIELD_AsValue'))  do
        local b = project.data.CFGIG[g]==true
        --CSay(serialize('g',g))
        --CSay(serialize('b',b))
        MAAN_Checked('KID_CHECKBOX_AsGlob#'..g,b)
        MAAN_Text('KID_TEXTFIELD_AsValue#'..g,CFG[b][g])
    end
end

    
function KID_BUTTON_AsBrowse_Action(idx)
   local filter,default=
   -- @IF $MAC
    "Applications:app","/Applications"   
   -- @FI
   -- @IF IGNORE
   filter,default=
   -- @FI
   -- @IF $WINDOWS
   "Executables:exe,com","C:\\Program Files"
   -- @FI
   CSay("Looking for: "..(filter or "nil").." in: "..(default or "nil"))
   local f=RequestFile("Please select an application ("..idx..")",filter,default)
   if f and f~="" then
      MAAN_Text('KID_TEXTFIELD_AsValue#'..idx,f)
      AssocUpdate(idx)
   end   
end

function KID_TEXTFIELD_AsValue_Action(idx) AssocUpdate(idx) end

function KID_CHECKBOX_AsGlob_Action(idx)
     local b = MAAN_Checked('KID_CHECKBOX_AsGlob#'..idx)
     MAAN_Text('KID_TEXTFIELD_AsValue#'..idx,CFG[b][idx])   
     AssocUpdate(idx) 
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
     project.data = project.data or {}
     project.data.ID = project.data.ID or {}  
     project.data.ID.Title = project.data.ID.Title or project.title
     project.data.CFG = project.data.CFG or {}
     project.data.CFGIG = project.data.CFGIG or {}
     CFG[false]=project.data.CFG
     for g in each(MAAN_Indexes('KID_TEXTFIELD_IDField')) do
         if project.data.ID[g] then MAAN_Text('KID_TEXTFIELD_IDField#'..g,project.data.ID[g]) end
     end
     project.data.kthura = project.data.kthura or {}
     project.kthura = project.data.kthura
     for g in each(MAAN_Indexes('KID_TEXTAREA_Kthura')) do
         project.kthura[g] = project.kthura[g] or MAAN_Text('KID_TEXTAREA_Kthura#'..g)
         MAAN_Text('KID_TEXTAREA_Kthura#'..g,project.kthura[g]) 
     end   

     AssocRead()
end




-- Core load and unload

function FORM_ProjectManager_Close()
     MAAN_SaveVar(projectlist,"ProjectList.lua")
     if project and project.dir then
         GrabIDFromGUI()
         MAAN_SaveVar(project.data,project.dir.."/L2DKProject.lua")
     end
     MAAN_SaveVar(varglobal,globalfile)    
     os.exit()
end     


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
