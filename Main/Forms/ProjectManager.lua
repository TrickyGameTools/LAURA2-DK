-- Content comes later

projectlist = MAAN_LoadVar("ProjectList.lua") or {}

function FORM_ProjectManager_Close()
     MAAN_SaveVar(projectlist,"ProjectList.lua")
     os.exit()
end     


function OwnDirAllowed(destroy)
	MAAN_Enabled('KID_TEXTFIELD_ProjectCreateDir',MAAN_Checked('KID_RADIO_CreateIn#CustomDir'))
	-- --[[
	if MAAN_Checked('KID_RADIO_CreateIn#DefaultDir') then
		MAAN_Text('KID_TEXTFIELD_ProjectCreateDir',"$Documents$/LAURA2Projects/"..MAAN_Text('KID_TEXTFIELD_Title'))
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
end

function GALE_OnLoad()
  CSay("Script for project Manager loaded -- Configuring....")
end  