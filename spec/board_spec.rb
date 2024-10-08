require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#print' do
    context 'when board is empty' do
      it 'displays empty board' do
        expect(board).to receive(:puts).with("\n# # # # # # #\n# # # # # # #\n# # # # # # #\n# # # # # # #\n# # # # # # #\n# # # # # # #")
        board.print
      end
    end
  end
end