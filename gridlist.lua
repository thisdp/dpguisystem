rowelements = {}
rowimages = {}
colelements = {}
gldefault = {columnLong=5,columnCount=0,selectedid=-1}

function dgsGridListSetImage(parent,data)
	if dgsGetType(parent) == "dgs-gridlist" then
		if type(rowimages) == "table" then
			rowimages[parent] = data
		end
	end
end

function dgsGridListGetImage(parent)
	if dgsGetType(parent) == "dgs-gridlist" then
		if rowimages[parent] then
			return rowimages[parent]
		end
	end
	return false
end

function dgsGridListSetData(parent,data)
	if dgsGetType(parent) == "dgs-gridlist" then
		if type(data) == "table" then
			rowelements[parent] = data
		end
	end
end

function dgsGridListGetData(parent)
	if dgsGetType(parent) == "dgs-gridlist" then
		if rowelements[parent] then
			return rowelements[parent]
		end
	end
	return false
end

function dgsGridListColumnSetData(parent,data)
	if dgsGetType(parent) == "dgs-gridlist" then
		if type(data) == "table" then
			colelements[parent] = data
		end
	end
end

function dgsGridListColumnGetData(parent)
	if dgsGetType(parent) == "dgs-gridlist" then
		if colelements[parent] then
			return colelements[parent]
		end
	end
	return false
end

--[[
x,y : position
width,height : size
rowht : row height
image :background image
image2 :column background image
relative,parent(see wiki)
sbhwid :the width of vertical scrollbar
sbwwid :the width of horizontal scrollbar
dr :the default row state image
cr :the clicked row state image
sr :the selected row state image
]]
function dgsCreateGridList(x,y,width,height,rowht,image,image2,relative,parent,sbhwid,sbwwid,dr,cr,sr)
	if x and y and width and height then
		relative = relative or false
		local dpguigridlist = guiCreateStaticImage(x,y,width,height,dgsFindFile(image) or alphaSel,relative,parent)
		local sizx,sizy = guiGetSize(dpguigridlist,false)
		local dpguibackg = guiCreateStaticImage(20,15,sizx-40,sizy-35,alphaSel,false,dpguigridlist)
		local dpguicolum = guiCreateStaticImage(20,0,sizx-40,15,dgsFindFile(image2) or alphaSel,false,dpguigridlist)
		local scrollbh = dgsCreateScrollBar(sizx-20,0,sbhwid or 20,sizy-20,_,false,false,dpguigridlist)
		local scrollbw = dgsCreateScrollBar(0,sizy-20,sizx-20,sbwwid or 20,_,true,false,dpguigridlist)
		guiSetVisible(scrollbh,false)
		guiSetVisible(scrollbw,false)
		dgsSetType(dpguicolum,"dgs-gridlistCol")
		dgsSetType(dpguibackg,"dgs-gridlistrowlist")
		dgsSetType(dpguigridlist,"dgs-gridlist")
		setElementData(dpguigridlist,"columnbg",dpguicolum)
		setElementData(dpguigridlist,"melist",dpguigridlist)
		setElementData(dpguigridlist,"height",rowht)
		setElementData(dpguigridlist,"rowlist",dpguibackg)
		setElementData(dpguigridlist,"optional",true)
		setElementData(dpguigridlist,"myimage",{dgsFindFile(dr) or defaultrow,dgsFindFile(cr) or changerow,dgsFindFile(sr) or selectrow})
		local scrollbars = {}
		scrollbars["width"] = scrollbw
		scrollbars["height"] = scrollbh
		setElementData(dpguigridlist,"scrollbars",scrollbars)
		dgsGridListSetData(dpguigridlist,{})
		dgsGridListColumnSetData(dpguigridlist,{})
		setElementData(dpguigridlist,"nowshows",{})
		for k,v in pairs(gldefault) do
			setElementData(dpguigridlist,k,v)
		end
		return dpguigridlist
	end
	return false
end

