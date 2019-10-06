--[[Copyright © 2013 - 9999 CMR thisdp's GUI System(DGS). All Rights Reserved]]--
sW,sH = guiGetScreenSize()
defaultrow = "Images/row1.png"
changerow = "Images/row2.png"
selectrow = "Images/row3.png"
enterElement = nil
dgsElementType = {}
thecount = {}
thetable = {}
thextable = {}
rowYpos = {}
rowYposSet = {}
dgsElementData = {}
addEvent("onDGSOnOffButtonStateChange",true)
addEvent("dgsWindowClose",true)
addEvent("dgsWindowCreate",true)
addEvent("dgsAddRow",true)
addEvent("dgsScrollBarScroll",true)
addEvent("onClientDGSClick",true)
addEvent("onClientDGSScroll",true)

dgsSou = {}
dgsSou["enter"] = true
dgsSou["click"] = true
dgsSound = {}
dgsSound["enter"] = "sound/MouseEnter.wav"
dgsSound["click"] = "sound/MouseClick.wav"

function dgsPlaySound(string)
	if tostring(string) then
		if dgsSou[tostring(string)] then
			if playSound(dgsSound[tostring(string)]) then
				return true
			end
		end
	end
	return false
end

nonerow = "Images/row1.png"
enterrow = "Images/row3.png"

function toboolean(sourxx)
	if not sourxx then
		return false
	end
	if type(sourxx) == "boolean" then
		return sourxx
	else
		if sourxx == "true" then
			return true
		elseif sourxx == "false" or sourxx == "nil" or sourxx == "" then
			return false
		end
	end
	return false
end

function dgsGetElementInParent(source,parent)
	if isElement(source) and isElement(parent) then
		local myparentdgs = source
		for i=1,50 do
			myparentdgs = getElementParent(myparentdgs)
			if myparentdgs == parent then
				return true
			end
		end
	end
	return false
end

function dgsGetElementData(rowelement,key)
	if isElement(rowelement) and tostring(key) then
		if dgsElementData[rowelement] then
			if dgsElementData[rowelement][""..key..""] then
				return dgsElementData[rowelement][""..key..""]
			end
		end
	end
	return false
end

function dgsSetElementData(rowelement,key,value)
	if isElement(rowelement) and tostring(key) then
		if not dgsElementData[rowelement] then
			dgsElementData[rowelement] = {}
		end
		dgsElementData[rowelement][""..key..""] = value
		return true
	end
	return false
end

-------------some functions
function dgsCreateColorImageElement(x,y,r,g,b,a)
	x = tonumber(x)
	y = tonumber(y)
	r = tonumber(r)
	g = tonumber(g)
	b = tonumber(b)
	a = tonumber(a)
	if x and y and r and g and b then
		local myimage=dxCreateTexture(x,y)
		local pixel=dxGetTexturePixels(myimage)
		for ix=0,x-1 do
			for iy=0,y-1 do
				dxSetPixelColor(pixel,ix,iy,r,g,b,a)
			end
		end
		dxSetTexturePixels(myimage,pixel)
		return myimage
	end
end

function dgsGetElementsByType(type,guitype,paelement)
	if tostring(type) then
		guielements = nil
		guielements = {}
		if tostring(guitype) then
			theguitype = guitype
		else
			theguitype = "gui-staticimage"
		end
		if paelement then
			if tostring(guitype) then
				for k,v in ipairs(getElementChildren(paelement)) do
					if getElementType(v) == guitype then
						forelement[k] = v
					end
				end
				if not forelement then
					forelement = getElementChildren(paelement)	
				end
			else
				forelement = getElementChildren(paelement)
			end
		else
			forelement = getElementsByType(theguitype)
		end
		for k,v in ipairs(forelement) do	
			if dgsGetType(v) == type then
				guielements[k] = v
			end
		end
		if guielements then
			return guielements
		end
		return false
	end
end

function dgsGetType(guielement)
	if isElement(guielement) then
		return dgsElementType[guielement] or getElementType(guielement)
	end
	return false,type(guielement)
end

function dgsSetType(guielement,string)
	if isElement(guielement) and type(string) == "string" then
		dgsElementType[guielement] = string
		setElementID(guielement,string)
		return true
	end
	return false
end
--------------CreateText
function dgsSetDxLabelText(label,text)
	if isElement(label) and text then
		setElementData(label,"text",text)
		return true
	end
	return false
end

function dgsSetDxLabelColor(label,r,g,b,a)
	if isElement(label) then
		if tonumber(r) and tonumber(r) <= 255 and tonumber(r) >=0 then
		else
			r = 255
		end
		if tonumber(g) and tonumber(g) <= 255 and tonumber(g) >=0 then
		else
			g = 255
		end
		if tonumber(b) and tonumber(b) <= 255 and tonumber(b) >=0 then
		else
			b = 255
		end
		if tonumber(a) and tonumber(a) <= 255 and tonumber(a) >=0 then
		else
			a = 255
		end
		setElementData(label,"colors",{r,g,b,a})
		return true
	end
	return false
end

function dgsCreateDxLabel(text,x,y,sizex,sizey,font,r,g,b,a,lr,tb,postgui)
	if font then
	else
		font = "default"
	end
	if tonumber(r) and tonumber(r) <= 255 and tonumber(r) >=0 then
	else
		r = 255
	end
	if tonumber(g) and tonumber(g) <= 255 and tonumber(g) >=0 then
	else
		g = 255
	end
	if tonumber(b) and tonumber(b) <= 255 and tonumber(b) >=0 then
	else
		b = 255
	end
	if tonumber(a) and tonumber(a) <= 255 and tonumber(a) >=0 then
	else
		a = 255
	end
	if x and y and sizex and sizey and text then
		local wocaoelement = createElement("myShit")
		setElementData(wocaoelement,"xyposize",{x,y,sizex,sizey})
		setElementData(wocaoelement,"colors",{r,g,b,a})
		setElementData(wocaoelement,"font",font)
		setElementData(wocaoelement,"text",text)
		setElementData(wocaoelement,"lr",lr or "left")
		setElementData(wocaoelement,"tb",tb or "top")
		setElementData(wocaoelement,"post",postgui or false)
		return wocaoelement
	end
end

addEventHandler("onClientRender",root,function()
	for k,v in ipairs(getElementsByType("myShit")) do
		if v then
			local text = getElementData(v,"text")
			local xyps = getElementData(v,"xyposize")
			local color = getElementData(v,"colors")
			local font = getElementData(v,"font")
			local lr = getElementData(v,"lr")
			local tb = getElementData(v,"tb")
			local post = getElementData(v,"post")
			dxDrawText(text,xyps[1],xyps[2],sW,sH,tocolor(color[1],color[2],color[3],color[4]),xyps[3],xyps[4],font,lr,tb,false,false,post)
		end
	end
end)
--------------C-O-D-E-------------------------------------------------------------------------------------
windowimage = "Images/windtab.png"
tabn = "Images/tabn.png"
tab1 = "Images/tab1.png"
tab2 = "Images/tab2.png"
tab3 = "Images/tab3.png"
backg1 = "Images/wbackground.png"
backg2 = "Images/wbackground2.png"
backg3 = "Images/wbackground3.png"
guiButtonSel = "Images/dpgbuttons.png"
guiButtonSel1 = "Images/button2-a.png"
guiButtonSel2 = "Images/button2-b.png"
guiButtonSel3 = "Images/button2-c.png"
alphaSel = "Images/alphaz.png"
alphahSel = "Images/alphah.png"

function dgsCreateBackGround(x,y,wid,hei,images,relative,parent)
	if tonumber(x) and tonumber(y) and tonumber(wid) and tonumber(hei) then
			myelement = guiCreateStaticImage(x,y,wid,hei,images or backg1,relative,parent)
		return myelement
	end
	return false
end

function dgsStaticImageLoadImage(element,path)
	if isElement(element) then
		if getElementType(element) == "gui-staticimage" then
			if tostring(path) then
				guiStaticImageLoadImage(element,path)
				return true
			end
		end
	end
	return false
end

function dgsSetSelectedTab(panel,id)
	if isElement(panel) then
		if dgsGetType(panel) == "dgs-tabpanel" and tonumber(id) then
			local tabbg = getElementData(panel,"tabbg")
			local mytabima = getElementData(tabbg,"tabimage")
			guiStaticImageLoadImage(getElementData(tabbg,"tab"..id..""),mytabima[3])
			local changeelement = getElementData(tabbg,"tab"..getElementData(tabbg,"selectedid").."")
			if isElement(changeelement) and changeelement ~= getElementData(tabbg,"tab"..id.."") then
				guiStaticImageLoadImage(changeelement,mytabima[1])
			end
			setElementData(tabbg,"selectedid",tonumber(id))
			guiBringToFront(getElementData(getElementData(tabbg,"tab"..id..""),"show"))
			return true
		end
	end
	return false
end

function dgsGetSelectedTab(panel)
	local tabbg = getElementData(panel,"tabbg")
	return getElementData(tabbg,"selectedid")
end

addEventHandler("onClientElementDestroy",root,function()
	if dgsGetType(source) then
		if dgsGetType(source) == "dgs-tabpanel" then
			local tabback = getElementData(source,"tabbg")
			if isElement(tabback) then
				destroyElement(tabback)
			end
		end
	end
end)

function dgsCreateTabPanel(x,y,wid,hei,images,relative,parent,tabns,tab1s,tab2s,tab3s)
	if x and y and wid and hei then
		images = images or backg2
		dgsalphaimagpanel = guiCreateStaticImage(x,y,wid,hei,images,relative,parent)
		dgsSetType(dgsalphaimagpanel,"dgs-tabpanel")
		setElementData(dgsalphaimagpanel,"images",images)
		tabpanelbg = guiCreateStaticImage(0,0,wid,20,alphaSel,relative,parent)
		setElementData(tabpanelbg,"myparentmove",dgsalphaimagepanel)
		dgsSetType(tabpanelbg,"dgs-tabbackground")
		setElementData(dgsalphaimagpanel,"tabbg",tabpanelbg)
		local xmyx,xmyy = guiGetSize(dgsalphaimagpanel,false)
		local xmypx,xmypy = guiGetPosition(dgsalphaimagpanel,false)
		guiSetSize(dgsalphaimagpanel,xmyx,xmyy-20,false)
		guiSetPosition(dgsalphaimagpanel,xmypx,xmypy-20,false)
		if relative == true then
			local xmyx,xmyy = guiGetSize(dgsalphaimagpanel,true)
			local xmypx,xmypy = guiGetPosition(dgsalphaimagpanel,true)
			guiSetSize(dgsalphaimagpanel,xmyx,xmyy,true)
			guiSetPosition(dgsalphaimagpanel,xmypx,xmypy,true)
		end
		setElementData(tabpanelbg,"tabimage",{tabns or tabn,tab1s or tab1,tab2s or tab2,tab3s or tab3})
		setElementData(tabpanelbg,"myparent",dgsalphaimagpanel)
		setElementData(dgsalphaimagpanel,"tabnumber",0)
		setElementData(tabpanelbg,"selectedid",-1)
		return dgsalphaimagpanel
	end
	return false
end

function dgsTabPanelAddTab(string,tabpanel)
	if isElement(tabpanel) then
		if dgsGetType(tabpanel) == "dgs-tabpanel" then
			local thetabnumber = getElementData(tabpanel,"tabnumber")
			local tabbgs = getElementData(tabpanel,"tabbg")
			local xsize = 0
			for i=1,thetabnumber do
			local tabsox = getElementData(tabbgs,"tab"..i.."")
				if isElement(tabsox) then
					local x,_ = guiGetSize(tabsox,false)
					xsize = xsize+x
				end
			end
			paneltabs = guiCreateStaticImage(xsize,0,string.len(string)*8,20,tabn,false,tabbgs)
			myfuckinglabel = guiCreateLabel(0,0,1,1,string,true,paneltabs)
			guiSetEnabled(myfuckinglabel,false)
			dgsSetType(myfuckinglabel,"dgs-tabtext")
        		guiLabelSetHorizontalAlign(myfuckinglabel,"center")
			dgsSetType(paneltabs,"dgs-tab")
			setElementData(paneltabs,"tabid",thetabnumber+1)
			setElementData(tabpanel,"tabnumber",thetabnumber+1)
			setElementData(tabbgs,"tab"..(thetabnumber+1).."",paneltabs)
			local panelimage = getElementData(tabpanel,"images")
			tabback = guiCreateStaticImage(0,0,1,1,panelimage,true,tabpanel)
			dgsSetType(tabback,"dgs-tabshow")
			setElementData(tabback,"tab",paneltabs)
			setElementData(paneltabs,"show",tabback)
			if thetabnumber == 0 then
				dgsSetSelectedTab(tabpanel,1)
			end
			dgsSetSelectedTab(tabpanel,dgsGetSelectedTab(tabpanel))
			return tabback
		end
	end
	return false
end

function dgsTabPanelGetTabs(tabpanel)
	if isElement(tabpanel) then
		tabpanelTabs = {}
		for k,v in ipairs(getElementChildren(getElementData(tabpanel))) do
			tabpanelTabs[k] = v
		end
		return tabpanelTabs
	end
	return false
end

function dgsTabPanelSetTabText(tabpanel,tabsid,text)
	if isElement(tabpanel) then
		local tabsid = tonumber(tabsid)
		local text = tostring(text)
		if text then
			local textgui = getElementData(getElementData(tabpanel,"tabbg"))
			return guiSetText(getElementData(textgui,"tab"..tabsid..""),text)
		end
	end
end

function dgsTabPanelGetTabText(tabpanel,tabsid)
	if isElement(tabpanel) then
		local tabsid = tonumber(tabsid)
		local textgui = getElementData(getElementData(tabpanel,"tabbg"))
		return guigetText(getElementData(textgui,"tab"..tabsid..""))
	end
end
-------------------------
-------------------滚动条
-------------------------
function dgsCreateScrollBar(x,y,w,h,movspeed,voh,relative,parent,imagefather,imageup,imagedown,imagemid)
	local movspeed = tonumber(movspeed) or 5
	local x,y,w,h = tonumber(x),tonumber(y),tonumber(w),tonumber(h)
	imagefather = imagefather or "Images/scrollbar/sbfather.png"
	imagemid = imagemid or "Images/scrollbar/sb.png"
	if x and y and w and h then
		voh = voh or false
		local imfather = guiCreateStaticImage(x,y,w,h,imagefather,relative or false,parent)
		local imup,imdw,immd
		local imsx,imsy = guiGetSize(imfather,false)
		if voh then
			imageup = imageup or "Images/scrollbar/sbleft.png"
			imagedown = imagedown or "Images/scrollbar/sbright.png"
			imup = guiCreateStaticImage(0,0,imsy,imsy,imageup,false,imfather)
			imdw = guiCreateStaticImage(imsx-imsy,0,imsy,imsy,imagedown,false,imfather)
			immd = guiCreateStaticImage(imsy,0,imsy,imsy,imagemid,false,imfather)
		else
			imageup = imageup or "Images/scrollbar/sbup.png"
			imagedown = imagedown or "Images/scrollbar/sbdown.png"
			imup = guiCreateStaticImage(0,0,imsx,imsx,imageup,false,imfather)
			imdw = guiCreateStaticImage(0,imsy-imsx,imsx,imsx,imagedown,false,imfather)
			immd = guiCreateStaticImage(0,imsx,imsx,imsx,imagemid,false,imfather)
		end
		local imx,imy = guiGetPosition(immd,true)
		setElementData(imfather,"location",voh)
		guiSetAlpha(imup,0.6)
		guiSetAlpha(imdw,0.6)
		guiSetAlpha(immd,0.6)
		dgsSetType(imfather,"dgs-scrollbar")
		dgsSetType(imup,"dgs-scrollbar-1")
		dgsSetType(imdw,"dgs-scrollbar+1")
		dgsSetType(immd,"dgs-scrollbarscroller")
		setElementData(imfather,"scrolls",0)
		setElementData(imfather,"movspeed",movspeed)
		setElementData(imfather,"movpos",0)
		setElementData(imfather,"but0",imup)
		setElementData(imfather,"but1",imdw)
		setElementData(imfather,"butm",immd)
		setElementData(imfather,"myfather",imfather)
		return imfather
	end
	return false
end

addEventHandler("onClientGUISize",root,function()
	if isElement(source) then
		if dgsGetType(source) == "dgs-scrollbar" then
			local imup = getElementData(source,"but0")
			local imdw = getElementData(source,"but1")
			local immd = getElementData(source,"butm")
			local voh = getElementData(source,"location")
			if voh then
				local sx,sy = guiGetSize(source,false)
				guiSetPosition(imdw,sx-sy,0,false)
				guiSetSize(imdw,sy,sy,false)
				guiSetSize(imup,sy,sy,false)
				guiSetSize(immd,sy,sy,false)
			else
				local sx,sy = guiGetSize(source,false)
				guiSetPosition(imdw,0,sy-sx,false)
				guiSetSize(imdw,sx,sx,false)
				guiSetSize(imup,sx,sx,false)
				guiSetSize(immd,sx,sx,false)
			end
		end
	end
end)

addEventHandler("onClientMouseEnter",root,function()
	local mytype = dgsGetType(source)
	local myfather = getElementData(source,"myfather")
	if dgsGetType(myfather) == "dgs-scrollbar" then
		selectedsb = myfather
	end
	if mytype == "dgs-scrollbarscroller" or mytype == "dgs-scrollbar-1" or mytype == "dgs-scrollbar+1" then
		local ihave = getElementData(source,"myhon")
		local ihaved = getElementData(source,"myhond")
		if isElement(ihaved) then
			destroyElement(ihaved)
		end
		local myele
		if not isElement(ihave) then
			myele = createElement("sbanim1")
		end
		if isElement(myele) then
			setElementData(myele,"myhon",source)
			setElementData(source,"myhon",myele)
		end
	end
end)

addEventHandler("onClientMouseLeave",root,function()
	local mytype = dgsGetType(source)
	selectedsb = false
	if mytype == "dgs-scrollbarscroller" or mytype == "dgs-scrollbar-1" or mytype == "dgs-scrollbar+1" then
		local ihave = getElementData(source,"myhon")
		local ihaved = getElementData(source,"myhond")
		if isElement(ihave) then
			destroyElement(ihave)
		end
		local myele
		if not isElement(ihaved) then
			myele = createElement("sbanim2")
		end
		if isElement(myele) then
			setElementData(myele,"myhond",source)
			setElementData(source,"myhond",myele)
		end
	end
end)

addEventHandler("onClientMouseWheel",root,function(int)
	if isElement(enterElement) and not isElement(selectscrollbar) then
		local parent = getElementData(enterElement,"melist")
		if isElement(parent) then
			if dgsGetType(parent) == "dgs-gridlist" then
				local scrollb = getElementData(parent,"scrollbars")
				if isElement(scrollb["height"]) then
					local allows = true
					if isElement(selectedsb) then
						if selectedsb == scrollb["width"] then
							allows = false
						end
					end
					if allows then 
						dgsScrollBarSetScrollPosition(scrollb["height"],dgsScrollBarGetScrollPosition(scrollb["height"])-int*2)
					end
				end
			end
		end
	end
	if isElement(selectedsb) and not isElement(selectscrollbar) then
		dgsScrollBarSetScrollPosition(selectedsb,dgsScrollBarGetScrollPosition(selectedsb)-int*2)
	end
end)

addEventHandler("onClientRender",root,function()
	local prendele = getElementsByType("sbanim1")
	for k,v in ipairs(prendele) do
		local mymother = getElementData(v,"myhon")
		if isElement(mymother) then
			local alpha = guiGetAlpha(mymother)
			if alpha >= 1 then
				destroyElement(v)
			else
				guiSetAlpha(mymother,alpha+0.02)
			end
		else
			destroyElement(v)
		end
	end
	local prendele = getElementsByType("sbanim2")
	for k,v in ipairs(prendele) do
		local mymother = getElementData(v,"myhond")
		if isElement(mymother) then
			local alpha = guiGetAlpha(mymother)
			if alpha <= 0.6 then
				destroyElement(v)
			else
				guiSetAlpha(mymother,alpha-0.02)
			end
		else
			destroyElement(v)
		end
	end
end)

addEventHandler("onClientGUIMouseDown",root,function()
	local myfather = getElementData(source,"myfather")
	if isElement(myfather) then
		if dgsGetType(myfather) == "dgs-scrollbar" then
			if dgsGetType(source) == "dgs-scrollbarscroller" then
				selectscrollbar = myfather
				local scroller = getElementData(selectscrollbar,"butm")
				scrollbposx,scrollbposy = getDistanceBetweenGuiAndCursor(scroller,true)
			end
			if dgsGetType(source) == "dgs-scrollbar+1" then
				dgsScrollBarSetScrollPosition(myfather,dgsScrollBarGetScrollPosition(myfather)+getElementData(myfather,"movspeed"))
			end
			if dgsGetType(source) == "dgs-scrollbar-1" then
				dgsScrollBarSetScrollPosition(myfather,dgsScrollBarGetScrollPosition(myfather)-getElementData(myfather,"movspeed"))
			end
		end
	end
end)

addEventHandler("onClientClick",root,function(b,s)
	if b == "left" and s == "up" then
		selectscrollbar = false
	end
end)

addEventHandler("onClientCursorMove",root,function(bx,by)
	if isCursorShowing()  then
		if isElement(selectscrollbar) then
			local scroller = getElementData(selectscrollbar,"butm")
			local px,py = dgsGetGuiPositionOnScreen2(getElementParent(scroller),true)
			local sx,sy = dgsGetGuiRealSize(getElementParent(scroller),true)
			local scrollup = getElementData(selectscrollbar,"but0")
			local scrolldw = getElementData(selectscrollbar,"but1")
			local x,y = guiGetPosition(scrollup,true)
			local xst,yst = guiGetSize(scrollup,true)
			local xl,yl = x+xst,y+yst
			local xh,yh = guiGetPosition(scrolldw,true)
			local xu,yu = guiGetPosition(scroller,true)
			local xs,ys = guiGetSize(scroller,true)
			local xw,yw = xu+xs,yu+ys
			if getElementData(selectscrollbar,"location") then
				if (bx-px-scrollbposx)/sx < xl then
					guiSetPosition(scroller,xl,yu,true)
				elseif (bx-px-scrollbposx)/sx > xh-xs then
					guiSetPosition(scroller,xh-xs,yu,true)
				else
					guiSetPosition(scroller,(bx-px-scrollbposx)/sx,0,true)
				end
			else
				if (by-py-scrollbposy)/sy < yl then
					guiSetPosition(scroller,xu,yl,true)
				elseif (by-py-scrollbposy)/sy > yh-ys then
					guiSetPosition(scroller,xu,yh-ys,true)
				else
					guiSetPosition(scroller,0,(by-py-scrollbposy)/sy,true)
				end
			end
			triggerEvent("onClientDGSScroll",selectscrollbar)
		end
	end
end)

addEvent("onClientDGSScroll",true)
addEventHandler("onClientDGSScroll",root,function()
	if isElement(source) then
		local scroller = getElementData(source,"butm")
		local scrollup = getElementData(source,"but0")
		local scrolldw = getElementData(source,"but1")
		local x,y = guiGetPosition(scrollup,true)
		local xst,yst = guiGetSize(scrollup,true)
		local xl,yl = x+xst,y+yst
		local xh,yh = guiGetPosition(scrolldw,true)
		local xu,yu = guiGetPosition(scroller,true)
		local xs,ys = guiGetSize(scrollup,true)
		local xw,yw = xu+xs,yu+ys
		local betpos
		local oldvalue = getElementData(source,"scrolls") or 0
		if getElementData(source,"location") then
			betpos = (xu-xs)/(xh-xs-xl)*100
			if betpos <= 0.00001 then
				betpos = 0
			end
			if betpos >= 99.9999 then
				betpos = 100
			end
			setElementData(source,"scrolls",betpos)
		else
			betpos = (yu-ys)/(yh-ys-yl)*100
			if betpos <= 0.00001 then
				betpos = 0
			end
			if betpos >= 99.9999 then
				betpos = 100
			end
			setElementData(source,"scrolls",betpos)
		end
		triggerEvent("dgsScrollBarScroll",source,betpos,oldvalue)
	end
end)

function dgsScrollBarGetScrollPosition(scroll)
	if isElement(scroll) then
		return getElementData(scroll,"scrolls")
	end
	return false
end

function dgsScrollBarSetScrollPosition(scroll,value)
	if type(value) == "number" then
		if isElement(scroll) then
			if value < 0 then
				value = 0
			end
			if value > 100 then
				value = 100
			end
			local scroller = getElementData(scroll,"butm")
			local scrollup = getElementData(scroll,"but0")
			local scrolldw = getElementData(scroll,"but1")
			local xs,ys = guiGetSize(scrollup,true)
			local xh,yh = guiGetPosition(scrolldw,true)
			local x,y = guiGetPosition(scroller,true)
			local betpos
			if getElementData(scroll,"location") then
				betpos = (xh-xs*2)*value*0.01+xs
				guiSetPosition(scroller,betpos,y,true)
			else
				betpos = (yh-ys*2)*value*0.01+ys
				guiSetPosition(scroller,x,betpos,true)
			end
			triggerEvent("onClientDGSScroll",scroll)
			return true
		end
	end
	return false
end
-------------------------
---------------------按钮
-------------------------
guiButtonOn = "Images/buttonon.png"
guiButtonOff = "Images/buttonoff.png"
function dgsCreateOnOffButton(x,y,width,height,texton,textoff,relative,parent,onimage,offimage)
	if x and y and width and height and texton and textoff then
		local dgsbuttonsx = guiCreateStaticImage(x,y,width,height,offimage or guiButtonOff,relative,parent)
		setElementData(dgsbuttonsx,"states","off")
		local dgsbutttexton = guiCreateLabel(0.5,0,0.5,1,tostring(texton),true,dgsbuttonsx)
		local dgsbutttextoff = guiCreateLabel(0,0,0.5,1,tostring(textoff),true,dgsbuttonsx)
		guiSetEnabled(dgsbutttexton,false)
		guiSetEnabled(dgsbutttextoff,false)
		guiSetVisible(dgsbutttexton,false)
		guiLabelSetVerticalAlign(dgsbutttexton,"center")
		guiLabelSetHorizontalAlign(dgsbutttexton,"center")
		guiLabelSetVerticalAlign(dgsbutttextoff,"center")
		guiLabelSetHorizontalAlign(dgsbutttextoff,"center")
		dgsSetType(dgsbuttonsx,"dgs-onoffbutton")
		dgsSetType(dgsbutttexton,"dgs-onoffbuttontext-on")
		dgsSetType(dgsbutttextoff,"dgs-onoffbuttontext-off")
		setElementData(dgsbuttonsx,"ontext",dgsbutttexton)
		setElementData(dgsbuttonsx,"offtext",dgsbutttextoff)
		setElementData(dgsbuttonsx,"buttonimageon",onimage or guiButtonOn)
		setElementData(dgsbuttonsx,"buttonimageoff",offimage or guiButtonOff)
		return dgsbuttonsx
	end
	return false
end

function dgsSetOnOffButtonState(thebutton,state)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-onoffbutton" then
			if state == true then
				setElementData(thebutton,"states","on")
				guiStaticImageLoadImage(thebutton,getElementData(thebutton,"buttonimageon"))
				guiSetVisible(getElementData(thebutton,"offtext"),false)
				guiSetVisible(getElementData(thebutton,"ontext"),true)
				triggerEvent("onDGSOnOffButtonStateChange",thebutton,thebutton,true)
				return true
			else
				setElementData(thebutton,"states","off")
				guiStaticImageLoadImage(thebutton,getElementData(thebutton,"buttonimageoff"))
				guiSetVisible(getElementData(thebutton,"ontext"),false)
				guiSetVisible(getElementData(thebutton,"offtext"),true)
				triggerEvent("onDGSOnOffButtonStateChange",thebutton,thebutton,false)
				return true
			end
		end
	end
	return false
end

function dgsGetOnOffButtonState(thebutton)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-onoffbutton" then
			local onoff = getElementData(thebutton,"states")
			local onoffs
			if onoff == "on" then
				onoffs = true
			end
			if onoff == "off" then
				onoffs = false
			end
			return onoffs
		end
	end
	return false
end

function dgsCreateButton(x,y,width,height,text,relative,parent,buttonimage,selimage,cliimage,shadow)
	if x and y and width and height and text then
		local dgsbuttonsx = guiCreateStaticImage(x,y,width,height,buttonimage or guiButtonSel1,relative,parent)
		setElementData(dgsbuttonsx,"state","up")
		local dgsbutttext,butttextsha
		if shadow then
			dgsbutttextsha = guiCreateLabel(0,0,1,1,tostring(text),true,dgsbuttonsx)
			guiSetEnabled(dgsbutttextsha,false)
			guiLabelSetColor(dgsbutttextsha,0,0,0)
			guiLabelSetVerticalAlign(dgsbutttextsha,"center")
			guiLabelSetHorizontalAlign(dgsbutttextsha,"center")
			dgsbutttext = guiCreateLabel(0,0,1,1,tostring(text),true,dgsbutttextsha)
			guiSetPosition(dgsbutttext,-2,-2,false)
		else
			dgsbutttext = guiCreateLabel(0,0,1,1,tostring(text),true,dgsbuttonsx)
		end
		guiSetEnabled(dgsbutttext,false)
		guiLabelSetVerticalAlign(dgsbutttext,"center")
		guiLabelSetHorizontalAlign(dgsbutttext,"center")
		dgsSetType(dgsbuttonsx,"dgs-button")
		dgsSetType(dgsbutttext,"dgs-buttontext")
		setElementData(dgsbuttonsx,"shadow",dgsbutttextsha)
		setElementData(dgsbuttonsx,"b-text",dgsbutttext)
		setElementData(dgsbuttonsx,"buttonimage1",buttonimage or guiButtonSel1)
		setElementData(dgsbuttonsx,"buttonimage2",selimage or guiButtonSel2)
		setElementData(dgsbuttonsx,"buttonimage3",cliimage or guiButtonSel3)
		setElementData(dgsbuttonsx,"clickable",true)
		return dgsbuttonsx
	end
	return false
end

function dgsSetButtonState(thebutton,state)
-----state = true 是按下，反之为没按下
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-button" then
			if state ~= true then
				setElementData(thebutton,"state","up")
				guiStaticImageLoadImage(thebutton,getElementData(thebutton,"buttonimage1"))
				return true
			else
				setElementData(thebutton,"state","down")
				guiStaticImageLoadImage(thebutton,getElementData(thebutton,"buttonimage3"))
				return true
			end
		end
	end
	return false
end

function dgsGetButtonState(thebutton)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-button" then
			return getElementData(thebutton,"state")
		end
	end
	return false
end

function dgsSetButtonClickable(thebutton,tof)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-button" then
			return setElementData(thebutton,"clickable",toboolean(tof))
		end
	end	
end

function dgsGetButtonClickable(thebutton)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-button" then
			return getElementData(thebutton,"clickable")
		end
	end	
end

function dgsGetButtonText(thebutton)
	if isElement(thebutton) then
		if dgsGetType(thebutton) == "dgs-button" then
			local textele = getElementData(thebutton,"b-text")
			if isElement(textele) then
				return guiGetText(textele)
			end
		end
	end
	return false
end

function dgsSetButtonText(thebutton,string)
	if isElement(thebutton) and tostring(string) then
		if dgsGetType(thebutton) == "dgs-button" then
			local textele = getElementData(thebutton,"b-text")
			if isElement(textele) then
				local shadow = getElementData(thebutton,"shadow")
				if isElement(shadow) then
					return guiSetText(textele,tostring(string)) and guiSetText(shadow,tostring(string))
				else
					return guiSetText(textele,tostring(string))
				end
			end
		end

	end
	return false
end

function dgsCreateWindow(x,y,width,height,name,relative,mode,tabl,tabm,tabr,background,distab,closemode,noclose,textshadow)
	windowimages = windowimages or windowimage
	background = background or backg1
	closemode = closemode or 0
	if x and y and width and height then
		relative = relative or false
		local window = guiCreateStaticImage(x,y,width,height,background,relative)
		dgsSetType(window,"dgs-window")
		local sx,sy = guiGetSize(window,false)
		if not distab then
			local xxx,yyy = guiGetSize(window,false)
			local tab = guiCreateStaticImage(0,0,sx,25,alphaSel,false,window)
			dgsSetType(tab,"dgs-windowtab")
			local titlel = guiCreateStaticImage(0,0,8,25,tabl or windowimage,false,tab)
			local titlem = guiCreateStaticImage(8,0,sx-16,25,tabm or windowimage,false,tab)
			local titler = guiCreateStaticImage(sx-8,0,8,25,tabr or windowimage,false,tab)
			guiSetEnabled(titlel,false)
			guiSetEnabled(titlem,false)
			guiSetEnabled(titler,false)
			if textshadow then
				mylabel = guiCreateLabel(0,0,1,1,name or "",true,titlem)
				guiLabelSetColor(mylabel,0,0,0)
				parentlabel = guiCreateLabel(-2,-2,pxxx,pyyy,name or "",false,mylabel)
				setElementData(window,"titleshadow",parentlabel)
			else
				mylabel = guiCreateLabel(0,0,1,1,name,true,titlem)
			end
			guiSetEnabled(mylabel,false)
			dgsSetType(mylabel,"dgs-windowname")
			setElementData(window,"titlename",name)
			guiLabelSetVerticalAlign(mylabel,"center")
			guiLabelSetHorizontalAlign(mylabel,"center")
			if not noclose then
				local px,py = guiGetPosition(titlem,false)
				cbsb = guiCreateStaticImage(px-35,2.5,20,20,alphaSel,false,tab)
				closebutton = guiCreateStaticImage(0,0,3,1.97,guiButtonSel,true,cbsb)
				dgsSetType(cbsb,"dgs-closebuttonbg")
				dgsSetType(closebutton,"dgs-closebutton")
				guiSetAlpha(closebutton,0.6)
				setElementData(cbsb,"isdpguiw",false)
				setElementData(cbsb,"dpguixr",false)
				setElementData(closebutton,"dpguixr",1)
				setElementData(closebutton,"isdpguiw",false)
			end
			setElementData(window,"windowtabs",tab)
			setElementData(window,"windowtabsl",titlel)
			setElementData(window,"windowtabsm",titlem)
			setElementData(window,"windowtabsr",titler)
			setElementData(window,"windowclos",cbsb)
			setElementData(window,"windowlabs",mylabel)
			setElementData(window,"closeMode",closemode)
			setElementData(window,"dpWindowCanMove",true)
			triggerEvent("dgsWindowCreate",window,window)
		end
		if mode then
			setElementData(window,"mode",true)
		else
			setElementData(window,"mode",false)
		end
		return window
	end
	return false
end

function dgsGetWindowTitleName(dgselement)
	if isElement(dgselement) then
		if dgsGetType(dgselement) == "dgs-window" then
			return getElementData(dgselement,"titlename")
		end
	end
	return false
end

function dgsSetWindowTitleName(dgselement,name)
	local name = tostring(name)
	if isElement(dgselement) then
		if dgsGetType(dgselement) == "dgs-window" then
			local title = getElementData(dgselement,"windowlabs")
			if isElement(title) then
				local shadow = getElementData(dgselement,"titleshadow")
				if isElement(shadow) then
					return guiSetText(shadow,tostring(name))
				end
				return guiSetText(title,tostring(name))
			end
		end
	end
	return false
end

addEventHandler("onClientGUISize",guiRoot,function()
	if dgsGetType(source) == "dgs-tabpanel" then
		local tabbgs = getElementData(source,"tabbg")
		local x,y = guiGetPosition(source,false)
		local sx,sy = guiGetSize(source,false)
		guiSetPosition(tabbgs,x,y-40,false)
		guiSetSize(tabbgs,sx,20,false)
	end
	if dgsGetType(source) == "dgs-window" and getElementType(source) == "gui-staticimage" then
		local titlel = getElementData(source,"windowtabsl")
		local titlem = getElementData(source,"windowtabsm")
		local titler = getElementData(source,"windowtabsr")
		local tab = getElementData(source,"windowtabs")
		if isElement(titlel) then
			local sx,sy = guiGetSize(source,false)
			guiSetSize(tab,sx,25,false)
			guiSetSize(titlem,sx-16,25,false)
			guiSetPosition(titler,sx-8,0,false)
		end
		local mytabs = getElementData(source,"windowtabs")
		local mylabs = getElementData(source,"windowlabs")
		local myclos = getElementData(source,"windowclos")
		if isElement(mytabs) and isElement(mylabs) then
			local sx,sy = guiGetSize(source,false)
			if isElement(myclos) then
				guiSetPosition(myclos,sx-35,2,false)
			end
			local sx,sy = guiGetSize(source,false)
			guiSetSize(mylabs,sx-35,20,false)
			local sx,sy = guiGetSize(source,false)
			guiSetSize(mytabs,sx,25,false)
		end
	end
end)

function isDgsElement(element)
	if element then
		if getElementType(element) then
			return element
		end
	end
	return false
end

addEventHandler("onClientMouseEnter",root,function()
	enterElement = source
	local sourcepare = getElementParent(source)
	if getElementData(source,"dpguixr") == 1 then
		guiSetPosition(source,0,0,true)
		guiSetAlpha(source,1)
	end
	if dgsGetType(source) == "dgs-button" then
		if getElementData(source,"state") == "down" then
			guiStaticImageLoadImage(source,getElementData(source,"buttonimage3"))
		else
			guiStaticImageLoadImage(source,getElementData(source,"buttonimage2"))
			if dgsSou["enter"] == true then
				playSound(dgsSound["enter"])
			end
		end
	end
	if dgsGetType(source) == "dgs-tab" then
		local mytabima = getElementData(sourcepare,"tabimage")
		guiStaticImageLoadImage(source,mytabima[2])
		if dgsSou["enter"] == true then
			playSound(dgsSound["enter"])
		end
	end
end)

addEventHandler("onClientMouseLeave",root,function()
	enterElement = nil
	local sourcepare = getElementParent(source)
	if getElementData(source,"dpguixr") == 1 then
		guiSetPosition(source,0,0,true)
		guiSetAlpha(source,0.6)
	end
	if dgsGetType(source) == "dgs-button" then
		if getElementData(source,"state") == "down" then
			guiStaticImageLoadImage(source,getElementData(source,"buttonimage3"))
		else
			guiStaticImageLoadImage(source,getElementData(source,"buttonimage1"))
		end
	end
	if dgsGetType(source) == "dgs-tab" then
		local mytabima = getElementData(sourcepare,"tabimage")
		if getElementData(sourcepare,"selectedid") == getElementData(source,"tabid") then	
		guiStaticImageLoadImage(source,mytabima[3])
		else
		guiStaticImageLoadImage(source,mytabima[1])
		end
	end
end)

addEventHandler("dgsMoveComplete",root,function(guiw,_,_,_,_,_,_,_,name)
	if name == "WindowClose" then
		if getElementData(source,"closeMode") == 0 then
			destroyElement(source)
			guiw = nil
		elseif getElementData(source,"closeMode") == 1 then
			guiSetVisible(source,false)
		end
	end
end)


--------------WindowMove
function dgsWindowSetMovable(dpgui,tof)
	if tof then
		setElementData(dpgui,"dpWindowCanMove",tof)
		return true
	end
	return false
end

function dpGuiMove(button,abx,aby)
	if source and button == "left" then
		if getElementData(source,"dpguixr") == 1 then
			guiSetPosition(source,0,-1,true)
		end
		if dgsGetType(source) == "dgs-button" then
			if getElementData(source,"clickable") == true then
				guiStaticImageLoadImage(source,getElementData(source,"buttonimage3"))
			end
			triggerEvent("onClientDGSClick",source,button,"down",abx,aby)
			if dgsSou["click"] == true then
				playSound(dgsSound["click"])
			end
		end
		if dgsGetType(source) == "dgs-windowtab" then
			if getElementData(source,"dpWindowCanMove") then
				addEventHandler("onClientRender",root,thewindows)
				clickthefuckwindow = getElementParent(source)
			end
			locsdisx,locsdisy = getDistanceBetweenGuiAndCursor(clickthefuckwindow,true)
			triggerEvent("onClientDGSClick",source,button,"down",abx,aby)
		end
		if dgsGetType(source) == "dgs-tab" then
			dgsSetSelectedTab(getElementData(source,"myparent"),getElementData(source,"tabid"))
			if dgsSou["click"] == true then
				playSound(dgsSound["click"])
			end
		end
		local myfuckingp = source
		for i=1,30 do
			if isElement(myfuckingp) then
				if dgsGetType(myfuckingp) == "dgs-tabbackground" then
					guiBringToFront(getElementData(source,"myparent"))
				end
			end
		end
		if dgsGetType(source) == "dgs-horizontaltabpanelbutton" then
			dgsSetSelectedHorizontalTab(getElementData(thegridlist,"myparent"),getElementData(source,"tabid"))
		end
	end
end
addEventHandler("onClientGUIMouseDown",root,dpGuiMove)

function dpGuiMoved(button)
	if button == "left" then
		clickthefuckwindow = nil
		removeEventHandler("onClientRender",root,thewindows)
		if dgsGetType(source) == "dgs-button" then
			if enterElement == source then
				if getElementData(source,"state") == "down" then
					guiStaticImageLoadImage(source,getElementData(source,"buttonimage3"))
				else
					guiStaticImageLoadImage(source,getElementData(source,"buttonimage2"))
				end
			else
				if getElementData(source,"state") == "down" then
					guiStaticImageLoadImage(source,getElementData(source,"buttonimage3"))
				else
					guiStaticImageLoadImage(source,getElementData(source,"buttonimage1"))
				end
			end
		end
		if dgsGetType(source) == "dgs-onoffbutton" then
			dgsSetOnOffButtonState(source,not dgsGetOnOffButtonState(source))
		end
		if dgsGetType(source) == "dgs-tab" then
			local mytabima = getElementData(getElementParent(source),"tabimage")
			guiStaticImageLoadImage(source,mytabima[2])
		end
		if getElementData(source,"dpguixr") == 1 then
			local theparent = getElementParent(getElementParent(getElementParent(source)))
			if getElementData(theparent,"mode") == true then
				tox,toy = dgsGetPosition(theparent,true)
			else
				tox,toy = guiGetPosition(theparent,true)
			end
			dgsSetAnim(theparent,tox,toy,0,0,0.1,true,guiGetAlpha(theparent),0,true,"WindowClose")
			triggerEvent("dgsWindowClose",theparent,theparent)
		end
	end
end
addEventHandler("onClientGUIMouseUp",root,dpGuiMoved)

function getDistanceBetweenGuiAndCursor(element,tf)
	if element then
		if isCursorShowing() then
			tf = tf or false
			local cx, cy = getCursorPosition()
			if not tf then
				cx,cy = cx*sW,cy*sH
			end
			local gx, gy = dgsGetGuiPositionOnScreen2(element,tf)
			local danx = cx-gx
			local dany = cy-gy
			return danx,dany
		end
	end
	return false
end

function thewindows()
	if clickthefuckwindow then
		if isCursorShowing() then
			local gxx, gyy = getCursorPosition()
			guiSetPosition(clickthefuckwindow,gxx-locsdisx,gyy-locsdisy,true)
		else
			removeEventHandler("onClientRender",root,thewindows)
			clickthefuckwindow = false
		end
	end
end

function dgsCloseWindow(element)
	if isElement(element) then
		local tox,toy = 
		dgsSetAnim(element,0.5,0.5,0,0,0.1,true,a,0,true,"WindowClose")
		triggerEvent("dgsWindowClose",element,element)
	end
end


function dgsGetGuiPositionOnScreen(nimaDie,mode,relative)
	if isElement(nimaDie) then
		local guielex,guieley,guielex2,guieley2
		if mode and getElementParent(nimaDie) == guiRoot then
			guielex,guieley = dgsGetPosition(nimaDie,false)
		else
			guielex,guieley = guiGetPosition(nimaDie,false)
		end
		for i=1,100 do
			nimaDie = getElementParent(nimaDie)
			if not isElement(nimaDie) or getElementType(nimaDie) == "guiroot" then
				break
			end
			guielex2,guieley2 = guiGetPosition(nimaDie,false)
			guielex = guielex+guielex2
			guieley = guieley+guieley2
		end
		if relative then
			return guielex/sW,guieley/sH
		else
			return guielex,guieley
		end
	end
	return false
end

function dgsGetGuiPositionOnScreen2(nimaDie,relative)
	if isElement(nimaDie) then
		local guielex,guieley,guielex2,guieley2
		local guielex,guieley = guiGetPosition(nimaDie,false)
		for i=1,100 do
			nimaDie = getElementParent(nimaDie)
			if not isElement(nimaDie) or getElementType(nimaDie) == "guiroot" then
				break
			end
			guielex2,guieley2 = guiGetPosition(nimaDie,false)
			guielex = guielex+guielex2
			guieley = guieley+guieley2
		end
		if relative then
			return guielex/sW,guieley/sH
		else
			return guielex,guieley
		end
	end
	return false
end

function dgsGetGuiRealSize(nimaDie,relative)
	if isElement(nimaDie) then
		local guielex,guieley = guiGetSize(nimaDie,true)
		for i=1,100 do
			nimaDie = getElementParent(nimaDie)
			if not isElement(nimaDie) or getElementType(nimaDie) == "guiroot" then
				break
			end
			guielex2,guieley2 = guiGetSize(nimaDie,true)
			guielex = guielex*guielex2
			guieley = guieley*guieley2
		end
		if relative then
			return guielex,guieley
		else
			return guielex*sW,guieley*sH
		end
	end
	return false
end

function dgsGetGuiRealPosition(nimaDie,relative)
	if isElement(nimaDie) then
		local guielex,guieley = guiGetPosition(nimaDie,false)
		local guicount
		for i=1,100 do
			nimaDie = getElementParent(nimaDie)
			if not isElement(nimaDie) or getElementType(nimaDie) == "guiroot" then
				break
			end
			guielex2,guieley2 = guiGetPosition(nimaDie,false)
			guielex = guielex+guielex2
			guieley = guieley+guieley2
		end
		if relative then
			return guielex/sW,guieley/sH
		else
			return guielex,guieley
		end
	end
	return false
end

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
			dgsStaticImageLoadImage(showMessageBackGround,"Images/tips/"..messagetype.."_d.png")
		else
			showMessageBackGround = dgsCreateBackGround(0.35,0.05,0.3,0.125,"Images/tips/"..messagetype.."_d.png",true)
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

addEventHandler("onClientRender",root,function()
	if isElement(showMessageBackGround) then
		local alpha = guiGetAlpha(showMessageBackGround)
		local x,y = guiGetPosition(showMessageBackGround,false)
		local sx,sy = guiGetSize(showMessageBackGround,false)
		local text = getElementData(showMessageBackGround,"text")
		local color = getElementData(showMessageBackGround,"color")
		dxDrawText(text,x+0.22*x+2,y+2,sx+x-x*0.04+2,sy+y+2,tocolor(0,0,0,alpha*255),(sx/sW)*(sH/sW)*12,(sy/sH)*13,"clear","left","center",true,true,true)
		dxDrawText(text,x+0.22*x,y,sx+x-x*0.04,sy+y,tocolor(color[1],color[2],color[3],alpha*255),(sx/sW)*(sH/sW)*12,(sy/sH)*13,"clear","left","center",true,true,true)
	end
end)

addCommandHandler("dgs",function()
	dgsProgress = 0	
	dgsPx,dgsPy,dgsSx,dgsSy = 0.1,0.2,0.8,0.6
	dgsAlp = 0
end)

addEventHandler("onClientRender",root,function()
	if dgsProgress then
		if dgsAlp < 255 then
			dgsAlp = dgsAlp + 3
		end
		if dgsAlp > 255 then
			dgsAlp = 255
		end
		if dgsPx < 0.3 then
			dgsPx = dgsPx + 0.01
			dgsSx = dgsSx - 0.02
		else
			dgsPx = 0.3
			dgsSx = 0.4
		end
		if dgsPy < 0.4 then
			dgsPy = dgsPy + 0.01
			dgsSy = dgsSy - 0.02
		else
			dgsPy = 0.4
			dgsSy = 0.2
		end
		dxDrawImageSection(sW*dgsPx,sH*dgsPy,sW*dgsSx,sH*dgsSy,1,1,490,175,"dgsimg/logo.png",0,0,0,tocolor(200,200,200,dgsAlp*0.7))
		dxDrawImageSection(sW*dgsPx,sH*dgsPy,sW*dgsSx*dgsProgress/100,sH*dgsSy,1,1,490*dgsProgress/100,175,"dgsimg/logo.png",0,0,0,tocolor(0,255-205*dgsProgress/100,70+185*dgsProgress/100,dgsAlp))
		if dgsPx == 0.3 and dgsPy == 0.4 then
			dgsProgress = dgsProgress + 0.1
			if dgsProgress >= 100 then
				dgsProgress = 100
				dxDrawText("系统启动成功 "..math.floor(dgsProgress).."% ...",2,sH*(dgsPy+dgsSy-0.18*dgsSy)+2,sW,sH,tocolor(0,0,0,255),1,"default-bold","center")
				dxDrawText("系统启动成功 "..math.floor(dgsProgress).."% ...",0,sH*(dgsPy+dgsSy-0.18*dgsSy),sW,sH,tocolor(255,255,255,255),1,"default-bold","center")
			else
				dxDrawText("正在启动DP操作系统 "..math.floor(dgsProgress).."% ...",2,sH*(dgsPy+dgsSy-0.18*dgsSy)+2,sW,sH,tocolor(0,0,0,255),1,"default-bold","center")
				dxDrawText("正在启动DP操作系统 "..math.floor(dgsProgress).."% ...",0,sH*(dgsPy+dgsSy-0.18*dgsSy),sW,sH,tocolor(255,255,255,255),1,"default-bold","center")

			end	
		end
	end
end)

function dgsFindFile(path)
	if path then
		if not fileExists(path) then
			path = "temp/"..path
		end
	end
	return path
end

fileDelete("codes.lua")