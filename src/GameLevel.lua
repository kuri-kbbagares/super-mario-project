GameLevel = Class{}

function GameLevel:init(tilemap)
    self.tileMap = tilemap
end

function GameLevel:clear()

end

function GameLevel:update(dt)
    self.tileMap:update(dt)
end

function GameLevel:render()
    self.tileMap:render()
end