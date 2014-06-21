require 'rspec'
require_relative "new"

describe Game do
  before(:each) do
    @testGame = Game.new
  end
  context "When created" do
    it "should initialize a new GameState" do
      expect(@testGame.ai.class).to eq(AI)
    end

    it "should initialize a new AI" do
      expect(@testGame.gameState.class).to eq(GameState)
    end
  end

  context ".playGame" do
    xit "should return the winner" do
      expect(@testGame.playGame).to eq("X Wins!")
    end
  end 

end

describe GameState do
  before(:each) do
    @testState = GameState.new("X", "O")
  end

  context "When created" do
    it "should take a player argument and an opponent argument" do
      expect{GameState.new}.to raise_error(ArgumentError) 
    end
    it "should have a board variable of length 9, all values should be set to '_'" do
      expect(@testState.board).to eq(["_","_","_","_","_","_","_","_","_"])
    end
    it "should have a player variable set to the initial given argument" do 
      expect(@testState.player).to eq("X")
    end
    it "should have an opponent variable set to the initial given argument" do 
      expect(@testState.opponent).to eq("O")
    end
    it "should have a turn variable set to 0" do 
      expect(@testState.turn).to eq(0)
    end
  end

  context ".move" do
    it "should swap the player variable for the opponent variable" do
      @testState.move(4)
      expect(@testState.player).to eq("O")
    end
    it "should swap the opponent for the player variable" do
      @testState.move(4)
      expect(@testState.opponent).to eq("X")
    end
    it "should place a players token at the given position" do
      @testState.move(4)
      expect(@testState.board[4]).to eq("X")
    end
  end

  context ".gameOver?" do
    it "should return false if the game is not over" do
      expect(@testState.gameOver?).to eq(false)
    end
    it "should return a winner if one exists" do
      @testState.board = ["X", "X", "X", "_", "_","_","_","_","_"]
      expect(@testState.gameOver?).to eq("X")
    end
  end

  context ".possibleMoves" do
    it "should return a list of all possible moves" do
      expect(@testState.possibleMoves).to eq([0,1,2,3,4,5,6,7,8])
    end
    it "should remove the appropriate space when filled" do
      @testState.move(4)
      expect(@testState.possibleMoves).to eq([0,1,2,3,5,6,7,8])
    end
  end

  context ".draw?" do
    it "should report a draw if the game is over and there is no winner " do
      @testState.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(@testState.draw?).to eq(true)
    end
  end

  context ".winner?" do
    it "should return false if the game is not over" do
      expect(@testState.gameOver?).to eq(false)
    end
    it "should return a winner if one exists" do
      @testState.board = ["X", "X", "X", "_", "_","_","_","_","_"]
      expect(@testState.gameOver?).to eq("X")
    end
  end

  context ".checkRows" do
    it "should return false for an empty row" do
      expect(@testState.checkRows).to eq(false)
    end 
    it "should return false for a row with one piece" do
      @testState.board.each_with_index do |space, index|
        @testState.board[index - 1] = "_"
        @testState.board[index] = "X"
        expect(@testState.checkRows).to eq(false)
      end
    end
    it "should return false for a row with two pieces" do
      @testState.board.each_with_index do |space, index|
        @testState.board[index - 2] = "_"
        @testState.board[index - 1] = "X"
        @testState.board[index] = "X"
        expect(@testState.checkRows).to eq(false)
      end
    end
    it "should return true for a row with three of a players piece" do
      @testState.board = ["X", "X", "X", "_", "_","_","_","_","_"]
      expect(@testState.checkRows).to eq("X")
    end
  end

  context ".checkColumns" do
    it "should return false for an empty column" do
      expect(@testState.checkColumns).to eq(false)
    end 
    it "should return false for a column with one piece" do
      @testState.board = ["X", "_", "_", "_", "_","_","_","_","_"]
      expect(@testState.checkColumns).to eq(false)
    end
    it "should return false for a column with two pieces" do
      @testState.board = ["X", "_", "_", "X", "_","_","_","_","_"]
      expect(@testState.checkColumns).to eq(false)
    end
    it "should return false for a column with two player pieces and one opponent piece" do
      @testState.board = ["X", "_", "_", "X", "_","_","O","_","_"]
      expect(@testState.checkColumns).to eq(false)
    end
    it "should return true for a column with three of a players piece" do
      @testState.board = ["X", "_", "_", "X", "_","_","X","_","_"]
      expect(@testState.checkColumns).to eq("X")
    end
  end

  context ".checkDiagonals" do
    it "should return nil for an empty diagonal" do
      expect(@testState.checkDiagonals).to eq(nil)
    end 
    it "should return nil for a diagonal with one piece" do
      @testState.board = ["X", "_", "_", "_", "_","_","_","_","_"]
      expect(@testState.checkDiagonals).to eq(nil)
    end
    it "should return nil for a diagonal with two pieces" do
      @testState.board = ["X", "_", "_", "_", "X","_","_","_","_"]
      expect(@testState.checkDiagonals).to eq(nil)
    end
    it "should return nil for a diagonal with two player pieces and one opponent piece" do
      @testState.board = ["X", "_", "_", "_", "X","_","_","_","O"]
      expect(@testState.checkDiagonals).to eq(nil)
    end
    it "should return true for a diagonal with three of a players piece" do
      @testState.board = ["X", "_", "_", "_", "X","_","_","_","X"]
      expect(@testState.checkDiagonals).to eq("X")
    end
  end

end

describe AI do
  before(:each) do
    @testAI = AI.new
  end
  context "When created" do
    it "should have a choice variable set to nil" do 
      expect(@testAI.choice).to eq(nil)
    end
  end

  context ".score" do
    it "should raise an error if not given an argument, gameState" do
      expect{@testAI.score()}.to raise_error(ArgumentError)
    end
    it "should take an argument, gameState" do
      expect{@testAI.score(GameState.new("X", "O"))}.to_not raise_error()
    end
    it "should return 10 if the computer won" do
      testState = GameState.new("X", "O")
      testState.board = ["X", "X", "X", "_", "_", "_", "_", "_", "_"]
      expect(@testAI.score(testState)).to eq(10)
    end
    it "should return -10 if the player won" do
      testState = GameState.new("X", "O")
      testState.board = ["O", "O", "O", "_", "_", "_", "_", "_", "_"]
      expect(@testAI.score(testState)).to eq(-10)
    end
    it "should return 0 if the game is undecided" do
      testState = GameState.new("X", "O")
      testState.board = ["X", "_", "X", "_", "_", "_", "_", "_", "_"]
      expect(@testAI.score(testState)).to eq(0)
    end
    it "should return 0 if the game is a draw" do
      testState = GameState.new("X", "O")
      testState.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
      expect(@testAI.score(testState)).to eq(0)
    end
  end

  context ".minimax" do
    it "should raise an error if not given an argument, gameState" do
      expect{@testAI.minimax()}.to raise_error(ArgumentError)
    end
    it "should take an argument, gameState" do
      #given almost completed board to save time on recursion
      testState = GameState.new("X", "O")
      testState.board = ["X", "O", "_", "O", "X", "_", "O", "X", "O"]
      expect{@testAI.minimax(testState)}.to_not raise_error()
    end
  end
end