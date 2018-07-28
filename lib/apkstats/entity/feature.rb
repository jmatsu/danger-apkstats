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
      @not_required
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
  end

  class Features
    attr_reader :values

    # Array<Feature>
    def initialize(feature_arr)
      @values = feature_arr
    end

    def -(other)
      raise "#{self.class} cannot handle #{other.class} with the minus operator" unless other.class == Features

      self_name_hash = Features.name_hash(self)
      other_name_hash = Features.name_hash(other)

      diff_features = (self_name_hash.keys - other_name_hash.keys).map do |key|
        self_name_hash[key]
      end

      Features.new(diff_features)
    end

    def to_a
      values.map(&:to_s)
    end

    def self.name_hash(features)
      features.values.each_with_object({}) do |feature, acc|
        acc[feature.name] = feature
      end
    end
  end
end
