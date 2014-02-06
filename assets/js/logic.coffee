@ski ||= {}

ski.currentGame = null;

class ski.Vector3D
  constructor: (@x, @y, @z) ->
  coordinates: () =>
    [@x, @y, @z]

class ski.Game
  constructor: (@me, @opponent) ->

class ski.Player
  constructor: (@id, @userName) ->
    @facing = @position = @score = null

  updateGameData: (gameData) ->
    { @facing, @position, @score } = gameData

ski.initialiseGame = (me, opponent) ->
  me.score = 0;
  opponent.score = 0;
  # set positions and facing here too!
  @currentGame = new ski.Game(me, opponent)
