--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerHoldPotWalkState = Class{__includes = EntityWalkState}

function PlayerHoldPotWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0


end

function PlayerHoldPotWalkState:update(dt)

    --create projectile that looks like pot 
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local potproj = Projectile(
           self.entity, self.dungeon
        )

        table.insert(self.dungeon.currentRoom.projectiles, potproj)


        --delete original pot obect

        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if self.dungeon.currentRoom.objects[k].type == 'pot' then
                table.remove(self.dungeon.currentRoom.objects, k)
            end
        end
        -- set player to idle
        self.entity.holding = false
        self.entity:changeState('idle')
          
    end




    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.dungeon.currentRoom.objects[k].type == 'pot' then
            
            object.x = self.entity.x
            object.y = self.entity.y-8
        end
    end


    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('potwalk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('potwalk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('potwalk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('potwalk-down')
    else
        self.entity:changeState('potidle')
    end

    if love.keyboard.wasPressed('space') and (self.entity.holding == false) then
        self.entity:changeState('swing-sword')
    end

    --if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
    --    self.entity:changeState('swing-sword')
    --end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
--[[             for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end ]]

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
--[[             -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end ]]

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
--[[             for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end ]]

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
--[[             for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end ]]

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end