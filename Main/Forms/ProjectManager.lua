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
