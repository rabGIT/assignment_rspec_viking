require 'warmup'

describe Warmup do
  let(:warmup) { Warmup.new }

  describe '#gets_shout ' do
    it 'gets user input and capitalizes it ' do
      allow(warmup).to receive(:gets).and_return('pass')
      expect(warmup.gets_shout).to eq('PASS')
    end
  end

  describe '#triple_size ' do
    it 'takes an input array and returns triple the size ' do
      array_double = double(:size => 15)
      expect(warmup.triple_size(array_double)).to eq(45)
    end
  end

  describe '#calls_some_methods ' do

    it 'calls #upcase ' do
      string_double = double(:empty? => false, :upcase! => 'INPUT', :reverse! => 'TUPNI')
      expect(string_double).to receive(:upcase!).and_return('INPUT')
      warmup.calls_some_methods(string_double)
    end

    it 'calls #reverse ' do
      string_double = spy(:empty? => false, :upcase! => 'INPUT', :reverse! => 'TUPNI')
      expect(string_double).to have_receive(:reverse!)
      warmup.calls_some_methods(string_double)
    end

    it ' returns a different object ' do
      string_double = double(:empty? => false, :upcase! => 'INPUT', :reverse! => 'TUPNI')
      expect(warmup.calls_some_methods(string_double)).not_to be equal?(string_double)
    end
  end
end