function dgsGridListAddColumn(parent,name,length,r,g,b)
	r,g,b = tonumber(r) or 255,tonumber(g) or 255,tonumber(b) or 255
	if parent then
		length,name = length or "",name or ""
		local columns = dgsGridListColumnGetData(parent)
		local sx,sy = guiGetSize(parent,false)
		local px,py = guiGetPosition(parent,false)
		local columnsd = guiCreateLabel(dgsGetColumnLength(parent),0,length*sx,20,name,false,getElementData(parent,"columnbg"))
		local columntx = guiCreateLabel(-2,-2,sW,20,name,false,columnsd)
		guiSetEnabled(columnsd,false)
		guiLabelSetColor(columnsd,0,0,0)
		guiLabelSetColor(columntx,r,g,b)
		dgsSetType(columnsd,"dgs-column")
		dgsGridListColumnSetData(parent,table.insert(columns,columnsd))
		local text = dgsGridListGetData(parent)
		for k,v in ipairs(text) do
			local sizex = guiGetSize(dgsGetRowElementByID(parent,i))
			local lab = guiCreateLabel(leng,0,leng+sizex,1,"",true,image)
			guiSetEnabled(lab,false)
			guiLabelSetVerticalAlign(lab,"center")
			text[columnCount] = ""
		end
		dgsGridListSetData(parent,text)
		local leng = guiGetSize(getElementData(parent,"columnbg"),false)
		local hscr = getElementData(parent,"scrollbars")
		local length = dgsGetColumnLength(parent)
		if length < leng then
			if hscr then
				if isElement(hscr["width"]) then
					guiSetVisible(hscr["width"],false)
				end
			end
		else
			if hscr then
				if isElement(hscr["width"]) then
					guiSetVisible(hscr["width"],true)
				end
			end
		end
		return #columns+1
	end
	return false
end

function dgsGetColumnLength(gridlist,tof,id)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local column = getElementData(gridlist,"columnbg")
		local sx = guiGetSize(column,false)
		local length = gldefault.columnLong
		if isElement(column) then
			if id == 0 then
				if tof then
					return length/sx
				end
				return length
			end
			for k,v in ipairs(dgsGridListColumnGetData(gridlist)) do
				if dgsGetType(v) == "dgs-column" then
					local x = guiGetSize(v,false)
					length = length+x
				end
				if id then
					if id == k then
						break
					end
				end
			end
			if tof then
				return length/sx
			else
				return length
			end
		end
	end
	return false
end

function dgsGetColumnElementByID(gridlist,id)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		if type(id) == "number" then
			local columnbg = getElementData(gridlist,"columnbg")
			if isElement(columnbg) then
				for k,v in ipairs(dgsGridListColumnGetData(gridlist)) do
					if getElementData(v,"columnID") == id then
						return v
					end
				end
			end
		end
	end
	return false
end

function dgsGetRowElementByID(gridlist,id)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		if type(id) == "number" then
			local rowlist = getElementData(gridlist,"rowlist")
			if isElement(rowlist) then
				for k,v in ipairs(dgsGridListGetData(gridlist) or {}) do
					if k == id then
						return v
					end
				end
			end
		end
	end
	return false
end

function dgsGetShowRowHeights(gridlist,tof,id)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local length = 0
		local row = getElementData(gridlist,"rowlist")
		if isElement(row) then
			for k,v in pairs(dgsGridListGetData(gridlist) or {}) do
				if dgsGetType(v) == "dgs-row" then
					local _,x = guiGetSize(v,tof or false)
					length = length+x
				end
				if id then
					if id == k then
						break
					end
				end
			end
			return length
		end
	end
	return false
end

