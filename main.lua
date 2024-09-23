local mod = RegisterMod("Curse of Champion Belt", 1)
local game = Game()
local custom_curse_sprite = Sprite()
custom_curse_sprite:Load("gfx/ui/curse_champion_belt.anm2", true)
local json = require("json")



local Curses = {
	CURSE_CHAMPION = 2 << Isaac.GetCurseIdByName("Curse of the Champion Belt") - 1
}


local Challenges ={
   CHALLENGE_CHAMPION = Isaac.GetChallengeIdByName("Championssssss...")
}



local excluded_entities={
	203,887,805,804,809,802,302,212,306,201,203,235,236,44,218,877,893,852,291,404,409,35,213
}

champion_type_chance={

	{type = "White", chance = 0, id=6},	
	{type = "Rainbow", chance = 1, id=25},
	{type = "Purple", chance = 1, id=11},
	{type = "Red", chance = 4, id=0},
	{type = "Green", chance = 4, id=2},
	{type = "Black", chance = 4, id=5},
	{type = "Grey", chance = 4, id=7},
	{type = "Transparent", chance = 4, id=8},
	{type = "Flicker", chance = 4, id=9},
	{type = "Pink", chance = 4, id=10},
	{type = "Dark_red", chance = 4, id=12},
	{type = "Light_blue", chance = 4, id=13},
	{type = "Camo", chance = 4, id=14},
	{type = "Pulse_green", chance = 4, id=15},
	{type = "Pulse_grey", chance = 4, id=16},
	{type = "Fly_protected", chance = 4, id=17},
	{type = "Tiny", chance = 4, id=18},
	{type = "Giant", chance = 4, id=19},
	{type = "Pulse_red", chance = 4, id=20},
	{type = "Size_pulse", chance = 4, id=21},
	{type = "King", chance = 4, id=22},
	{type = "Death", chance = 4, id=23},
	{type = "Brown", chance = 4,id=24},
	{type = "Orange", chance = 6, id=3},
	{type = "Blue", chance = 6, id=4},
	{type = "Yellow", chance = 6, id=1},

}



function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else 
        copy = orig
    end
    return copy
end

local champion_type_chance_default = deepcopy(champion_type_chance)


if MinimapAPI == nil then
	status = false 
	print("MinimapAPI is not installed or couldn't be loaded.")
	else
	status = true
	end
	
	
	
	if ModConfigMenu == nil then 
	status2 = false 
	else 
	status2 = true
	end
	
	
	
	if status2 then 

	local name = "Curse of the champion belt"
	
	ModConfigMenu.RemoveCategory(name)
	
	ModConfigMenu.UpdateCategory(name, {
		Info = {"Curse of the champion belt"}
	})
	

	function mod:LoadChampionSettings()
		if mod:HasData() then
			local savedData = json.decode(mod:LoadData())
			if savedData then
				for _, champion in ipairs(champion_type_chance) do
					if savedData[champion.type] ~= nil then
						champion.chance = savedData[champion.type]
					end
				end
			end
		end
	end

	function mod:SaveChampionSettings()
		local dataToSave = {}
		for _, champion in ipairs(champion_type_chance) do
			dataToSave[champion.type] = champion.chance
		end
		mod:SaveData(json.encode(dataToSave))
	end

	function mod:ResetChampionSettingsToDefault()
		for i, champion in ipairs(champion_type_chance_default) do
			
			champion_type_chance[i].chance = champion.chance
			champion_type_chance[i].id = champion.id
		end
		
		mod:SaveChampionSettings()
	end

	mod:LoadChampionSettings()



	


	ModConfigMenu.AddText(name, "Champion Settings","Champion chance")
	
	for _, champion in ipairs(champion_type_chance) do 
	
		ModConfigMenu.AddSetting(
			name,
			"Champion Settings", 
			{
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function()
					return champion.chance
				end,
				
				Minimum = 0, 
				Maximum = 100, 
				Display = function()
					return champion.type .. " chance: " .. champion.chance .. "%"
				end,
				OnChange = function(newValue)
					
					champion.chance = math.max(0, math.min(100, newValue))
					mod:SaveChampionSettings() 
				end,
				Info = {"Set the spawn chance for the " .. champion.type .. " champion."}
			}
		)
	
	end 

	--]]

	ModConfigMenu.AddSetting(
    name,  
    "Champion Settings", 
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        Display = function()
            return "Restore Default Values"
        end,
        CurrentSetting = function()
            return false 
        end,
        OnChange = function(newValue)
            if newValue then
                mod:ResetChampionSettingsToDefault() 
            end
        end,
        Info = {"Click to restore all champion chances to their default values."},
    }
)

