class BVHash
  attr_accessor :keys, :vals

  def initialize
    @keys = []
    @vals = []
  end

  def set(key, val)
    key_pos = key_position(key)

    keys[key_pos] = key
    vals[key_pos] = val
  end

  def get(key)
    key_pos = key_position(key)
    vals[key_pos]
  end

  def key_position(key)
    i = 0

    keys.each {|k|
      if k == key
        break
      end
      i = i + 1
    }

    i
  end
end