function dgsGetRowAllHeights(gridlist,tof,id)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local row = getElementData(gridlist,"rowlist")
		if isElement(row) then
			if tof then
				local _,sy = guiGetSize(gridlist,false)
				return getElementData(gridlist,"height")*(tonumber(id) or #dgsGridListGetData(gridlist))/sy
			else
				return getElementData(gridlist,"height")*(tonumber(id) or #dgsGridListGetData(gridlist))
			end
		end
	end
	return false
end

function dgsGridListAddRow(parent,numbers,pos)
	if dgsGetType(parent) == "dgs-gridlist" then
		if #dgsGridListColumnGetData(parent) > 0 then
			local list = getElementData(parent,"rowlist")
			local sx,sy = guiGetSize(list,false)
			local height = getElementData(list,"height")
			local mytable = dgsGridListGetData(parent)
			local mytablecount = #mytable or 0
			local nowshows = getElementData(parent,"nowshows")
			local images = getElementData(parent,"myimage")
			nowshows[1] = nowshows[1] or 1
			nowshows[2] = nowshows[2] or 1
			for ir=1,(numbers or 1) do
				local nrow = (pos or mytablecount)+ir-1
				local hscr = getElementData(parent,"scrollbars")
				local rowheight = (mytablecount+ir-1)*height
				local image
				local showrow
				if rowheight-height*2 <= sy then
					image = guiCreateStaticImage(0,height*nrow,sx,height,images[1],false,list)
					dgsSetType(image,"dgs-row")
					showrow = true
					nowshows[2] = ir
				end
				local texts = {}
				texts[0] = image or false
				for k,v in ipairs(dgsGridListColumnGetData(parent)) do
					if showrow then
						local leng = dgsGetColumnLength(parent,true,k-1)
						local sizex = guiGetSize(v,true)
						local lab = guiCreateLabel(leng,0,leng+sizex,1,"",true,image)
						guiSetEnabled(lab,false)
						guiLabelSetVerticalAlign(lab,"center")
					end
					texts[k] = ""
				end
				table.insert(mytable,nrow+1,texts)
				if rowheight <= sy then
					if hscr then
						if isElement(hscr["height"]) then
							guiSetVisible(hscr["height"],false)
						end
					end
				else
					if hscr then
						if isElement(hscr["height"]) then
							guiSetVisible(hscr["height"],true)
						end
					end
				end
			end
			setElementData(parent,"nowshows",nowshows)
			dgsGridListSetData(parent,mytable)
			if pos then
				local hscr = getElementData(parent,"scrollbars")
				local spos = dgsScrollBarSetScrollPosition(hscr["height"],dgsScrollBarGetScrollPosition(hscr["height"]))
			end
			return {mytablecount+1,(numbers or 1)+mytablecount}
		end
	end
	return false
end

addEventHandler("dgsScrollBarScroll",root,function(value,oldvalue)
	local coScrollGridList = coroutine.create(scrollGridList)
	coroutine.resume(coScrollGridList,getElementData(source,"melist"),value,oldvalue)
	--scrollGridList(getElementData(source,"melist"),value,oldvalue)   --debug
end)

function scrollGridList(gridlist,value,oldvalue)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local hscr = getElementData(gridlist,"scrollbars")
		local relement = dgsGridListGetData(gridlist)
		if source == hscr["width"] then
			local collist = getElementData(gridlist,"columnbg")
			local sx = guiGetSize(collist,false)
			local change = oldvalue-value
			local lengall = dgsGetColumnLength(gridlist)
			local nowshows = getElementData(gridlist,"nowshows")
			for k,v in ipairs(dgsGridListColumnGetData(gridlist)) do
				local x = dgsGetColumnLength(gridlist,false,k-1)
				guiSetPosition(v,x-(lengall-sx)/100*value,0,false)
				for i=(nowshows[1] or 1),(nowshows[2] or 1) do
					if relement[i] then
						if isElement(relement[i][0]) then
							local col = getElementChild(relement[i][0],k-1)
							if isElement(col) then
								guiSetPosition(col,x-(lengall-sx)/100*value,0,false)
							end
						end
					end
				end
			end
		elseif source == hscr["height"] then
			local rowlist = getElementData(gridlist,"rowlist")
			local _,sy = guiGetSize(rowlist,false)
			local movemp = dgsGetRowAllHeights(gridlist)
			local height = getElementData(rowlist,"height")
			local changev = oldvalue-value
			local nowshows = getElementData(gridlist,"nowshows")
			local imagedata = getElementData(gridlist,"myimage")
			if changev < 0 then
				for i=1,#relement do
					if isElement(relement[i][0]) then
						local y = (i-1)*height-((movemp-sy)/100*value)
						if y < 0 then
							y = y - 1
						end
						tableid = i
						if y+height < 0 then
							tableid = dgsFindEmptyRowTable(gridlist,i,1)
							if tableid then
								nowshows[1] = nowshows[1]+1
								nowshows[2] = nowshows[2]+1
								local _,smy = guiGetPosition(relement[tableid-1][0],false)
								local temp = relement[i][0]
								local setimage = true
								if i == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,i) or imagedata
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
									setimage = false
								end
								relement[i][0] = false
								relement[tableid][0] = temp
								if tableid == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or imagedata
									guiStaticImageLoadImage(temp,myimage[2] or imagedata[2])
									setimage = false
								end
								if setimage then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or {}
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
								end
								y = (tableid-1)*height-((movemp-sy)/100*value)
								local labels = dgsGetRowTextLabels(gridlist,tableid)
								for k,v in ipairs(labels or {}) do
									guiSetText(v,relement[tableid][k])
								end
								dgsGridListSetData(gridlist,relement)
							else
								tableid = i
							end
						end
						guiSetPosition(relement[tableid][0],0,y,false)
					end
				end
			elseif changev > 0 then
				for i=#relement,1,-1 do
					if isElement(relement[i][0]) then
						local y = (i-1)*height-((movemp-sy)/100*value)
						if y < 0 then
							y = y - 1
						end
						tableid = i
						if y-height > sy then
							tableid = dgsFindEmptyRowTable(gridlist,i,-1)
							if tableid then
								nowshows[1] = nowshows[1]-1
								nowshows[2] = nowshows[2]-1
								local _,smy = guiGetPosition(relement[tableid+1][0],false)
								local temp = relement[i][0]
								local setimage = true
								if i == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,i) or imagedata
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
									setimage = false
								end
								relement[i][0] = false
								relement[tableid][0] = temp
								if tableid == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or imagedata
									guiStaticImageLoadImage(temp,myimage[2] or imagedata[2])
									setimage = false
								end
								if setimage then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or {}
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
								end
								y = (tableid-1)*height-((movemp-sy)/100*value)
								local labels = dgsGetRowTextLabels(gridlist,tableid)
								for k,v in ipairs(labels or {}) do
									guiSetText(v,relement[tableid][k])
								end
								dgsGridListSetData(gridlist,relement)
							else
								tableid = i
							end
						end
						guiSetPosition(relement[tableid][0],0,y,false)
					end
				end
			elseif changev == 0 then
				for i=#relement,1,-1 do
					if isElement(relement[i][0]) then
						local y = (i-1)*height-((movemp-sy)/100*value)
						if y < 0 then
							y = y - 1
						end
						tableid = i
						if y-height > sy then
							tableid = dgsFindEmptyRowTable(gridlist,i,-1)
							if tableid then
								local _,smy = guiGetPosition(relement[tableid+1][0],false)
								local temp = relement[i][0]
								local setimage = true
								if i == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,i) or imagedata
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
									setimage = false
								end
								relement[i][0] = false
								relement[tableid][0] = temp
								if tableid == dgsGridListGetSelectedItem(gridlist) then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or imagedata
									guiStaticImageLoadImage(temp,myimage[2] or imagedata[2])
									setimage = false
								end
								if setimage then
									local myimage = dgsGridListGetRowImage(gridlist,tableid) or {}
									guiStaticImageLoadImage(temp,myimage[1] or imagedata[1])
								end
								y = (tableid-1)*height-((movemp-sy)/100*value)
								local labels = dgsGetRowTextLabels(gridlist,tableid)
								for k,v in ipairs(labels or {}) do
									guiSetText(v,relement[tableid][k])
								end
								dgsGridListSetData(gridlist,relement)
							else
								tableid = i
							end
						end
						if i*height < sy then
							guiSetPosition(relement[tableid][0],0,y,false)
						end
					end
				end
			end
			setElementData(gridlist,"nowshows",nowshows)
		end
	end
