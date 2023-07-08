-- counter keeps adding to targets when mounting || Solved, was using https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEventHandler.html instead of https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEvent.html, so it would always register still. Ask pasidaips how it works with the if name == gift of tensess.
-- Make it only work when out of combat
--Use common.LogInfo("common", "-"..name.."-") --Log to mods.txt
--Use tostring() to concatenate non-string values in ChatLog()
-- Solved:
--  Error while running the chunk
--   [string "Mods/Addons/RessCounter/Script.luac"]:0: attempt to perform arithmetic on a nil value
--   func: __sub, metamethod, line: -1, defined: C, line: -1, [C]
--     func: ?, ?, line: 0, defined: Lua, line: 0, [string "Mods/Addons/RessCounter/Script.luac"]

--VARIABLES
local firstSwap = false
local defaultMaskId
local previousZone
local currentZone
local previousSubZone
local currentSubZone
local alreadyInIrene = false
local timerCount = 0

function Main()
	common.RegisterEventHandler(EVENT_AVATAR_ZONE_CHANGED,"EVENT_AVATAR_CLIENT_ZONE_CHANGED") --https://alloder.pro/md/LuaApi/EventAvatarZoneChanged.html
end

function EVENT_AVATAR_ZONE_CHANGED()
	local WanderingActorMaskId = GetWanderingActorMaskId()
	local freeBirdMaskId = GetFreebirdMaskId()
	ChatLog("FreebirdmaskId: ", freeBirdMaskId, "WanderingActorMaskId", WanderingActorMaskId)
	-- if AreWeInIrene() then
	-- 	ChatLog("Changed zone, checking if we were already in Irene: ", alreadyInIrene)
	-- 	if alreadyInIrene == false then
	-- 		ChatLog("Do you own FreebirdMaskId?: ",CostumeIsOwned(freeBirdMaskId))
	-- 		if CostumeIsOwned(freeBirdMaskId) then --Check if the player owns the Freebird mask.
	-- 			common.RegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED") --https://alloder.pro/md/LuaApi/EventCheckroomItemChanged.html
	-- 			OpenWardrobe()
	-- 			checkroomLib.EquipItem( freeBirdMaskId )
	-- 			ChatLog("equipping Freebird mask")
	-- 			common.RegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER") --Starts delay before closing the wardrobe.
	-- 			alreadyInIrene = true
	-- 		else
	-- 			ChatLog("You don't own the Freebird Mask") --Tells the player he doesn't have the Freebird mask.
	-- 		end
	-- 	end
	-- end
	if AreWeInTheatre() then
		ChatLog("Changed subZone, checking if we enter Theatre: ",currentSubZone)
		--if alreadyInIrene == false then
			ChatLog("Do you own WanderingActorMask?: ",CostumeIsOwned(WanderingActorMaskId))
			if CostumeIsOwned(WanderingActorMaskId) then --Check if the player owns the Freebird mask.
				--common.RegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED") --https://alloder.pro/md/LuaApi/EventCheckroomItemChanged.html
				OpenWardrobe()
				checkroomLib.EquipItem( WanderingActorMaskId )
				ChatLog("equipping WanderingActorMaskId")
				common.RegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER") --Starts delay before closing the wardrobe.
				--alreadyInIrene = true
			else
				ChatLog("You don't own the Wandering Actor Mask") --Tells the player he doesn't have the Freebird mask.
			end
		--end
	elseif AreWeInIrene() then
		ChatLog("Changed zone, checking if we were already in Irene: ", alreadyInIrene)
			if alreadyInIrene == false then
				ChatLog("Do you own FreebirdMaskId?: ",CostumeIsOwned(freeBirdMaskId))
				if CostumeIsOwned(freeBirdMaskId) then --Check if the player owns the Freebird mask.
					common.RegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED") --https://alloder.pro/md/LuaApi/EventCheckroomItemChanged.html
					OpenWardrobe()
					checkroomLib.EquipItem( freeBirdMaskId )
					ChatLog("equipping Freebird mask")
					common.RegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER") --Starts delay before closing the wardrobe.
					alreadyInIrene = true
				else
					ChatLog("You don't own the Freebird Mask") --Tells the player he doesn't have the Freebird mask.
				end
			end
	end
	--Requipping the previous headwear when leaving Irene.
	if previousZone == "Airin" and currentZone ~= "Airin" then --Checking if we're leaving Irene.
		ChatLog("We have left Irene. Previous zone: ",previousZone," and current zone: ", currentZone)
		OpenWardrobe()
		checkroomLib.EquipItem( defaultMaskId ) --Requipping the default headwear.
		ChatLog("equipped default mask")
		common.RegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER") --Starts delay before closing the wardrobe.
		if firstSwap == true then --resetting flag for saving the default headwear.
			firstSwap = false
		end
		ChatLog("1 defaultmaskid is", defaultMaskId)
		if defaultMaskId ~= nil then --resetting Id of the default headwear.
			defaultMaskId = nil
			ChatLog("2 defaultmaskid is", defaultMaskId)
		end
	end
	--Requipping the FreeBirdmask headwear when leaving the Theatre.
	if currentSubZone ~= "Miracle Theatre" and previousSubZone == "Miracle Theatre" then --Checking if we're leaving the Theatre.
		ChatLog("We have left Theatre. Previous subZone: ",previousSubZone," and current subZone: ", currentSubZone)
		OpenWardrobe()
		checkroomLib.EquipItem( freeBirdMaskId ) --Requipping the default headwear.
		ChatLog("equipped FreeBird mask")
		common.RegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER") --Starts delay before closing the wardrobe.
		-- if firstSwap == true then --resetting flag for saving the default headwear.
		-- 	firstSwap = false
		-- end
		-- ChatLog("1 defaultmaskid is", defaultMaskId)
		-- if defaultMaskId ~= nil then --resetting Id of the default headwear.
		-- 	defaultMaskId = nil
		-- 	ChatLog("2 defaultmaskid is", defaultMaskId)
		-- end
	end
