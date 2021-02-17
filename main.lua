require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())

    tiles = {}
  
    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((11 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

    characterDY = 0

    cameraScroll = 0

    backgroundR = math.random(255)
    backgroundG = math.random(255)
    backgroundB = math.random(255)

    mapWidth = 40
    mapHeight = 40

    for y = 1, mapHeight do
        table.insert(tiles, {})
        for x = 1, mapWidth do
            table.insert(tiles[y], {id = y < 11 and SKY or GROUND})
        end
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Super Mario Project')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true
    })

    gTextures = {
        ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
        ['toppers'] = love.graphics.newImage('graphics/tile_tops.png')
    }

    gFrames = {
        ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
        ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE)
    }

    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('play')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' and characterDY == 0 then
        characterDY = JUMP_VELOCITY
    end
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keypressed = {}
end

function love.draw()
    push:apply('start')

    gStateMachine:render()

    push:apply('end')
end

