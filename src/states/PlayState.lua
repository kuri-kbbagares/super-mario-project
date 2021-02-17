PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 12)
    self.tileMap = self.level.tileMap
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6
end

function PlayState:update(dt)
    characterDY = characterDY + GRAVITY
    characterY = characterY + characterDY * dt
    
    if characterY > ((11 - 1) * TILE_SIZE) - CHARACTER_HEIGHT then
        characterY = ((11 - 1) * TILE_SIZE) - CHARACTER_HEIGHT
        characterDY = 0
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
    end

    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)

    self:updateCamera()
end

function PlayState:render()
    love.graphics.clear(backgroundR/255, backgroundG/255, backgroundB/255, 255)

    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()

    love.graphics.rectangle('fill', characterX, characterY, CHARACTER_WIDTH, CHARACTER_HEIGHT)
end

function PlayState:updateCamera()
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        characterX - (VIRTUAL_WIDTH / 2 - 8)))

    self.backgroundX = (self.camX / 3) % 256

    self.backgroundX = (self.camX / 3) % 256
end