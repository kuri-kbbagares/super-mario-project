PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 10)
    self.tileMap = self.level.tileMap
    self.background = love.graphics.newImage('graphics/backgrounds.png')
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 20,
        texture = 'character',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })
    
    self:spawnEnemies()
    self.player:changeState('falling')
end

function PlayState:update(dt)
    characterDY = characterDY + GRAVITY
    characterY = characterY + characterDY * dt
    
    if characterY > ((8 - 1) * TILE_SIZE) - CHARACTER_HEIGHT then
        characterY = ((8 - 1) * TILE_SIZE) - CHARACTER_HEIGHT
        characterDY = 0
    end

    self.player:update(dt)
    self.level.update(dt)

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)

    self:updateCamera()
end

function PlayState:render()
    love.graphics.draw(self.background, 0, 0)

    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()

    self.player:render()
end

function PlayState:updateCamera()
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        characterX - (VIRTUAL_WIDTH / 2 - 8)))

    self.backgroundX = (self.camX / 3) % 256

    self.backgroundX = (self.camX / 3) % 256
end

function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'slug',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end