PlayState = Class{__includes = BaseState}

function PlayState:init()

end

function PlayState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
    end

    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)
end

function PlayState:render()
    love.graphics.translate(-math.floor(cameraScroll), 0)
    love.graphics.clear(backgroundR/255, backgroundG/255, backgroundB/255, 255)

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = tiles[y][x]
            love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
        end
    end

    love.graphics.rectangle('fill', characterX, characterY, CHARACTER_WIDTH, CHARACTER_HEIGHT)
end