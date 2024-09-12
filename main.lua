local mod = RegisterMod("Curse of Champion Belt", 1)
local game = Game()
--local curse_active=false


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

local custom_curse_sprite = Sprite()
custom_curse_sprite:Load("gfx/ui/curse_champion_belt.anm2", true)



function mod:is_curse_active()
local level = game:GetLevel()
--print("dziala")
if level:GetCurses()==8192 then 
return true
else
return false

end

end





local Curses = {
	CURSE_CHAMPION = 2 << Isaac.GetCurseIdByName("Curse of the Champion Belt") - 1
}


local Challenges ={
   CHALLENGE_CHAMPION = Isaac.GetChallengeIdByName("Championssssss...")
}




function mod:map_flag_icon(curse_id)

if curse_id ~= 8192 then return end;



MinimapAPI:AddMapFlag(
curse_id,
function() return mod:is_curse_active() end,
custom_curse_sprite,
"Curse",
0

)







end

function mod:Curse(CurseFlags)


if game.Challenge == Challenges.CHALLENGE_CHAMPION then 
return 8192
end


local level = game:GetLevel()
local player = Isaac.GetPlayer(0)
local base_chance = 90;

if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAMPION_BELT) then 
base_chance = base_chance + 7
end 

if player:HasTrinket(TrinketType.TRINKET_PURPLE_HEART) then 
base_chance = base_chance + 7
end 

print(base_chance)
--print(MinimapAPI)

local rand = math.random(0,99)
--print(rand)
if rand >= 0 and rand <= base_chance and level:GetCurses() ==0 then
	print(Curses.CURSE_CHAMPION)
	print(level:GetCurseName())
	if status then
	mod:map_flag_icon(Curses.CURSE_CHAMPION)
	end
	return Curses.CURSE_CHAMPION
	--curse_active=true
end

--curse_active=false

print(level:GetCurses())

--[[
	if level:GetCurses()==0 then 
	return CURSE_CHAMPION
	end
]]--



end

function mod:Test()
	local level = game:GetLevel()
	if level:GetCurses() == Curses.CURSE_CHAMPION then 
	local room = Game():GetRoom()
    -- Iterate over all entities in the room
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local entity = entities[i]
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
	
	
	
        
        -- Check if the entity is an enemy
        if entity:IsActiveEnemy() then
            -- Make the entity a champion
            entity:ToNPC():MakeChampion(1, rand, true)
			entity:ToNPC():AddHealth(999)
        end
    end


end 


end




function mod:Gowno()

	if MinimapAPI then 
	return 
	end
	
	
	if not MinimapAPI then

	--print(Curses.CURSE_CHAMPION)

            if mod:is_curse_active() and not Input.IsActionPressed(ButtonAction.ACTION_MAP, 0) then
                local corner = Vector(Isaac.GetScreenWidth(), 0)
                local HUDOffset = Options.HUDOffset * Vector(-20, 12)
                local curOffset = 0
                -- Isaac.GetScreenHeight()
                -- Isaac.GetScreenWidth()

        
                        custom_curse_sprite:SetFrame('Curse', 0)
                        custom_curse_sprite:Render(corner + HUDOffset + Vector(-66, 10+(16*curOffset)), Vector.Zero, Vector.Zero)
                        curOffset = curOffset + 1
     
            end
        end

    
	
end


mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.Curse)
--mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Curses.OnUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.Test)
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, MinimapAPI.AddMapFlag)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.Gowno)