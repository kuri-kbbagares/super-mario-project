require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())

    tiles = {}

    tilesheet = love.graphics.newImage('graphics/tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)


    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((11 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

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

    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('play')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
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