end



function mod:is_curse_active()
	local level = game:GetLevel()
	if level:GetCurses()== Curses.CURSE_CHAMPION  then 
	return true
	else
	return false	
	end
	
end
	



function mod:map_flag_icon(curse_id)

if curse_id ~= Curses.CURSE_CHAMPION then return end;

MinimapAPI:AddMapFlag(
curse_id,
function() return mod:is_curse_active() end,
custom_curse_sprite,
"Curse",
0

)

end


function mod:Is_Entity_Excluded(Entity)

local entity_Type = Entity.Type

	for _, Excluded_type in ipairs(excluded_entities) do 
		if entity_Type == Excluded_type then 
			return true
		end

	end


	return false

end 


function mod:roll_for_champion_type()
	local totalChance = 0

   
    for _, champion in ipairs(champion_type_chance) do
        totalChance = totalChance + champion.chance
    end

   
    local rand = math.random(1, totalChance)

    
    local accumulatedChance = 0
    for _, champion in ipairs(champion_type_chance) do
        accumulatedChance = accumulatedChance + champion.chance
		print(champion.type .. " " .. champion.chance)
		--print()
        if rand <= accumulatedChance then
            --print("Selected Champion Type: " .. champion.type .. " with ID: " .. champion.id)
            return champion.id  
        end
    end

    return nil  
end	





function mod:Curse(CurseFlags)


if game.Challenge == Challenges.CHALLENGE_CHAMPION then 
return Curses.CURSE_CHAMPION 
end


local level = game:GetLevel()
local player = Isaac.GetPlayer(0)
local base_chance = 99;

if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAMPION_BELT) then 
base_chance = base_chance + 7
end 

if player:HasTrinket(TrinketType.TRINKET_PURPLE_HEART) then 
base_chance = base_chance + 7
end 

local rand = math.random(0,99)

if rand >= 0 and rand <= base_chance and level:GetCurses() ==0 then
	if status then
	mod:map_flag_icon(Curses.CURSE_CHAMPION)
	end
	return Curses.CURSE_CHAMPION

end


end

function mod:Test()
	local level = game:GetLevel()
	if level:GetCurses() == Curses.CURSE_CHAMPION then 
	local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local entity = entities[i]

		if mod:Is_Entity_Excluded(entity) then
		goto skip 
		else 	
        
        if entity:IsActiveEnemy() then
			local champion_type = mod:roll_for_champion_type()
            entity:ToNPC():MakeChampion(1, champion_type, true)
			entity:ToNPC():AddHealth(999)
        end

		
    end

	::skip:: 

end 

end

end




function mod:SpriteRender()

	if MinimapAPI then 
	return 
	end
	
	
	if not MinimapAPI then

            if mod:is_curse_active() and not Input.IsActionPressed(ButtonAction.ACTION_MAP, 0) then
            local corner = Vector(Isaac.GetScreenWidth(), 0)
            local HUDOffset = Options.HUDOffset * Vector(-50, 12)
            local curOffset = 0

            custom_curse_sprite:SetFrame('Curse', 0)
            custom_curse_sprite:Render(corner + HUDOffset + Vector(-15, 60+(16*curOffset)), Vector.Zero, Vector.Zero)
            curOffset = curOffset + 1

            end

    end

    
	
end


mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.Curse)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Test)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.SpriteRender)
