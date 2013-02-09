#Spencer Davis
#Tic Tac Toe in Ruby
class TicTacToe
  attr_accessor :FIELD #to manipulate during debug using pry
  
  def initialize
    @DIM = 3
    @SIZE = 10
    @GROUPSIZE = 8
    @FIELD = [' ']*10
    @space = ' '
    @Xmove = 'X'
    @Omove = 'O'
    @gameOver = false
    @win = false
    @draw = false
    @currentPlayer = 1
    
    #groups
    one = [1, 2, 3]
    two = [4, 5, 6]
    three = [7, 8, 9]
    four = [1, 4, 7]
    five = [2, 5, 8]
    six = [3, 6, 9]
    seven = [1, 5, 9]
    eight = [3, 5, 7]
    
    @hashmap = {1=>[*one],
                2=>[*two],
                3=>[*three],
                4=>[*four],
                5=>[*five],
                6=>[*six],
                7=>[*seven],
                8=>[*eight]}
    
  end
  def playGame
    while !@gameOver
      if @currentPlayer==1
        playerOne
        if @win or @draw
          @gameOver = true
        else
          @currentPlayer += 1
        end
      elsif @currentPlayer == 2
        playerTwo
        if @win or @draw
          @gameOver = true
        else
          @currentPlayer -= 1
        end
        #if you want your board to print after BOTH moves put it here
        print
      end
    #if you want your board to print after each player, put it here
    #print
    end
    puts "Game Over:-)"
  end
  def playerOne
    madeMove = false
    while !madeMove
      begin
        puts "Player One:  Please enter (1-9)"
        move = Integer(gets.chomp)
        if move > 0 && move <=9
          if @FIELD[move]==@space
            @FIELD[move] = @Omove
            madeMove = true
          else
            puts "Field already filled.  Enter another field."
          end
        else
          puts "Range is an integer from 1-9"
        end
      rescue
        puts "Invalid entry.  Integers from only please."
      ensure
      end
    end
  end
  def playerTwo
    analyzeP2MakeMove
    checkForWin
    checkForDraw
  end
  def checkForDraw
    counter = 0
    for i in 1..@GROUPSIZE
      if getGroup(i)==4 or getGroup(i)==5 or getGroup(i)==8
        counter += 1
      end
    end
      if counter==8
        @draw = true
        puts "Tied, no winner!"
      end
  end
  def checkForWin
    for i in 1..@GROUPSIZE
      if getGroup(i)==3
        @win = true
        puts "Player 1 wins!"
      elsif getGroup(i)==6
        @win = true
        puts "Player 2 wins!"
      end
    end
  end
  #This is the logic section where the computer (player 2) figures its next move
  def analyzeP2MakeMove
    random = Random.new
    
    #1.  first check if middle is available
    if @FIELD[5]==@space
      @FIELD[5]=@Xmove
      
    #2.  Then if O is in middle, only enter on edges
    elsif @FIELD[5]==@Omove && @FIELD[1]==@space && @FIELD[3]==@space && @FIELD[7]==@space && @FIELD[9]==@space
      value = []
      value << 1
      value << 3
      value << 7
      value << 9
      element = random.rand(value.length) #gives the element place
      number = value[element] #gives the number value at that place
      @FIELD[number]=@Xmove #mark a X at that place
      value.clear
      
=begin
      #3.  Next situation explanation:
      If an 'O' is in middle like this
      X|_|_  or  _|_|X
      _|O|_      _|O|_
      _|_|O      O|_|_
      always mark an X in the corner. 
      both situations above have something in common:
        board total == 35
        O is in middle
        group 7 or 8 total == 5
=end      
      elsif boardTotal==35 && @FIELD[5]==@Omove && (getGroup(7)==5 || getGroup(8)==5)
        value = []
        #check for empty corner spaces
        #randomly pick one and mark an X
        if @FIELD[1]==@space
          value << 1
        end
        if @FIELD[3]==@space
          value << 3
        end
        if @FIELD[7]==@space
          value << 7
        end
        if @FIELD[9]==@space
          value << 9
        end
        element = random.rand(value.length)
        number = value[element]
        @FIELD[number]=@Xmove #mark an X
      
      #4.  Next situation explantion:
=begin
      If an X is in the middle like the below situation, you want to 
      carefully control the next move so you take advantage (the computer)
      One situation that can make it beatable is if the human picks 2
  		the machine picks 5, the human picks 9 and the machine picks 6 instead of 4.
  		This is true starting at 2, and also 4, 6, and 8
  		Basically, you don't want this:
  		_|O|_
  		_|X|X
  		_|_|O
  		You want the sequence of moves to be:
  		if it starts at 2:  
  		_|O|_
  		X|X|_
  		_|_|O
