local sW,sH = guiGetScreenSize()
animShaders = {}
addEvent("onShaderAnimDestroy",true)
addEvent("onShaderAnimMoveComplete",true)
addEvent("onShaderAnimCreate",true)
function dgsCreateShaderAnim(image,sx,sy,ex,ey,ssx,ssy,esx,esy,srx,sry,srz,erx,ery,erz,speed,deleteimage,deleteshader)
	local deleteimage = delimage or false
	local deleteshader = deleteshader or false
	if not isElement(image) then
		image = dxCreateTexture(image)
		deleteimage = true
	end
	if isElement(image) then
		sx,sy = sx or 0,sy or 0
		ex,ey = ex or 0,ey or 0
		ssx,ssy = ssx or 0,ssy or 0
		esx,esy = esx or 0,esy or 0
		srx,sry,srz = srx or 0,sry or 0,srz or 0
		erx,ery,erz = erx or 0,ery or 0,erz or 0
		speed = speed or 0.1
		local shader = dxCreateShader("shaders/BlurShader.fx")
		triggerEvent("onShaderAnimCreate",shader,image,sx,sy,ex,ey,ssx,ssy,esx,esy,srx,sry,srz,erx,ery,erz,speed)
		dxSetShaderValue(shader,"ScreenSource",image)
		setElementData(shader,"mydatas",{ex,ey,esx,esy,erx,ery,erz},false)
		setElementData(shader,"mypos",{sx,sy,ssx,ssy,srx,sry,srz},false)
		setElementData(shader,"myspeeds",{(ex-sx)/speed,(ey-sy)/speed,(esx-ssx)/speed,(esy-ssy)/speed,(erx-srx)/speed,(ery-sry)/speed,(erz-srz)/speed},false)
		setElementData(shader,"deleteimage",{deleteimage,image,deleteshader})
		table.insert(animShaders,shader)
		return shader
	end
	return false
end

function dgsSetShaderAnimImage(shader,image)
	if isElement(shader) and isElement(image) then
		local id = table.find(animShaders,shader)
		if id then
			dxSetShaderValue(shader,"ScreenSource",image)
		end
	end
	return false
end

function dgsDestroyShaderAnim(shader)
	if isElement(shader) then
		local id = table.find(animShaders,shader)
		if id then
			local delimage = getElementData(shader,"deleteimage")
			if delimage then
				if delimage[1] then
					destroyElement(delimage[2])
				end
			end
			destroyElement(shader)
			table.remove(animShaders,table.find(animShaders,shader))
			return true
		end
	end
	return false
end

function table.find(tabl,element,tf)
	if type(tabl) == "table" then
		for k,v in pairs(tabl) do
			if v == element then
				if tf then
					return v,k
				end
				return k
			end
		end
	end
	return false
end

function math.pm(number)
	if type(number) == "number" then
		return math.abs(number)/number
	end
	return false
end

local tickcount = getTickCount()
addEventHandler("onClientRender",root,function()
	local tickc = getTickCount()
    for k,v in pairs(animShaders) do
		local pos = getElementData(v,"mypos")
		local epos = getElementData(v,"mydatas")
		local moves = getElementData(v,"myspeeds")
		local checks = false
		for k,v in pairs(moves) do
			if v ~= 0 then
				checks = true
				break
			end
		end
		local moving = false
		for i=1,7 do
			if moves[i] and moves[i] ~= 0 then
				if math.pm(moves[i]) > 0 then
					if pos[i] + moves[i]*(tickc-tickcount)*0.001 >= epos[i] then
						pos[i] = epos[i]
						moves[i] = 0
					else
						moving = true
						pos[i] = pos[i] + moves[i]*(tickc-tickcount)*0.001
					end
				else
					if pos[i] + moves[i]*(tickc-tickcount)*0.001 <= epos[i] then
						pos[i] = epos[i]
						moves[i] = 0
					else
						moving = true
						pos[i] = pos[i] + moves[i]*(tickc-tickcount)*0.001
					end
				end
			end
		end
		dxSetShaderTransform(v,pos[5],pos[6],pos[7])
        dxDrawImage(pos[1],pos[2],pos[3],pos[4],v)
		setElementData(v,"myspeeds",moves,false)
		setElementData(v,"mypos",pos,false)
		if checks then
			if not moving then
				triggerEvent("onShaderAnimMoveComplete",v)
				local delimage = getElementData(v,"deleteimage")
				if delimage[3] then
					dgsDestroyShaderAnim(v)
				end
			end
		end
    end
	tickcount = tickc
end)

local showMessageTimer,setvisible
function outputTypeMessage(messagetype,message,showtime,r,g,b)
	showtime,r,g,b = showtime or 5000,r or 255,g or 255,b or 255
	if type(message) == "string" and type(messagetype) == "string" then
		if isTimer(showMessageTimer) then
			killTimer(showMessageTimer)
		end
		if isTimer(destroyMessageTimer) then
			killTimer(destroyMessageTimer)
		end
		setvisible = true
		if isElement(showMessageBackGround) then
			exports.dpguisystem:dgsStaticImageLoadImage(showMessageBackGround,"Images/tips/"..messagetype.."_d.png")
		else
			showMessageBackGround = exports.dpguisystem:dgsCreateBackGround(0.35,0.05,0.3,0.125,"Images/tips/"..messagetype.."_d.png",true)
		end
		setElementData(showMessageBackGround,"text",message,false)
		setElementData(showMessageBackGround,"color",{r,g,b},false)
		showMessageTimer = setTimer(function()
			if isElement(showMessageBackGround) then
				setvisible = false
				destroyMessageTimer = setTimer(function()
					destroyElement(showMessageBackGround)
				end,1000,1)
			end
		end,showtime,1)
	end
end