end

function dgsFindEmptyRowTable(gridlist,startid,pom)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		if tonumber(startid) then
			local ttable = dgsGridListGetData(gridlist)
			local ttablec = #ttable
			repeat
				startid = startid + (tonumber(pom) or 0)
				if startid < 0 and startid > ttablec then
					startid = false
					break
				end
				if not ttable[startid] then
					startid = false
					break
				end
			until (not isElement(ttable[startid][0]))
			return startid
		end
	end
	return false
end

function dgsGridListGetSelectedItem(parent)
	if parent then
		return getElementData(parent,"selectItem") or -1
	end
	return false
end

function dgsGridListSetSelectedItem(parent,itemid)
	if isElement(parent) then
		itemid = tonumber(itemid)
		if itemid then
			if getElementData(parent,"optional") or itemid == -1 then
				local rowtable = dgsGridListGetData(parent)
				local oldrow = getElementData(parent,"selectItem")
				local images = getElementData(parent,"myimage")
				if oldrow then
					if rowtable[oldrow] then
						if isElement(rowtable[oldrow][0]) then
							local img = dgsGridListGetRowImage(parent,oldrow) or {}
							guiStaticImageLoadImage(rowtable[oldrow][0],img[1] or images[1])
						end
					end
				end
				if rowtable then
					if itemid < 0 then
						setElementData(parent,"selectItem",-1)
						return true
					end
					if itemid <= (#rowtable) and itemid > 0 then
						local img = dgsGridListGetRowImage(parent,itemid) or {}
						guiStaticImageLoadImage(rowtable[itemid][0],img[2] or images[2])
						setElementData(parent,"selectItem",itemid)
						return true
					end
				end
			else
				return false,"optional:disable"
			end
		end
	end
	return false
end

function dgsGridListSetItemText(gridlist,row,column,text)
	if dgsGetType(gridlist) == "dgs-gridlist" and type(column) == "number" and text and type(row) == "number" then
		if column ~= 0 then
			local texts = dgsGridListGetData(gridlist)
			if texts[row] then
				if texts[row][column] then
					texts[row][column] = text
					local labels = dgsGetRowTextLabels(gridlist,row)
					if labels then
						if isElement(labels[column]) then
							guiSetText(labels[column],text)
						end
					end
					dgsGridListSetData(gridlist,texts)
					triggerEvent("dgsGridListTextChange",gridlist,row,column,text)
					return true
				end
			end
		end
	end
	return false
end

function dgsGridListGetItemText(gridlist,row,column)
	if dgsGetType(gridlist) == "dgs-gridlist" and type(column) == "number" and type(row) == "number" then
		local texts = dgsGridListGetData(gridlist)
		if texts[row] then
			if texts[row][column] then
				return texts[row][column]
			end
		end
	end
	return false
end

function dgsGridListSetRowImage(gridlist,row,def,clik,sel)
	if dgsGetType(gridlist) == "dgs-gridlist" and type(row) == "number" then
		local texts = dgsGridListGetImage(gridlist) or {}
		texts[row] = {dgsFindFile(def) or defaultrow,dgsFindFile(clik) or changerow,dgsFindFile(sel) or selectrow}
		dgsGridListSetImage(gridlist,texts)
		local nowshows = getElementData(gridlist,"nowshows")
		if row >= nowshows[1] and row <= nowshows[2] then
			local relement = dgsGridListGetData(gridlist)
			if relement[row] then
				if isElement(relement[row][0]) then
					local default = true
					if dgsGridListGetSelectedItem(gridlist) == row then
						guiStaticImageLoadImage(relement[row][0],texts[row][2])
						default = false
					end
					if isElement(denterelement) then
						if dgsGetRowID(denterelement) then
							guiStaticImageLoadImage(relement[row][0],texts[row][3])
							default = false
						end
					end
					if default then
						guiStaticImageLoadImage(relement[row][0],texts[row][1])	
					end
				end
			end
		end
		triggerEvent("dgsGridListImageChange",gridlist,row,path)
		return true
	end
	return false
end

function dgsGridListGetRowImage(gridlist,row)
	if dgsGetType(gridlist) == "dgs-gridlist" and type(row) == "number" then
		local texts = dgsGridListGetImage(gridlist) or {}
		if texts[row] then
			return texts[row] or getElementData(gridlist,"myimage")
		end
	end
	return false
end

function dgsGetRowTextLabels(gridlist,row)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local rowdata = dgsGridListGetData(gridlist)
		if rowdata[row] then
			if isElement(rowdata[row][0]) then
				local rowst = {}
				local count = 0
				for k,v in pairs(getElementChildren(rowdata[row][0])) do
					if getElementType(v) == "gui-label" then
						count = count + 1
						rowst[count] = v
					end
				end
				return rowst
			end
		end
	end
	return false
end

function dgsGridListSetOptional(gridlist,bool)
	local dgstyp,typx = dgsGetType(gridlist)
	assert(dgstyp == "dgs-gridlist","Bad argument @'dgsGridListSetOptional' [Expected dgs-gridlist at argument 1, got "..dgstyp or typx.."]")
	assert(bool == true or bool == false,"Bad argument @'dgsGridListSetOptional' [Expected boolean at argument 2, got "..type(bool).."]")
	dgsGridListSetSelectedItem(gridlist,-1)
	setElementData(gridlist,"optional",bool)
	return true
end

function dgsGridListGetOptional(gridlist)
	local dgstyp,typx = dgsGetType(gridlist)
	assert(dgstyp == "dgs-gridlist","Bad argument @'dgsGridListSetOptional' [Expected dgs-gridlist at argument 1, got "..dgstyp or typx.."]")
	return getElementData(gridlist,"optional")
end

function dgsGridListClear(gridlist)
	if dgsGetType(gridlist) == "dgs-gridlist" then
		local rowlist = getElementData(gridlist,"rowlist")
		if isElement(rowlist) then
			for k,v in ipairs(getElementChildren(rowlist)) do
				destroyElement(v)
			end
		end
		dgsGridListSetData(gridlist,{})
	end
end

function dgsGridListSetColumnTitle(gridlist,column,title)
	if dgsGetType(gridlist) == "dgs-gridlist" and column then
		local columns = dgsGridListColumnGetData(gridlist) or {}
		if isElement(columns[column]) then
			local text = getElementChild(columns[column],0)
			if isElement(text) then
				guiSetText(text,tostring(title))
			end
			guiSetText(columns[column],tostring(title))
			return true
		end
	end
	return false
end

function dgsGridListGetColumnTitle(gridlist,column)
	if dgsGetType(gridlist) == "dgs-gridlist" and column then
		local columns = dgsGridListColumnGetData(gridlist) or {}
		if isElement(columns[column]) then
			return guiGetText(columns[column]) or false
		end
	end
	return false
end

addEvent("dgsClientGUIClick",true)
enterelement,selectelement = false,false
addEventHandler("onClientMouseEnter",root,function()
	denterelement = source
	if dgsGetType(source) == "dgs-row" then
		local rid = dgsGetRowID(source)
		if rid ~= getElementData(source,"selectItem") then
			local gridlist = getElementData(source,"melist")
			local images = dgsGridListGetRowImage(gridlist,rid) or getElementData(source,"myimage")
			guiStaticImageLoadImage(source,images[3])
		end
	end
end)

addEventHandler("onClientMouseLeave",root,function()
	denterelement = false
	if dgsGetType(source) == "dgs-row" then
		local rid = dgsGetRowID(source)
		if rid ~= getElementData(source,"selectItem") then
			local gridlist = getElementData(source,"melist")
			local images = dgsGridListGetRowImage(gridlist,rid) or getElementData(source,"myimage")
			guiStaticImageLoadImage(source,images[1])
		end
	end
end)

addEventHandler("onClientClick",root,function(button,state)
	if isElement(denterelement) then
		dselectelement = denterelement
	else
		dselectelement = false
	end
	triggerEvent("dgsClientGUIClick",dselectelement or root,button,state)
end)

addEventHandler("dgsClientGUIClick",root,function(button,state)
	if button == "left" and state == "down" then
		local rowid = dgsGetRowID(source)
		if rowid then
			local parent = getElementData(source,"melist")
			if isElement(parent) then
				triggerEvent("onClientDGSClick",parent,button,state)
			end
			dgsGridListSetSelectedItem(parent,rowid)
		end
	end
end)

function dgsGetRowID(element)
	if dgsGetType(source) == "dgs-row" then
		local parent = getElementData(source,"melist")
		local rowdata = dgsGridListGetData(parent)
		local nowshows = getElementData(parent,"nowshows")
		for i=nowshows[1],nowshows[2] do
			if rowdata[i] then
				if rowdata[i][0] == source then
					return i
				end
			end
		end
	end
	return false
end

function dgsLoadImage(resn,path)
	if type(resn) == "string" and type(path) == "string" then
		local newpath = resn.."/"..path
		if fileExists(":"..newpath) then
			fileCopy(":"..newpath,"temp/"..path,true)
			return true
		end
	end
	return false
end

fileDelete("gridlist.lua")
