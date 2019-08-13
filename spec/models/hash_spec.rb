require 'rails_helper'

RSpec.describe BVHash do
  describe "set" do
    it "sets a key on an empty hash" do
      hash = BVHash.new
      hash.set("bv", true)

      expect(hash.get("bv")).to eq(true)
    end

    it "sets a new key on an existing hash" do
      hash = BVHash.new
      hash.set("bv", true)
      hash.set("bv1", false)

      expect(hash.get("bv")).to eq(true)
      expect(hash.get("bv1")).to eq(false)
    end

    it "sets an existing key on a hash" do
      hash = BVHash.new
      hash.set("bv", true)
      hash.set("bv1", false)
      hash.set("bv", false)

      expect(hash.get("bv")).to eq(false)
    end
  end

  describe "get" do
    it "returns nil on empty hash" do
      hash = BVHash.new
      expect(hash.get("somekey")).to be_nil
    end

    it "returns nil when the key is not set" do
      hash = BVHash.new
      hash.set("bv", true)

      expect(hash.get("somekey")).to be_nil
    end

    it "returns the value set with the given key" do
      hash = BVHash.new
      hash.set("bv", true)

      expect(hash.get("bv")).to eq(true)
    end
  end
end
