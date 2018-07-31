# frozen_string_literal: true

module Apkstats::Entity
  class Feature
    # String
    attr_reader :name

    # String?
    attr_reader :implied_reason

    def initialize(name, not_required: false, implied_reason: nil)
      @name = name
      # cast to Boolean
      @not_required = not_required == true
      @implied_reason = implied_reason || nil
    end

    def not_required?
      @not_required
    end

    def implied?
      @implied_reason
    end

    def to_s
      if implied?
        "#{name} (#{implied_reason})"
      elsif not_required?
        "#{name} (not-required)"
      else
        name
      end
    end

    def ==(other)
      return if !other || other.class != self.class

      to_s == other.to_s
    end

    def eql?(other)
      to_s.eql?(other.to_s)
    end

    def hash
      h = not_required? ? 1 : 0
      h *= 31
      h += name.hash

      if implied_reason
        h *= 31
        h += implied_reason.hash
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
      values.hash
    end

    def self.hashnize(features)
      features.values.each_with_object({}) do |feature, acc|
        acc[[feature.name, feature.not_required?]] = feature
      end
    end
  end
end
