MyDir = ""

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
        MyDir = MyDir .. f
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