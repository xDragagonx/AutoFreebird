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
function Main()
	common.RegisterEventHandler(EVENT_AVATAR_ZONE_CHANGED,"EVENT_AVATAR_CLIENT_ZONE_CHANGED") --https://alloder.pro/md/LuaApi/EventAvatarZoneChanged.html
end
function EVENT_AVATAR_ZONE_CHANGED()
	ChatLog("Changed zone")
	ChatLog("Checking if we're in Irene")
	if AreWeInIrene() then
		--ChatLog(CostumeIsOwned(GetFreebirdId())) --Check if the player owns the Freebird mask.
		if CostumeIsOwned(GetFreebirdId())then
			common.RegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED") --https://alloder.pro/md/LuaApi/EventCheckroomItemChanged.html
			OpenWardrobe()
			checkroomLib.EquipItem( GetFreebirdId() )
			ChatLog("equipped Freebird mask")
			CloseWardrobe()
		end
	end
	if previousZone == "Airin" and currentZone ~= "Airin" then
		ChatLog("We're not in Irene. Previous zone: ",previousZone)
		OpenWardrobe()
		checkroomLib.EquipItem( defaultMaskId )
		ChatLog("equipped default mask")
		CloseWardrobe()
		previousZone = nil
		firstSwap = false
		defaultMaskId = nil
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
function GetFreebirdId() --https://alloder.pro/md/LuaApi/FunctionCheckroomLibGetItems.html
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
	ChatLog("Closing the wardrobe")
	while checkroomLib.IsOpened() do
		ChatLog("1",checkroomLib.IsOpened())
		checkroomLib.Close()
		ChatLog("2",checkroomLib.IsOpened())
	  end
end
function AreWeInIrene()
	ChatLog("entering AreWeInIrene() func")
	local mapName = cartographer.GetCurrentZoneInfo().sysZoneName
	ChatLog("We are in: ",mapName)
	if mapName == "Airin" then
		previousZone = mapName
		currentZone = mapName
		ChatLog("It's true, previousZone: ",previousZone,"currentZone: ",currentZone)
		return true
	else
		currentZone = mapName
		ChatLog("It's false, previousZone: ",previousZone,"currentZone: ",currentZone)
		return false
	end
end
function EVENT_CHECKROOM_ITEM_CHANGED(params)
	if not firstSwap then
		defaultMaskId = params.itemId
		ChatLog("Remembering default mask: ",defaultMaskId)
		firstSwap = true
	end
	common.UnRegisterEventHandler(EVENT_CHECKROOM_ITEM_CHANGED,"EVENT_CHECKROOM_ITEM_CHANGED")
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