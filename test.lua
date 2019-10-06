local selectelement = false
local dgslabel = {}
local font = dxCreateFont("font/samesize.ttf",50)

function dgsCreateEdit(x,y,wid,hei,text,scale,color,shadow,scolor,relative,parent)
	if type(x) == "number" and type(y) == "number" and type(wid) == "number" then
		relative = relative or false
		color = tonumber(color) or tocolor(255,255,255,255)
		scolor = tonumber(scolor) or tocolor(0,0,0,255)
		local label = guiCreateLabel(x,y,wid,hei,tostring(text),relative,parent)
		setElementData(label,"shadow",shadow or false)
		setElementData(label,"color",{color,scolor})
		guiSetAlpha(label,0)
		dgsSetType(label,"dgs-edit")
		if type(scale) ~= "number" or scale <= 0 then
			scale = 1
		end
		setElementData(label,"scale",scale)
		table.insert(dgslabel,label)
		return label
	end
	return false
end

addEventHandler("onClientElementDestroy",root,function()
	local id = table.find(dgslabel,source)
	if id then
		table.remove(dgslabel,id)
	end	
end)

function renderGUI()
	if not isCursorShowing() then
		selectelement = false
	end
	for k,v in pairs(dgslabel) do
		local passx,passy = guiGetPosition(v,true)
		local passsx,passsy = guiGetSize(v,true)
		if passx then
			local scale = getElementData(v,"scale")
			local myx,myy = dgsGetGuiRealPosition(v,false)
			local sizx,sizy = dgsGetGuiRealSize(v,false)
			local text = guiGetText(v)
			local len = utfLen(text)
			local start = len - math.floor(sizx*(0.1245/scale))
			if start <= 0 then
				start = 0
			end
			local sstring = utfSub(text,start,len)
			if selectelement == v then
				sstring = sstring..""..(showeditcursor or "")
			end
			local colors = getElementData(v,"color")
			if getElementData(v,"shadow") then
				dxDrawText(sstring,myx+1,myy+1,sW,sH,colors[2],scale/5.37,font,"left","top",true,true,true)
			end
			dxDrawText(sstring,myx,myy,sW,sH,colors[1],scale/5.37,font,"left","top",true,true,true)
		end
	end
end
addEventHandler("onClientRender",root,renderGUI)

addEventHandler("dgsClientGUIClick",root,function(button,state)
	if source == root then
		selectelement = false
	end
	if isElement(source) then
		if dgsGetType(source) == "dgs-edit" then
			selectelement = source
			resetTimer(showedittimer)
			showeditcursor = "▏"
		else
			selectelement = false
		end
	end
end)

local ablekey = {"'","space","backspace","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","num_0","num_1","num_2","num_3","num_4","num_5","num_6","num_7","num_8","num_9","num_mul","num_add","num_sub","num_div","num_dec",";","-","=",".",",","/","\\","[","]","#"}
local ablekeyup = {{"#",'"'},{"'","~"},{";",":"},{"-","_"},{"=","+"},{".",">"},{",","<"},{"/","?"},{"\\","|"},{"[","{"},{"]","}"},{"1","!"},{"2","@"},{"3","#"},{"4","$"},{"5","%"},{"6","^"},{"7","&"},{"8","*"},{"9","("},{"0",")"}}
local keyrep = {["num_mul"] = "*",["num_add"] = "+",["num_sub"] = "-",["num_div"] = "/",["num_dec"] = "."}
local checkkey = {}
local backspacestring = ""
for k,v in ipairs(ablekey) do
	checkkey[v] = true
end
addEvent("dgsEditInputChecked",true)
addEventHandler("onClientKey",root,function(key,state)
	if state then
		if key == "tab" then
			if isElement(selectelement) then
				local parent = getElementParent(selectelement)
				if isElement(parent) then
					local children = getElementChildren(parent)
					if children then
						local myid = table.find(children,selectelement)
						local first,second
						for k,v in ipairs(children) do
							if not first then
								if myid >= k then
									if dgsGetType(v) == "dgs-edit" then
										first = v
									end	
								end
							end
							if myid < k then
								if dgsGetType(v) == "dgs-edit" then
									second = v
									break
								end
							end
						end
						if not second then
							selectelement = first
						else
							selectelement = second
						end
						resetTimer(showedittimer)
						showeditcursor = "▏"
					end
				end
			end
		end
		if isElement(selectelement) then
			local disables = getElementData(selectelement,"disables")
			if type(disables) == "table" then
				if table.find(disables,key) then
					return
				end
			end
			if checkkey[key] then
				if key == "space" then
					triggerEvent("dgsEditInputChecked",root," ")
				elseif string.find(key,"num_",0) then
					if not tonumber(pregReplace(key,"num_","")) then
						triggerEvent("dgsEditInputChecked",root,keyrep[key])
					else
						triggerEvent("dgsEditInputChecked",root,pregReplace(key,"num_",""))
					end
				elseif getKeyState("lshift") or getKeyState("rshift") then
					if key ~= "backspace" then
						local oldkey = key
						key = string.upper(key)
						if key == oldkey then
							key = string.xupper(key)
						end
					end
					triggerEvent("dgsEditInputChecked",root,key)
				elseif key == "#" then
					triggerEvent("dgsEditInputChecked",root,"'")
				else
					triggerEvent("dgsEditInputChecked",root,key)
				end
				cancelEvent()
			end
		end
	else
		if isTimer(keepkeywait) then
			killTimer(keepkeywait)
		end
		if isTimer(keepkeystart) then
			killTimer(keepkeystart)
		end
	end
end)

function string.xupper(string)
	for k,v in ipairs(ablekeyup) do
		if v[1] == string then
			return v[2]
		end
	end
	return string
end

function dgsEditSetDisabledKey(label,tab)
	if dgsGetType(label) == "dgs-edit" then
		if type(tab) == "table" then
			setElementData(label,"disables",tab)
		else
			setElementData(label,"disables",false)
		end
		return true
	end
	return false
end

function dgsEditSetMax(label,number)
	if dgsGetType(label) == "dgs-edit" then
		if type(number) == "number" then
			setElementData(label,"max",number)
		else
			setElementData(label,"max",false)
		end
		return true
	end
	return false
end

addEventHandler("dgsEditInputChecked",root,function(key)
	if isTimer(keepkeywait) then
		killTimer(keepkeywait)
	end
	if isTimer(keepkeystart) then
		killTimer(keepkeystart)
	end
	if isElement(selectelement) then
		local gonext = true
		local text = guiGetText(selectelement)
		if key == "backspace" then
			local newtext = utfSub(text,0,utfLen(text)-1)
			guiSetText(selectelement,newtext)
			keepkeywait = setTimer(function()
				keepkeystart = setTimer(function()
					local text = guiGetText(selectelement)
					local newtext = utfSub(text,0,utfLen(text)-1)
					guiSetText(selectelement,newtext)
					resetTimer(showedittimer)
					showeditcursor = "▏"
				end,50,0)
			end,500,1)
		else
			local max = getElementData(selectelement,"max")
			if type(max) == "number" then
				if #guiGetText(selectelement) >= max then
					gonext = false
				end
			end
			if gonext then
				local newtext = text..""..key
				guiSetText(selectelement,newtext)
			end
		end
		resetTimer(showedittimer)
		showeditcursor = "▏"
	end
end)


showeditcursor = false
showedittimer = setTimer(function()
	showeditcursor = not showeditcursor
	if showeditcursor then
		showeditcursor = "▏"
	end
end,500,0)
