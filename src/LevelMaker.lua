LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}

    local topper = true

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = SKY

        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID))
        end

        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID))
            end
        else
            tileID = GROUND

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil))
            end

            if math.random(8) == 1 then              
                tiles[5][x] = Tile(x, 5, tileID, topper)
                tiles[6][x] = Tile(x, 6, tileID, nil)
                tiles[7][x].topper = nil
                
                -- Add the entities here and made an another lua file for GameObjects
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(map)
end