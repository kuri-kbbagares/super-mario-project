-- Library Files 
push = require 'lib/push'
Class = require 'lib/class'

-- On src folder
require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/GameLevel'
require 'src/GameObject'
require 'src/LevelMaker'
require 'src/Player'
require 'src/StateMachine'
require 'src/Snail'
require 'src/Tile'
require 'src/TileMap'
require 'src/Util'

-- On src/states folder
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'

require 'src/states/entity/snail/SnailChasingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'


require 'src/states/BaseState'

require 'src/states/game/PlayState'