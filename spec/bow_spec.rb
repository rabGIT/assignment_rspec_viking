require './lib/weapons/bow'

describe Bow do
  let(:bow) { Bow.new }

  describe ' initialize ' do
    it ' default arrows is 10 ' do
      expect(bow.arrows).to eq(10)
    end
  end

  describe ' attribute reader ' do
    it ' returns the number of arrows ' do
      expect(bow.arrows).to be > 0
    end
  end

  describe ' non default initialization  ' do
    let(:bow2) { Bow.new(20) }
    it ' has the right num arrows ' do
      expect(bow2.arrows).to eq(20)
    end
  end

  describe ' using the bow ' do
    it ' reduces arrow count by 1 ' do
      numArrows = bow.arrows
      bow.use
      expect(bow.arrows).to eq(numArrows - 1)
    end
  end

  describe ' using the bow with no arrows  ' do
    let(:bow2) { Bow.new(0) }
    it ' produces an error ' do
      expect { bow2.use }.to raise_error(RuntimeError, 'Out of arrows')
    end
  end
end
