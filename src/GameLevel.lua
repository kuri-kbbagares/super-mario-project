GameLevel = Class{}

function GameLevel:init(entities, tilemap)
    self.tileMap = tilemap
    self.entities = entities
end

function GameLevel:clear()
    for i = #self.entities, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end
end

function GameLevel:update(dt)
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function GameLevel:render()
    self.tileMap:render()
    
    for k, entity in pairs(self.entities) do
        entity:render()
    end
end