PlayState = Class{__includes = BaseState}

function PlayState:init()
    print("PLAYSTATE init")
    self.camX = 0
    self.camY = 0
end

function PlayState:update(dt)
    Timer.update(dt)

    self.level:clear()

    self.player:update(dt)
    self.level:update(dt)

    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    self:updateCamera()
end

function PlayState:enter(params)
    if params then
        levelWidth = LEVEL_WIDTH*params.currentLevel
    else
        levelWidth = LEVEL_WIDTH
    end


    self.level = LevelMaker.generate(levelWidth, 10)
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

    if params then
        self.player.score = params.score
        self.player.currentLevel = params.currentLevel + 1
    end

    print(self.player.score)
    print(self.player.currentLevel)

    self:spawnEnemies()

    self.player:changeState('falling')
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.draw(self.background, 0, (VIRTUAL_HEIGHT * 2) - 34, 0, 1, -1)

    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()

    self.player:render()
    love.graphics.pop()

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(tostring(self.player.score), 4, 4)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("Level - " .. tostring(self.player.currentLevel), 5, VIRTUAL_HEIGHT - 15)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Level - " .. tostring(self.player.currentLevel), 4, VIRTUAL_HEIGHT - 16)

end

function PlayState:updateCamera()
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    self.backgroundX = (self.camX / 3) % 256

    self.backgroundX = (self.camX / 3) % 256
end

function PlayState:spawnEnemies()
    for x = 1, self.tileMap.width do

        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    if math.random(20) == 1 then
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