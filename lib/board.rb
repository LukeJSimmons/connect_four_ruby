class Board
  def initialize(board=[
    ['☐','☐','☐','☐','☐','☐','☐'],
    ['☐','☐','☐','☐','☐','☐','☐'],
    ['☐','☐','☐','☐','☐','☐','☐'],
    ['☐','☐','☐','☐','☐','☐','☐'],
    ['☐','☐','☐','☐','☐','☐','☐'],
    ['☐','☐','☐','☐','☐','☐','☐'],
  ])
    @board = board
    @current_symbol = '☑'
  end

  def play
    print
    take_input
    until check_for_win
      play
    end
  end
  
  def print(board=@board)
    board_str = ''
    
    board.each do |row|
      board_str << "\n"
      board_str << row.join(' ')
    end

    puts board_str
  end

  def place(col, symbol)
    col -= 1 # Adjusts to array zero floor

    deepest_empty_spot = 5
    @board.each_with_index { |row, index| deepest_empty_spot = index if row[col] == '☐' }

    @board[deepest_empty_spot][col] = symbol
  end

  def take_input
    col_input = gets.chomp

    exit if col_input == 'exit' || col_input == 'q'

    if col_input.to_i.to_s != col_input || col_input.to_i >= 7 || col_input.to_i <= 0
      puts "Invalid Input: Please input a number between 1 and 7"
      return
    end

    place(col_input.to_i, @current_symbol)
    @current_symbol = @current_symbol == '☑' ? '☒' : '☑'
  end

  def check_for_win
    # Horizontal wins
    if @board.any? { |row| row[0..3].all? { |item| item == '☑' } || row[1..4].all? { |item| item == '☑' } || row[2..5].all? { |item| item == '☑' } || row[3..6].all? { |item| item == '☑' } }
      win('☑')
    elsif @board.any? { |row| row[0..3].all? { |item| item == '☒' } || row[1..4].all? { |item| item == '☒' } || row[2..5].all? { |item| item == '☒' } || row[3..6].all? { |item| item == '☒' } }
      win('☒')
    end

    # Vertical Wins
    i = 0
    until i == 7 do
      column = []

      j = 0
      until j == 6 do
        column << @board[j][i]
        j += 1
      end

      if column[0..3].all? { |item| item == '☑' } || column[1..4].all? { |item| item == '☑' } || column[2..5].all? { |item| item == '☑' }
        win('☑')
      elsif column[0..3].all? { |item| item == '☒' } || column[1..4].all? { |item| item == '☒' } || column[2..5].all? { |item| item == '☒' }
        win('☒')
      end

      i += 1
    end

    # Diaganol Wins
    forword_diaganols = [
      [@board[2][0],@board[3][1],@board[4][2],@board[5][3],'☐','☐'],
      [@board[1][0],@board[2][1],@board[3][2],@board[4][3],@board[5][4],'☐'],
      [@board[0][0],@board[1][1],@board[2][2],@board[3][3],@board[4][4],@board[5][5]],
      [@board[0][1],@board[1][2],@board[2][3],@board[3][4],@board[4][5],@board[5][6]],
      [@board[0][2],@board[1][3],@board[2][4],@board[3][5],@board[4][6],'☐'],
      [@board[0][3],@board[1][4],@board[2][5],@board[3][6],'☐','☐'],
    ]

    backward_diaganols = [
      [@board[2][6],@board[3][5],@board[4][4],@board[5][3],'☐','☐'],
      [@board[1][6],@board[2][5],@board[3][4],@board[4][3],@board[5][2],'☐'],
      [@board[0][6],@board[1][5],@board[2][4],@board[3][3],@board[4][2],@board[5][1]],
      [@board[0][5],@board[1][4],@board[2][3],@board[3][2],@board[4][1],@board[5][0]],
      [@board[0][4],@board[1][3],@board[2][2],@board[3][1],@board[4][0],'☐'],
      [@board[0][3],@board[1][2],@board[2][1],@board[3][0],'☐','☐'],
    ]

    if forword_diaganols.any? { |row| row[0..3].all? { |item| item == '☑' } || row[1..4].all? { |item| item == '☑' } || row[2..5].all? { |item| item == '☑' } }
      win('☑')
    elsif forword_diaganols.any? { |row| row[0..3].all? { |item| item == '☒' } || row[1..4].all? { |item| item == '☒' } || row[2..5].all? { |item| item == '☒' } }
      win('☒')
    elsif backward_diaganols.any? { |row| row[0..3].all? { |item| item == '☑' } || row[1..4].all? { |item| item == '☑' } || row[2..5].all? { |item| item == '☑' } }
      p 'bd'
      win('☑')
    elsif backward_diaganols.any? { |row| row[0..3].all? { |item| item == '☒' } || row[1..4].all? { |item| item == '☒' } || row[2..5].all? { |item| item == '☒' } }
      win('☒')
    end
  end

  def win(symbol)
    print
    puts symbol == '☑' ? "\n☑ Connected Four!" : "\n☒ Connected Four!"
    exit
  end
end