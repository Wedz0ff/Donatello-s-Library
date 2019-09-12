--[[ Donatello's Library ]]--

DONATELLO_LIB = "1.0"
MYDEPOSITER = depotBoxesDepositer
goBack = returnwpt
EFFECT_RESPAWN = 11
POTIONS_TABLE = {7876, 266, 236, 239, 7643, 23375, 268, 237, 238, 23373, 7642, 23374, 7440, 7439, 7443}

function randomInput() -- this is kinda useless tbh.
	setsetting('Settings/MouseMoveSpeed', ''..math.random(7,9))
	setsetting('Settings/ClickWaitTime', ''..math.random(70, 110)..'to'..math.random(180, 230)..' ms')
	setsetting('Settings/TypeWaitTime', ''..math.random(70, 110)..'to'..math.random(180, 230)..' ms')
	setsetting('Settings/PressWaitTime', ''..math.random(70, 110)..'to'..math.random(180, 230)..' ms')
end

function eatFood(time)
	local time = time or math.random(60000, 90000)
	local BETA_11 = 290

	if botversion() >= BETA_11 then
		if $hungry or $foodtime <= time then
			pausewalking(2000)
			eatfoodfull()
			pausewalking(0)
		end
	else
		eatfoodfull() wait(time*2, time*2.7)
	end
end

function depotBoxesDepositer(lootbp, dpstack, dpnormal)

	lootingBp = lootbp
	nonstackableNumber = dpstack
	stackableNumber = dpnormal

	setsetting('Looting/OpenNextBP', 'no')
	waitping()
	closewindows()	wait(1200, 2500)
	while windowcount(lootingBp) == 0 do
		closewindows()	wait(1000, 1900)
		openitem($back.id,'back')	wait(1000, 1900)
		openitem(lootingBp,itemname($back.id),true)	wait(1000, 1900)
		resizewindows() waitping()
	end
	while windowcount("Depot Chest") == 0 do
		opendepot(true)
		wait(1000, 1900)
		openitem(3502)
		wait(1000, 1900)
	end

	depotId = 22796
	stackableId = depotId + stackableNumber
	nonstackableId = depotId + nonstackableNumber

	while (true) do
		foreach lootingitem i do
			while itemcount(i.id, lootingBp) > 0 do
				if itemproperty(i.id, 5) then
					moveitemsonto(i.id, stackableId, 1, 'depot chest', lootingBp, 100) wait(30, 60)
				else
					moveitemsonto(i.id, nonstackableId, 1, 'depot chest', lootingBp, 100) wait(30, 60)
				end
			end
		end
	    if (itemcount(lootingBp, lootingBp) > 0) then
	        openitem(lootingBp, lootingBp, false) 
			waitcontainer(lootingBp, false)
	    else
	        break
	    end
	    wait(100)
	end
	setsetting('Looting/OpenNextBP', 'yes')
end

function waitInvis() -- Usefull for Invisible monsters like lost dwarves, i.e.
	local waitTime = math.random(9000, 11000)
	foreach neweffect e do
		if e.type == 11 and maround(7) == 0 and $battlesigned and $standtime < waitTime then
			pausewalking(waitTime)
		elseif maround(7) > 0 then
			pausewalking(0)
		end
	end
end

function sellitemsarray(...)
	local items = {...}
	opentrade() wait(1000, 1800)
	for _, v in ipairs(items) do
		if tradecount("sell", v) > 0 then
			sellitems(v, tradecount("sell", v)) wait(300, 600)
		end
	end
end

function castSpell(spell)
	if cancast(spell) then
		cast(spell) wait(100, 200)
	end
end

function haste(hasteSpell)
	if not hasteSpell then
		if $vocation == "knight" or $vocation == "paladin" then
			local hasteSpell = "utani hur"
		else
			local hasteSpell = "utani gran hur"
		end
	end
	if not $hasted or $hastetime < math.random(1000, 2500) then
		castSpell(hasteSpell)
	end
end

function buyFoodMarket(foodName, count, buyAmount)
	foodName = foodName or "brown mushroom"
	count = count or 60
	buyAmount = buyAmount or 100

	if itemcount(foodName) < math.random(count-5, count+5) then
		setsetting('Looting/OpenNextBP', 'no')
		openmarket() wait(2000, 2500)
		local totalBuy = buyAmount - count + math.random(0, 10)
		buyitemsmarket(foodName, itemcost(foodName) + 6, totalBuy) wait(2000, 3000)
		closemarket() wait(2000, 2500)
		opendepot(true) wait(1000, 2000)
		openitem("your inbox") wait(800, 1300)
		moveitems(foodName, itemname($back.id), "your inbox", 100) wait(200, 400)
		setsetting('Looting/OpenNextBP', 'yes')
	end
end

function shuffleArray(array)
    local n, random, j = table.getn(array), math.random
    for i=1, n do
        j,k = random(n), random(n)
        array[j],array[k] = array[k],array[j]
    end
    return array
end

function itemSeller(...)
	local safelist = {...}
	local items = {}
	table.id(safelist)
	
	opentrade() wait(1500, 3000)
	
	foreach lootingitem m do
		if not table.find(safelist, m.id) then
			table.insert(items, m.id)
		end
	end

	for _, v in ipairs(items) do
		while tradecount("sell", v) > 0 do
			sellitems(v, tradecount("sell", v)) wait(300, 500)
		end
	end
end

function offTrainer()
	if $voc == VOC_DRUID or $voc == VOC_SORCERER then
		skillType = 4
	elseif $voc == VOC_PALADIN then
		skillType = 3
	else
		if $axe > $sword and $axe > $club then
			skillType = 1
		 elseif $sword > $axe and $sword > $club then
			skillType = 0
	     else
			skillType = 2
		end
	end

	local id = 16198 + skillType
	reachgrounditem(id)
	wait(1000, 1500)
	useitem(id, 'ground')
	wait(300, 500)
end

function depotSorter(lootbp)
	local depot = {
		normal = 9,
		stack = 4,
		potion = 3, 
		blue = 5,
		green = 6,
		rashid = 7,
		tamoril = 8,
	}

	lootingBp = lootbp

	setsetting('Looting/OpenNextBP', 'no')
	closewindows()	wait(1200, 2500)

	while windowcount(lootingBp) == 0 do
		closewindows()	wait(1000, 1900)
		openitem($back.id,'back')	wait(1000, 1900)
		openitem(lootingBp,itemname($back.id),true)	wait(1000, 1900)
		resizewindows() waitping()
	end

	while windowcount("Depot Chest") == 0 do
		opendepot(true)
		wait(1000, 1900)
		openitem(3502)
		wait(1000, 1900)
	end

	DEPOT_ID = 22796

	while (true) do
		foreach lootingitem i do
			while itemcount(i.id, lootingBp) > 0 do
				if itemproperty(i.id, 5) then
					if table.find(POTIONS_TABLE, i.id) then
						moveitemsonto(i.id, DEPOT_ID + depot.potion, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					else
						moveitemsonto(i.id, DEPOT_ID + depot.stack, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					end
				else
					if table.find(ITEMS_BLUE_DJINN, i.id) then
						moveitemsonto(i.id, DEPOT_ID + depot.blue, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					elseif table.find(ITEMS_GREEN_DJINN, i.id) then
						moveitemsonto(i.id, DEPOT_ID + depot.green, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					elseif table.find(ITEMS_RASHID, i.id) then
						moveitemsonto(i.id, DEPOT_ID + depot.rashid, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					elseif table.find(ITEMS_TAMORIL, i.id) then
						moveitemsonto(i.id, DEPOT_ID + depot.tamoril, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					else
						moveitemsonto(i.id, DEPOT_ID + depot.normal, 1, 'depot chest', lootingBp, 100) wait(30, 60)
					end
				end
			end
		end

	    if (itemcount(lootingBp, lootingBp) > 0) then
	        openitem(lootingBp, lootingBp, false) 
			waitcontainer(lootingBp, false)
	    else
	        break
	    end

		setsetting('Looting/OpenNextBP', 'yes')
	    wait(100, 200)
	end
end