LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local topper = true

    lockVariant = math.random(#LOCK_VARIANTS)

    local lockBlockPosition = math.random(width)
    lockBlockPosition = 5

    local keyPosition = math.random(width)
    keyPosition = 8

    keyTaken = false

    while keyPosition == lockBlockPosition do
        keyPosition = math.random(width)
    end

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil))
        end

        if x ~=1 and x~= lockBlockPosition and x ~= keyPosition and x < width - 3 and math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil))
            end

            if x >= width - 3 then
                goto continue
            end

            if math.random(8) == 1 then
                blockHeight = 2

                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects, bushOnPillarMaker(x, y))
                end

                tiles[5][x] = Tile(x, 5, tileID, topper)
                tiles[6][x] = Tile(x, 6, tileID, nil)
                tiles[7][x].topper = nil


            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects, bushMaker(x, y))
            end

            -- chance to spawn a block
            if x == lockBlockPosition then
                table.insert(objects, lockMaker(x, y, blockHeight, objects))
            elseif x == keyPosition then
                table.insert(objects, keyMaker(x, y, blockHeight, objects))
            elseif math.random(10) == 1 then
                table.insert(objects, blockMaker(x, y, blockHeight, objects))
            end
        end

        ::continue::
    end

    local map = TileMap(width, height)
    map.tiles = tiles
  
    gameLevel = GameLevel(entities, objects, map)
    return gameLevel

end

function lockMaker(x, y, blockHeight, objects)
    return GameObject {
        texture = 'keys-and-locks',
        x = (x - 1) * TILE_SIZE,
        y = (blockHeight - 1) * TILE_SIZE,
        width = 16,
        height = 16,

        -- make it a random variant
        frame = 4 + lockVariant,
        collidable = true,
        hit = false,
        solid = true,

        -- collision function takes itself
        onCollide = function(obj)           
            gSounds['powerup-reveal']:play()
            for k, object in pairs(objects) do
                if keyTaken and object == obj then
                    table.remove(objects, k)
                    gameLevel:spawnLevelEnd()
                end
            end
        end,

        onConsume = function(obj)
        end

    }
end

function keyMaker(x, y, blockHeight, objects)
    -- key
    return GameObject {
        texture = 'keys-and-locks',
        x = (x - 1) * TILE_SIZE,
        y = (blockHeight - 1) * TILE_SIZE,
        width = 16,
        height = 16,

        -- make it a random variant
        frame = lockVariant,
        collidable = true,
        consumable = true,
        hit = false,
        solid = false,

        -- collision function takes itself
        onConsume = function(obj)

            -- TODO: remove this check
            if not obj.hit then
                -- TODO: use another sound
                gSounds['powerup-reveal']:play()

                obj.hit = true
                keyTaken = true
            end

        end
    }
end

function blockMaker(x, y, blockHeight, objects) 
    -- jump block
    return GameObject {
        texture = 'jump-blocks',
        x = (x - 1) * TILE_SIZE,
        y = (blockHeight - 1) * TILE_SIZE,
        width = 16,
        height = 16,

        -- make it a random variant
        frame = math.random(#JUMP_BLOCKS),
        collidable = true,
        hit = false,
        solid = true,

        -- collision function takes itself
        onCollide = function(obj)

            -- spawn a gem if we haven't already hit the block
            if not obj.hit then

                -- chance to spawn gem, not guaranteed
                if math.random(5) == 1 then

                    -- maintain reference so we can set it to nil
                    local gem = GameObject {
                        texture = 'gems',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE - 4,
                        width = 16,
                        height = 16,
                        frame = math.random(#GEMS),
                        collidable = true,
                        consumable = true,
                        solid = false,

                        -- gem has its own function to add to the player's score
                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.score = player.score + 100
                        end
                    }
                    
                    -- make the gem move up from the block and play a sound
                    Timer.tween(0.1, {
                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                    })
                    gSounds['powerup-reveal']:play()

                    table.insert(objects, gem)
                end

                obj.hit = true
            end

            gSounds['empty-block']:play()
        end
    }
end

function bushOnPillarMaker(x, y) 
    return GameObject {
        texture = 'bushes',
        x = (x - 1) * TILE_SIZE,
        y = (4 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        
        -- select random frame from bush_ids whitelist, then random row for variance
        frame = BUSH_IDS[math.random(#BUSH_IDS)]
    }
end

function bushMaker(x, y)
    return GameObject {
        texture = 'bushes',
        x = (x - 1) * TILE_SIZE,
        y = (6 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        frame = BUSH_IDS[math.random(#BUSH_IDS)],
        collidable = false
    }
end
