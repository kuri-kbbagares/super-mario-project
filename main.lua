require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Super Mario Project')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true
    })

    tiles = {}
  
    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

    characterDY = 0

    cameraScroll = 0

    mapWidth = 40
    mapHeight = 40

    for y = 1, mapHeight do
        table.insert(tiles, {})
        for x = 1, mapWidth do 
            table.insert(tiles[y], {id = y < 11 and TILE_ID_EMPTY or TILE_ID_GROUND})
        end
    end

    gTextures = {
        ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
        ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
        ['character'] = love.graphics.newImage('graphics/character.png'),
        ['slug'] = love.graphics.newImage('graphics/slugs.png')
    }

    gFrames = {
        ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
        ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
        ['character'] = GenerateQuads(gTextures['character'], 16, 20),
        ['slug'] = GenerateQuads(gTextures['slug'], 16, 16)
    }

    gSounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
        ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
        ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
        ['empty-block'] = love.audio.newSource('sounds/empty-block.wav', 'static'),
        ['kill'] = love.audio.newSource('sounds/kill.wav', 'static'),
        ['kill2'] = love.audio.newSource('sounds/kill2.wav', 'static')
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

    push:apply('finish')
end

