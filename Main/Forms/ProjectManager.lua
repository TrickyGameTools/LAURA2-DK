-- Content comes later

projectlist = MAAN_LoadVar("ProjectList.lua") or {}

function FORM_ProjectManager_Close()
     MAAN_SaveVar(projectlist,"ProjectList.lua")
     os.exit()
end     