=end
    elsif @FIELD[5]==@Xmove && getGroup(4)==15 && getGroup(5)==8 && getGroup(6)==12
      @FIELD[4]=@Xmove  
    elsif @FIELD[5]==@Xmove && getGroup(4)==12 && getGroup(5)==8 && getGroup(6)==15
      @FIELD[6]=@Xmove
    elsif @FIELD[5]==@Xmove && getGroup(1)==15 && getGroup(2)==8 && getGroup(3)==12
      @FIELD[2]=@Xmove
    elsif @FIELD[5]==@Xmove && getGroup(1)==12 && getGroup(2)==8 && getGroup(3)==15
      @FIELD[8]=@Xmove
                      
    #5.  entry point if at least one group = 7
    elsif getGroup(1)==7 or getGroup(2)==7 or getGroup(3)==7 or
          getGroup(4)==7 or getGroup(5)==7 or getGroup(6)==7 or
          getGroup(7)==7 or getGroup(8)==7
          seven = []
          for i in 1..@GROUPSIZE
            if ifEqualsToSeven(i)
              seven << i #add it to the list
            end
          end
          makeMoveSeven(seven[0]) #mark an X
          seven.clear #clear the list
          
    #6.  entry point to if at least on group == 9
    elsif getGroup(1)==9 or getGroup(2)==9 or getGroup(3)==9 or
          getGroup(4)==9 or getGroup(5)==9 or getGroup(6)==9 or
          getGroup(7)==9 or getGroup(8)==9
          nine = []
          for i in 1..@GROUPSIZE
            if ifEqualsToNine(i)
              nine << i #add it to the list
            end
          end
          makeMoveNine(nine[0])
          nine.clear
    
    #7.  entry point to if at least one group == 11   
    elsif getGroup(1)==11 or getGroup(2)==11 or getGroup(3)==11 or
          getGroup(4)==11 or getGroup(5)==11 or getGroup(6)==11 or
          getGroup(7)==11 or getGroup(8)==11
          eleven = []
          for i in 1..@GROUPSIZE
            if ifEqualsToEleven(i)
              eleven << i  #add it to the list
            end
          end
          makeMoveEleven(eleven[0])
          eleven.clear
          
    #8.  by this time, if any empty spaces are there and nothing above fits
    #just randomly pick the next move from the empty spaces   
    elsif @FIELD[1]==@space or @FIELD[2]==@space or @FIELD[3]==@space or
          @FIELD[4]==@space or @FIELD[5]==@space or @FIELD[6]==@space or
          @FIELD[7]==@space or @FIELD[8]==@space or @FIELD[9]==@space
          anythingElse = []
          for i in 1..@SIZE
            if @FIELD[i]==@space
              anythingElse << i #add to the list
            end
          end
          element = random.rand(anythingElse.length) #this finds the element
          number = anythingElse[element] #this gives the number in the array
          @FIELD[number] = @Xmove #mark an X
    end
  end
  def makeMoveEleven(groupNumber)
    number = pickValue(groupNumber, 11)
    @FIELD[number] = @Xmove
  end
  def makeMoveSeven(groupNumber)
    number = pickValue(groupNumber, 7)
    @FIELD[number] = @Xmove
  end
  def makeMoveNine(groupNumber)
    number = pickValue(groupNumber, 9)
    @FIELD[number] = @Xmove
  end
  def pickValue(groupNumber, groupTotal)
    value = []
    number = 0
    random = Random.new
    n1 = @hashmap[groupNumber][0]
    n2 = @hashmap[groupNumber][1]
    n3 = @hashmap[groupNumber][2]
    if @FIELD[n1]==@space
      value << n1
    end
    if @FIELD[n2]==@space
      value << n2
    end
    if @FIELD[n3]==@space
      value << n3
    end
    if groupTotal == 7 || groupTotal == 9
      number = value[0] 
    elsif groupTotal == 11 && @FIELD[5]==@Xmove
      elementOfArray = random.rand(value.length)
      number = value[elementOfArray]
    elsif groupTotal == 11 && @FIELD[5]==@Omove
      #nested if/elsif statements
      if value.include?(1)
        number = value[0]
      elsif value.include?(3)
        number = value[0]
      elsif value.include?(7)
        number = value[0]
      elsif value.include?(9)
        number = value[0]
      end
    end
    value.clear
    return number
  end
  #this section below checks if most important group totals are there: 7, 9, 11
  def ifEqualsToSeven(groupNumber)
    if getGroup(groupNumber)==7
      return true
    else
      return false
    end
  end
  def ifEqualsToNine(groupNumber)
    if getGroup(groupNumber)==9
      return true
    else
      return false
    end
  end
  def ifEqualsToEleven(groupNumber)
    if getGroup(groupNumber)==11
      return true
    else
      return false
    end
  end
  #print out the visible game field
  def print
    puts @FIELD[1].to_s + "|" +@FIELD[2].to_s + "|"+@FIELD[3].to_s+"\n"+
          @FIELD[4].to_s+ "|" +@FIELD[5].to_s + "|" +@FIELD[6].to_s+"\n"+
          @FIELD[7].to_s+ "|" +@FIELD[8].to_s + "|" +@FIELD[9].to_s
  end
  #return group count
  def getGroup(groupNumber)
    return count(@hashmap[groupNumber][0], @hashmap[groupNumber][1], @hashmap[groupNumber][2])
  end
  #returns the sum of all the fields
  def boardTotal
    total = 0
    for i in 1..@SIZE
      if @FIELD[i]==@space
        total += 5
      elsif @FIELD[i]==@Xmove
        total += 1
      elsif @FIELD[i]==@Omove
        total += 2
      end
    end
    return total
  end
  #this does the group counting and gives a total for each group
  def count(n1, n2, n3)
    c = Array.new(@DIM)
    c[0] = @FIELD[n1]
    c[1] = @FIELD[n2]
    c[2] = @FIELD[n3]
    total = 0
    for i in 0...@DIM
      if c[i] == @space
        total += 5
      elsif c[i]== @Omove
        total += 2
      elsif c[i] == @Xmove
        total += 1
      end
    end
    return total
  end
end

foo = TicTacToe.new
foo.playGame