end
function GetCategories() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibGetCategories.html
	local categories = checkroomLib.GetCategories()
	for k, v in pairs(categories) do
		ChatLog("key: ",k, "value: ",userMods.FromWString(v:GetInfo().name))
	end
	--ChatLog( categories[1]:GetInfo().name )
end
function GetCollections() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibGetCollections.html
	local categories = checkroomLib.GetCategories()
	local collections = checkroomLib.GetCollections( categories[ 3 ] ) --Gets the collections from a specified category
	--ChatLog(categories[3]:GetInfo())
	-- for k, v in pairs(collections) do
	-- 	ChatLog(k, v:GetInfo().name)
	-- end
	ChatLog( collections[ 13 ]:GetInfo().name )
end
function GetFreebirdMaskId() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibGetItems.html
	local itemId
	local categories = checkroomLib.GetCategories()
	local collections = checkroomLib.GetCollections( categories[ 3 ] ) --3 stands for Sarnaut Travels
	local items = checkroomLib.GetItems( collections[ 13 ] ) --13 stands for irene
	itemId = items[5] --Takes the itemId from item number 5 (Mask of Free Bird)
	return itemId
	-- for k, v in pairs(items) do
	-- 	local itemName = userMods.FromWString(itemLib.GetItemInfo(v).name)
	-- 	itemId = itemLib.GetItemInfo(v).id
	-- 	--ChatLog(k, itemLib.GetItemInfo(v))
	-- 	ChatLog(k, "name: ",itemName, " id: ", itemId)
	-- end
	-- ChatLog(itemInfo)
end
function GetWanderingActorMaskId() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibGetItems.html
	local itemId
	local categories = checkroomLib.GetCategories()
	local collections = checkroomLib.GetCollections( categories[ 3 ] ) --3 stands for Sarnaut Travels
	local items = checkroomLib.GetItems( collections[ 13 ] ) --13 stands for irene
	----Gets a list of all masks of Irene.
	-- for k, v in pairs(items) do
	-- 	local itemName = userMods.FromWString(itemLib.GetItemInfo(v).name)
	-- 	itemId = itemLib.GetItemInfo(v).id
	-- 	--ChatLog(k, itemLib.GetItemInfo(v))
	-- 	ChatLog(k, "name: ",itemName, " id: ", itemId)
	-- end
	-- ChatLog(itemInfo)
	itemId = items[1] --Takes the itemId from item number 1 (Mask of Wandering Actor)
	return itemId
