module Apkstats::Entity
  class Feature
    # String
    attr_reader :name

    # String?
    attr_reader :impiled_reason

    def initialize(name, not_required: nil, impiled_reason: nil)
      @name = name
      @not_required = not_required
      @impiled_reason = impiled_reason
    end

    def not_required?
      # cast to Boolean
      @not_required == true
    end

    def impiled?
      @impiled_reason
    end

    def to_s
      if impiled?
        "#{name} (#{impiled_reason})"
      elsif not_required?
        "#{name} (not-required)"
      else
        name
      end
    end

    def eql?(other)
      return if !other || other.class == Feature
      other.name == name &&
        other.not_required? == not_required? &&
        other.impiled_reason == impiled_reason
    end

    def hash
      h = not_required? ? 1 : 0
      h *= 31
      h += name.hash

      if impiled_reason
        h *= 31
        h += impiled_reason.hash
      end

      h
    end
  end

  class Features
    attr_reader :values

    # Array<Feature>
    def initialize(feature_arr)
      @values = feature_arr
    end

    def -(other)
      raise "#{self.class} cannot handle #{other.class} with the minus operator" unless other.class == Features

      self_hash = Features.hashnize(self)
      other_hash = Features.hashnize(other)

      diff_features = (self_hash.keys - other_hash.keys).map do |key|
        self_hash[key]
      end

      Features.new(diff_features)
    end

    def to_a
      values.map(&:to_s)
    end

    def eql?(other)
      return if !other || other.class == Features
      other.values == values
    end

    def hash
      other.hash
    end

    def self.hashnize(features)
      features.values.each_with_object({}) do |feature, acc|
        acc[[feature.name, feature.not_required?]] = feature
      end
    end
  end
end
