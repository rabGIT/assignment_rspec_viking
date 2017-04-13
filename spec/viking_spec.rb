require 'viking'

describe Viking do
  describe ' #initialize ' do
    it ' assigns name correctly when passed in ' do
      viking = Viking.new('igor')
      expect(viking.name).to eq('igor')
    end

    it ' assigns health correctly when passed in ' do
      viking = Viking.new('igor', 125)
      expect(viking.health).to eq(125)
    end

    it ' health does not have a write attribute ' do
      viking = Viking.new('igor', 125)
      expect { viking.health= 20 }.to raise_error(NoMethodError)
    end

    it ' weapon is nil at initialization ' do
      viking = Viking.new('igor', 125)
      expect(viking.weapon).to be_nil
    end
  end

  describe ' #pick_up_weapon ' do
    let(:viking) { Viking.new('igor', 125) }

    it ' properly assigns a weapon when one is picked up ' do
      weapon = double(:is_a? => true)
      viking.pick_up_weapon(weapon)
      expect(viking.weapon).to eq(weapon)
    end

    it ' error if not a weapon ' do
      weapon = double(:is_a? => false)
      expect { viking.pick_up_weapon(weapon) }.to raise_error(RuntimeError)
    end

    it ' picking up a new weapon changes the weapon ' do
      weapon = double(:is_a? => true)
      weapon2 = double(:is_a? => true)
      viking.pick_up_weapon(weapon)
      viking.pick_up_weapon(weapon2)
      expect(viking.weapon).to eq(weapon2)
    end
  end

  describe ' #drop_weapon ' do
    let(:viking) { Viking.new('igor', 125) }

    it ' sets @weapon to nil if dropped ' do
      weapon = double(:is_a? => true)
      viking.pick_up_weapon(weapon)
      viking.drop_weapon
      expect(viking.weapon).to be_nil
    end
  end

  describe ' #receive_attack ' do
    let(:viking) { Viking.new('igor', 125) }

    it ' reduces health by the specified amount ' do
      starting_health = viking.health
      viking.receive_attack(25)
      expect(viking.health).to eq(100)
    end

    it ' calls the #take_damage method (private) ' do
      expect(viking).to receive(:take_damage)
      viking.receive_attack(10)
    end
  end

  describe ' @attack ' do
    let(:viking) { Viking.new('igor', 125) }
    let(:victim) { Viking.new('punchy', 50) }

    it ' attacking a target reduces their health ' do
      starting_health = victim.health
      viking.attack(victim)
      expect(victim.health).to be < starting_health
    end

    it ' attacking a target calls their #take_damage ' do
      expect(victim).to receive(:take_damage)
      viking.attack(victim)
    end

    it ' attacking a target with no weapon calls #damage_with_fists ' do
      expect(viking).to receive(:damage_with_fists).and_return(5)
      viking.drop_weapon
      viking.attack(victim)
    end

    it ' attacking a target with no weapon does fists multiplier damage times strength ' do
      viking.drop_weapon
      starting_health = victim.health
      viking.attack(victim)
      expect(starting_health - victim.health).to eq(viking.strength * 0.25)
    end

    it ' attacking a target with a weapon calls #damage_with_weapon ' do
      weapon = double(:is_a? => true)
      expect(viking).to receive(:damage_with_weapon).and_return(7)
      viking.drop_weapon
      viking.pick_up_weapon(weapon)
      viking.attack(victim)
    end

    it ' attacking a target with weapon does multiplier damage times strength ' do
      viking.drop_weapon
      starting_health = victim.health
      weapon = double(:is_a? => true, :use => 3)
      viking.pick_up_weapon(weapon)
      viking.attack(victim)
      expect(starting_health - victim.health).to eq(viking.strength * 3)
    end

    it ' when using a bow without enough arrows defaults to fists ' do
      expect(viking).to receive(:damage_with_fists).and_return(6)
      viking.pick_up_weapon(Bow.new(0))
      viking.attack(victim)
    end

    it ' death raises an error ' do
      expect{ loop { viking.attack(victim) } }.to raise_error(RuntimeError, "#{victim.name} has Died...")

    end
  end

end
