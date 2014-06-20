class Game
#handles game play and function
  attr_accessor :gameState, :ai
  def initialize
    @gameState = GameState.new("X", "O")
    @ai = AI.new
  end

  def playGame
    while(!self.gameState.gameOver?)
      self.turn
    end
    self.displayBoard
    puts "#{self.gameState.winner?} Wins!"
  end

  def turn
    self.displayBoard
    if(self.gameState.player == "O")
      puts "Enter a value #{self.gameState.possibleMoves} to place a piece"
      playerMove = gets.chomp.to_i
      if(playerMove >= 0 && playerMove <= 8 && self.gameState.possibleMoves.include?(playerMove))
        self.gameState.move(playerMove)
        self.displayBoard
      else
        self.turn
      end
    else
      p self.gameState.turn
      if(self.gameState.turn == 0)
        self.gameState.move([0,2,6,8].sample)
      else
        self.ai.minimax(self.gameState)
        self.gameState.move(self.ai.choice)
      end
    end
  end

  def displayBoard
    self.gameState.board.each_slice(3) do |row|
      row.each do |position|
        print "|#{position}"
      end
      print "|\n"
    end
    p "---------"
  end
end

class GameState
  #handles game data and state
  attr_accessor :board, :player, :opponent, :turn

  def initialize(player, opponent)
    @board = Array.new(9, "_")
    @player = player
    @opponent = opponent
    @turn = 0
  end

  def move(position)
    newBoard = self.board.dup
    newBoard[position] = self.player
    if(self.player == "X")
      self.player = "O"
      self.opponent = "X"
    elsif(self.player == "O")
      self.player = "X"
      self.opponent = "O"
    end
    self.turn += 1
    self.board = newBoard
  end

  def gameOver?
    self.draw? || self.winner?
  end

  def possibleMoves
    possible = []
    self.board.each_with_index do |position, index|
      possible << index if position == "_"
    end
    possible
  end

  def draw?
    if(!self.board.include?("_") && !winner?)
      return true
    end
    return false
  end

  def winner?
    if(self.checkRows == "X" || self.checkColumns == "X" || self.checkDiagonals == "X")
      return "X"
    elsif(self.checkRows == "O" || self.checkColumns == "O" || self.checkDiagonals == "O")
      return "O"
    end
    return false
  end

    def checkRows
    self.board.each_slice(3) do |row|
      if(row.all? { |e| e == "X"  })
        return "X"
      elsif(row.all? { |e| e == "O"  })
          return "O"
      end
    end
    return false
  end

  def checkColumns
    i = 0
    j = 0
    columns = []
    while i < 3
      hold = []
      while j < 7
        hold << self.board[(j + i)]
        j += 3
      end
      columns << hold
      j = 0
      i += 1
    end

    columns.flatten.each_slice(3) do |col|
      if(col.all? { |e| e == "X" })
        return "X"
      elsif(col.all? { |e| e == "O" })
        return "O"
      end
    end
    return false
  end

  def checkDiagonals
    if(self.board[0] == "X" && self.board[4] == "X" && self.board[8] == "X")
      return "X"
    elsif(self.board[6] == "X" && self.board[4] == "X" && self.board[2] == "X")
      return "X"
    end
    if(self.board[0] == "O" && self.board[4] == "O" && self.board[8] == "O")
      return "O"
    elsif(self.board[6] == "O" && self.board[4] == "O" && self.board[2] == "O")
      return "O"
    end
  end
end

class AI

  attr_accessor :choice
  def initialize
    @choice = nil
  end

  def score(gameState)
      if(gameState.winner? == "X")
        return 10
      elsif(gameState.winner? == "O")
        return -10
      else
        return 0
      end
  end

  def minimax(gameState)
    if(gameState.gameOver?)
      return score(gameState)
    end
    scores = []
    moves = []

    gameState.possibleMoves.each do |move|
      nextState = gameState.dup
      nextState.board = gameState.board.dup
      nextState.move(move)
      scores << minimax(nextState)
      moves << move
    end
    if(gameState.player == "X")
      maxIndex = scores.each_with_index.max[1]
      self.choice = moves[maxIndex]
      return scores[maxIndex]
    else
      minIndex = scores.each_with_index.min[1]
      self.choice = moves[minIndex]
      return scores[minIndex]
    end
  end
end

myGame = Game.new
myGame.playGame