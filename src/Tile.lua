Tile = Class{}

function Tile:init(x, y, id, topper)
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
    self.topper = topper
end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][self.id],
        (self.x + 3) * TILE_SIZE, (self.y + 3) * TILE_SIZE)
    
    -- tile top layer for graphical variety
    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppers'][self.id],
            (self.x + 3) * TILE_SIZE, (self.y + 3) * TILE_SIZE)
    end
end