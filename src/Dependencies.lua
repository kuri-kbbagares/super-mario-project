

-- on lib folder
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- on src folder
require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/GameObject'
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/Snail'
require 'src/StateMachine'
require 'src/Tile'
require 'src/TileMap'
require 'src/Util'

-- on src/states folder
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'

require 'src/states/entity/snail/SnailChasingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'



gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['character'] = love.graphics.newImage('graphics/character.png'),
    ['slug'] = love.graphics.newImage('graphics/slugs.png'),
    ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    ['character'] = GenerateQuads(gTextures['character'], 16, 20),
    ['slug'] = GenerateQuads(gTextures['slug'], 16, 16),
    ['jump-blocks'] = GenerateQuads(gTextures['jump-blocks'], 17, 12)
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