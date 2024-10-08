require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  before do
    allow(board).to receive(:exit)
  end

  describe '#print' do
    context 'when board is empty' do
      it 'displays empty board' do
        expect(board).to receive(:puts).with("\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐")
        board.print
      end
    end

    context 'when board is not empty' do
      subject(:board) { described_class.new([
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☑','☐','☐','☒','☐','☐'],
      ]) }

      it 'displays board correctly' do
        expect(board).to receive(:puts).with("\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☐ ☐ ☐ ☐ ☐ ☐\n☐ ☑ ☐ ☐ ☒ ☐ ☐")
        board.print
      end
    end
  end

  describe '#place' do
    context 'when column is empty' do
      it 'drops circle to bottom' do
        expect { board.place(1, '☑') }.to change { board.instance_variable_get(:@board)[5][0] }.to('☑')
      end
    end

    context 'when column is not empty' do
      subject(:board) { described_class.new([
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☐','☐','☐','☐','☐','☐'],
        ['☐','☑','☐','☐','☒','☐','☐'],
      ]) }

      it 'drops circle to deepest empty spot' do
        expect { board.place(2, '☑') }.to change { board.instance_variable_get(:@board)[4][1] }.to('☑')
      end
    end
  end

  describe '#take_input' do
    before do
      allow(board).to receive(:gets).and_return('1')
    end

    context 'when requesting column number' do
      it 'requests input with gets' do
        expect(board).to receive(:gets)
        board.take_input
      end

      it 'calls #place with col_input' do
        expect(board).to receive(:place).with(1, '☑')
        board.take_input
      end
    end

    context 'when it is the first turn' do
      it 'calls place with ☑' do
        expect(board).to receive(:place).with(1, '☑')
        board.take_input
      end
    end

    context 'when it is the second turn' do
      it 'calls place with ☒' do
        board.take_input
        expect(board).to receive(:place).with(1, '☒')
        board.take_input
      end
    end

    context 'when user inputs exit' do
      before do
        allow(board).to receive(:gets).and_return('exit')
      end

      it 'calls exit' do
        expect(board).to receive(:exit)
        board.take_input
      end
    end

    context 'when user inputs q' do
      before do
        allow(board).to receive(:gets).and_return('q')
      end

      it 'calls exit' do
        expect(board).to receive(:exit)
        board.take_input
      end
    end

    describe 'invalid inputs' do
      before do
        allow(board).to receive(:gets).and_return('hamster')
      end
      
      it 'does not call #place' do
        expect(board).not_to receive(:place)
        board.take_input
      end

      context 'when user inputs letter' do
        before do
          allow(board).to receive(:gets).and_return('g')
        end

        it 'displays error message' do
          expect(board).to receive(:puts).with("Invalid Input: Please input a number between 1 and 7")
          board.take_input
        end
      end

      context 'when user inputs large number' do
        before do
          allow(board).to receive(:gets).and_return('15')
        end

        it 'displays error message' do
          expect(board).to receive(:puts).with("Invalid Input: Please input a number between 1 and 7")
          board.take_input
        end
      end

      context 'when user inputs zero' do
        before do
          allow(board).to receive(:gets).and_return('0')
        end

        it 'displays error message' do
          expect(board).to receive(:puts).with("Invalid Input: Please input a number between 1 and 7")
          board.take_input
        end
      end

      context 'when user inputs negative number' do
        before do
          allow(board).to receive(:gets).and_return('-4')
        end

        it 'displays error message' do
          expect(board).to receive(:puts).with("Invalid Input: Please input a number between 1 and 7")
          board.take_input
        end
      end
    end
  end

  describe '#check_for_win' do
    before do
      allow(board).to receive(:win)
    end

    describe 'wins' do
      context 'horizontal win' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☒','☐','☐'],
          ['☑','☑','☑','☑','☒','☒','☐'],
        ]) }

        it 'displays winner text' do
          expect(board).to receive(:win)
          board.check_for_win
        end
      end

      context 'vertical win' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☒','☐','☐'],
          ['☑','☐','☐','☐','☒','☒','☐'],
        ]) }

        it 'displays winner text' do
          expect(board).to receive(:win)
          board.check_for_win
        end
      end

      context 'diaganol win' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☐','☑','☐','☐','☐','☐','☐'],
          ['☐','☐','☑','☐','☒','☐','☐'],
          ['☐','☐','☐','☑','☒','☒','☐'],
        ]) }

        it 'displays winner text' do
          expect(board).to receive(:win)
          board.check_for_win
        end
      end
    end

    describe 'losses' do
      context 'horizontal loss' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☑','☐','☑','☒','☒','☐'],
        ]) }

        it 'does not display winner text' do
          expect(board).not_to receive(:win)
          board.check_for_win
        end
      end

      context 'vertical loss' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☒','☒','☐'],
        ]) }

        it 'does not displays winner text' do
          expect(board).not_to receive(:win)
          board.check_for_win
        end
      end

      context 'diaganol loss' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☑','☐','☐','☐','☐'],
          ['☐','☐','☐','☑','☒','☒','☐'],
        ]) }

        it 'does not displays winner text' do
          expect(board).not_to receive(:win)
          board.check_for_win
        end
      end

      context 'edge loss' do
        subject(:board) { described_class.new([
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☐','☐','☐','☐','☐','☐','☐'],
          ['☑','☐','☐','☐','☐','☐','☐'],
          ['☑','☒','☐','☐','☐','☐','☐'],
          ['☑','☒','☐','☐','☐','☐','☐'],
        ]) }

        it 'does not displays winner text' do
          expect(board).not_to receive(:win)
          board.check_for_win
        end
      end
    end
  end

  describe '#play' do
    before do
      allow(board).to receive(:print)
      allow(board).to receive(:take_input)
      allow(board).to receive(:place)
      allow(board).to receive(:check_for_win).and_return(true)
    end

    context 'when game starts' do
      it 'calls print' do
        expect(board).to receive(:print)
        board.play
      end

      it 'calls take_input' do
        expect(board).to receive(:take_input)
        board.play
      end

      it 'calls check_for_win' do
        expect(board).to receive(:check_for_win)
        board.play
      end
    end
  end

  describe '#win' do
    before do
      allow(board).to receive(:print)
      allow(board).to receive(:puts)
    end

    it 'calls print' do
      expect(board).to receive(:print)
      board.win('☑')
    end

    context 'when ☑ wins' do
      it 'displays winner text' do
        expect(board).to receive(:puts).with("\n☑ Connected Four!")
        board.win('☑')
      end
    end

    context 'when ☒ wins' do
      it 'displays winner text' do
        expect(board).to receive(:puts).with("\n☒ Connected Four!")
        board.win('☒')
      end
    end
  end
end