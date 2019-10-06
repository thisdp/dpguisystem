addEvent("dgsStartMove",true)
addEvent("dgsMoveComplete",true)
guiElementData  = {}
tursba = {}
tursbb = {}
tursbc = {}
tursbd = {}
tursbxa = {}

function dgsSetAnim(gelem,x,y,w,h,times,relative,a1,a2,mode,name)
	if isElement(gelem) then
		returnsTF = false
		relative = relative or false
		mode = mode or false
		if tonumber(a1) and tonumber(a2) then
			if tonumber(a1) <= 1 and tonumber(a1) >= 0 and tonumber(a2) <= 1 and tonumber(a2) >= 0 then
			else
				a1 = 1
				a2 = 1
			end
		else
			a1 = 1
			a2 = 1
		end
		if gelem and tonumber(x) and tonumber(y) and tonumber(w) and tonumber(h) then
			if tonumber(times) <= 1 and tonumber(times) >= 0 then
				guiSetAlpha (gelem,a1)
				local sx,sy = guiGetPosition(gelem,true)
				local sw,sh = guiGetSize(gelem,true)
				guiElementData[gelem] = createElement("guiMovingsDP")
				if guiElementData[gelem] then
					times = (times^2)^0.5
					setElementData(guiElementData[gelem],"eposize",{x,y,w,h,a1,a2})
					setElementData(guiElementData[gelem],"addminusvalue",{math.floor((x-sx)*times*100000)/100000,math.floor((y-sy)*times*100000)/100000,math.floor((w-sw)*times*100000)/100000,math.floor((h-sh)*times*100000)/100000,math.floor((a2-a1)*times*100000)/100000})
					setElementData(guiElementData[gelem],"bindGuiElement",gelem)
					setElementData(guiElementData[gelem],"realt",relative)
					if mode == true then
						setElementData(guiElementData[gelem],"mode",1)
					else
						setElementData(guiElementData[gelem],"mode",0)
					end
					name = name or ""
					setElementData(guiElementData[gelem],"name",name)
					triggerEvent("dgsStartMove",gelem,gelem,x,y,w,h,times,relative,a1,a2,mode,name)
					returnsTF = true
				end
			end
		end
		return returnsTF
	end
end

local sxs = 0
local sys = 0
addEventHandler("onClientRender",root,function()
	for k,gelements in ipairs( getElementsByType("guiMovingsDP") ) do
		if isElement(gelements) then
			if getElementData(gelements,"eposize") then
				local timesr = getElementData(gelements,"addminusvalue")
				local theGuiElement = getElementData(gelements,"bindGuiElement")
				if not isElement(theGuiElement) then destroyElement(gelements) return end
				local eposSize = getElementData(gelements,"eposize")
				local realti = getElementData(gelements,"realt")
				local expos,eypos,exsize,eysize = eposSize[1],eposSize[2],eposSize[3],eposSize[4]
				local salpha,ealpha = eposSize[5],eposSize[6]
				local addxpos,addypos,addxsize,addysize,addalpha = timesr[1],timesr[2],timesr[3],timesr[4],timesr[5]
				if getElementData(gelements,"mode") == 1 then
					themode = true
					sxs,sys = dgsGetPosition(theGuiElement,realti)
				else
					themode = false
					sxs,sys = guiGetPosition(theGuiElement,realti)
				end
				local sws,shs = guiGetSize(theGuiElement,realti)
				local alp = guiGetAlpha (theGuiElement)
				if addxpos < 0 then
					if sxs+addxpos-0.0001 <= expos then
						tursba[gelements] = 1
					else
					end
				elseif sxs+addxpos+0.0001 >= expos then
					tursba[gelements] = 1
				end
				if addypos < 0 then
					if sys+addypos-0.0001 <= eypos then
						tursbb[gelements] = 1
					end
				elseif sys+addypos+0.0001 >= eypos then
					tursbb[gelements] = 1
				end
				if addxsize < 0 then
					if sws+addxsize-0.0001 <= exsize then
						tursbc[gelements] = 1
					end
				elseif sws+addxsize+0.0001 >= exsize then
					tursbc[gelements] = 1
				end
				if addysize < 0 then
					if shs+addysize-0.0001 <= eysize then
						tursbd[gelements] = 1
					end
				elseif shs+addysize+0.0001 >= eysize then
					tursbd[gelements] = 1
				end
				if addalpha < 0 then
					if alp <= ealpha then
						tursbxa[gelements] = 1
					end
				elseif alp >= ealpha then
					tursbxa[gelements] = 1
				end
				if tursba[gelements] == 1 then
					sxs = expos
				else
					sxs = sxs+addxpos
				end
				if tursbb[gelements] == 1 then
					sys = eypos
				else
					sys = sys+addypos
				end
				if tursbc[gelements] == 1 then
					sws = exsize
				else
					sws = sws+addxsize
				end
				if tursbd[gelements] == 1 then
					shs = eysize
				else
					shs = shs+addysize
				end
				if tursbxa[gelements] == 1 then
					alp = ealpha
				else
					alp = alp+addalpha
				end
				if getElementData(gelements,"mode") == 1 then
					dgsSetPosition(theGuiElement,sxs,sys,true)
					dgsSetSize(theGuiElement,sws,shs,true)
				else
					guiSetPosition(theGuiElement,sxs,sys,true)
					guiSetSize(theGuiElement,sws,shs,true)
				end
				guiSetAlpha (theGuiElement,alp)
				if tursba[gelements] == 1 and tursbb[gelements] == 1 and tursbc[gelements] == 1 and tursbd[gelements] == 1 and tursbxa[gelements] == 1 then
					tursba[gelements] = nil
					tursbb[gelements] = nil
					tursbc[gelements] = nil
					tursbd[gelements] = nil
					tursbxa[gelements] = nil
					if getElementData(gelements,"mode") == 1 then
						dgsSetPosition(theGuiElement,expos,eypos,true)
						dgsSetSize(theGuiElement,exsize,eysize,true)
					else
						guiSetPosition(theGuiElement,sxs,sys,true)
						guiSetSize(theGuiElement,sws,shs,true)
					end
					triggerEvent("dgsMoveComplete",theGuiElement,theGuiElement,sxs,sys,sws,shs,guiGetAlpha (theGuiElement),realti,themode,getElementData(gelements,"name"))
					destroyElement(gelements)
				end
			end
		end
	end
end)

function dgsGetPosition(guielement,relative)
	if guielement then
		local xr,yr = guiGetPosition(guielement,relative)
		local wr,hr = guiGetSize(guielement,relative)
		xr = xr+wr/2
		yr = yr+hr/2
		return xr,yr
	else
		return false
	end
end

function dgsSetPosition(guielement,x,y,relative)
	if guielement then
		local wr,hr = guiGetSize(guielement,relative)
		x = x-wr/2
		y = y-hr/2
		guiSetPosition(guielement,x,y,relative)
		return true
	else
		return false
	end
end

function dgsSetSize(guielement,width,height,relative)
	if guielement then
		local srx,sry = dgsGetPosition(guielement,relative)
		guiSetSize(guielement,width,height,relative)
		dgsSetPosition(guielement,srx,sry,relative)
		return true
	else
		return false
	end
end

fileDelete("dgsCode.lua")