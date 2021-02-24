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
    ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
    ['keys-and-locks'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['flag-rod'] = love.graphics.newImage('graphics/flags.png'),
    ['flags'] = love.graphics.newImage('graphics/flags.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    ['character'] = GenerateQuads(gTextures['character'], 16, 20),
    ['slug'] = GenerateQuads(gTextures['slug'], 16, 16),
    ['jump-blocks'] = GenerateQuads(gTextures['jump-blocks'], 16, 16),
    ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
    ['keys-and-locks'] = GenerateQuads(gTextures['keys-and-locks'], 16, 16),
    ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
    ['flag-rod'] = GenerateQuads(gTextures['flag-rod'], 16, 16*4),
    ['flags'] = GenerateQuads(gTextures['flags'], 16, 16)
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

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 25)
}