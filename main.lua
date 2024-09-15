local mod = RegisterMod("Curse of Champion Belt", 1)
local game = Game()
local custom_curse_sprite = Sprite()
custom_curse_sprite:Load("gfx/ui/curse_champion_belt.anm2", true)



local MinimapAPI
local status, err = pcall(function()
    MinimapAPI = require("scripts.minimapapi.init")
end)

if not status then
    -- If MinimapAPI is not found, print a message or handle it
    print("MinimapAPI is not installed or couldn't be loaded.")
    -- You can set a flag here to disable features related to MinimapAPI
    MinimapAPI = nil
end




local Curses = {
	CURSE_CHAMPION = 2 << Isaac.GetCurseIdByName("Curse of the Champion Belt") - 1
}


local Challenges ={
   CHALLENGE_CHAMPION = Isaac.GetChallengeIdByName("Championssssss...")
}



local excluded_entities={
	203,887,805,804,809,802,302,212,306,201,203,235,236,44,218,877,893,852,291,404,409,35,213
}

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
	print(Curses.CURSE_CHAMPION)
	print(level:GetCurseName())
	if status then
	mod:map_flag_icon(Curses.CURSE_CHAMPION)
	
	end
	return Curses.CURSE_CHAMPION

end
--print(rand)
--print(level:GetCurses())


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


	local rand = math.random(0,25);
		
	
	local rand2 = math.random(0,99)
	
	while rand == 6 do 
		rand = math.random(0,25);
		
	end 
	
	while rand2>25 and( rand==25 or rand==11) do 
	rand = math.random(0,25)
	rand2 = 2
	end 
	
	
	while rand == 6 do 
		rand = math.random(0,25);
		
	end 
	
	
	
        
        if entity:IsActiveEnemy() then
     
            entity:ToNPC():MakeChampion(1, rand, true)
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
                -- Isaac.GetScreenHeight()
                -- Isaac.GetScreenWidth()

        
                        custom_curse_sprite:SetFrame('Curse', 0)
                        custom_curse_sprite:Render(corner + HUDOffset + Vector(-15, 60+(16*curOffset)), Vector.Zero, Vector.Zero)
                        curOffset = curOffset + 1
     
            end
        end

    
	
end


mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.Curse)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Test)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.SpriteRender)