end
function CostumeIsEquipped(itemId) --https://alloder.pro/md/LuaApi/FunctionCheckroomLibIsItemEquipped.html
	local isItemEquipped = checkroomLib.IsItemEquipped( itemId )
	return isItemEquipped
end
function CostumeIsOwned(itemId) --https://alloder.pro/md/LuaApi/FunctionCheckroomLibIsItemInCheckRoom.html
	local isItemInCheckroom = checkroomLib.IsItemInCheckroom( itemId )
	return isItemInCheckroom
end
function OpenWardrobe()
	ChatLog("Opening the wardrobe")
	if not checkroomLib.IsOpened() then
		checkroomLib.Open()
	  end
end
function CloseWardrobe()
	
	ChatLog("entering func CloseWardrobe()")	
	ChatLog("Checking if wardrobe is open",checkroomLib.IsOpened())
	if checkroomLib.IsOpened() then
		ChatLog("Closing the wardrobe")
		checkroomLib.Close()
	end
end
function AreWeInIrene()
	ChatLog("entering AreWeInIrene() func")
	previousZone = currentZone --Remembers the previous zone.
	currentZone = GetCurrentZone()
	ChatLog("We are in: ",currentZone," and came from ", previousZone)
	if currentZone == "Airin" then --Should be glocal across clients
		ChatLog("returning true")
		return true
	else
		ChatLog("returning false")
		alreadyInIrene = false
		return false
	end
end
function AreWeInTheatre()
	ChatLog("entering AreWeInTheatre() func")
	previousSubZone = currentSubZone
	currentSubZone = GetCurrentSubZone()
	ChatLog("We are in: ",currentSubZone," and came from ", previousSubZone)
	if currentSubZone == "Miracle Theatre" then --Need locales file
		ChatLog("returning true")
		return true
	else
		ChatLog("returning false")
		--alreadyInIrene = false
		return false
	end
end
function GetCurrentZone()
	local currentMapName = cartographer.GetCurrentZoneInfo().sysZoneName
	return currentMapName
end
function GetCurrentSubZone()
	local currentMapName = userMods.FromWString(cartographer.GetCurrentZoneInfo().subZoneName)
	return currentMapName
end
function EVENT_CHECKROOM_ITEM_CHANGED(params)
	ChatLog("entering func EVENT_CHECKROOM_ITEM_CHANGED")
	
		ChatLog("Already in Irene was: ", alreadyInIrene, "(false) and firstswap is: ", firstSwap,"(false)")
		if not firstSwap then
			defaultMaskId = params.itemId
			ChatLog("Remembering default mask: ",defaultMaskId)
			firstSwap = true
		end
	
	common.UnRegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED")
end
function CloseWardrobeCustom()
	ChatLog("entering event second timer func & timerCount is: ",timerCount)
	if timerCount == 1 then
		ChatLog("timerCount reached condition")
		CloseWardrobe()
		common.UnRegisterEventHandler(CloseWardrobeCustom,"EVENT_SECOND_TIMER")
		timerCount = 0
		return
	end
	timerCount = timerCount + 1
end


--closes the wardrobe: checkroomLib.Close() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibClose.html
--Equip a costume piece: checkroomLib.EquipItem( itemId ) --https://alloder.pro/md/LuaApi/FunctionCheckroomLibEquipItem.html
--equips multiple costume pieces at once: checkroomLib.EquipItems( {headItemId, shoulderItemId} ) --https://alloder.pro/md/LuaApi/FunctionCheckroomLibEquipItems.html



if (avatar.IsExist()) then
	ChatLog("Loaded.")
	Main()
else
	ChatLog("Loaded.")
	common.RegisterEventHandler(Main, "EVENT_AVATAR_CREATED")
end