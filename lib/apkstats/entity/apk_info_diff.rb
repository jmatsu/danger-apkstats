# frozen_string_literal: true

module Apkstats::Entity
  class ApkInfoDiff
    KEYS = Apkstats::Entity::ApkInfo::KEYS

    # ApkInfo
    attr_reader :base, :other

    private(:base, :other)

    def initialize(base, other)
      @base = base
      @other = other
    end

    def to_h
      KEYS.each_with_object({}) do |key, acc|
        acc[key] = self.send(key)
      end.compact
    end

    def file_size
      # Integer
      @base[__method__].to_i - @other[__method__].to_i
    end

    def download_size
      # Integer
      @base[__method__].to_i - @other[__method__].to_i
    end

    def required_features
      # Features
      {
          new: (@base[__method__] - @other[__method__]).to_a,
          removed: (@other[__method__] - @base[__method__]).to_a,
      }
    end

    def non_required_features
      # Features
      {
          new: (@base[__method__] - @other[__method__]).to_a,
          removed: (@other[__method__] - @base[__method__]).to_a,
      }
    end

    def permissions
      # Permissions
      {
          new: (@base[__method__] - @other[__method__]).to_a,
          removed: (@other[__method__] - @base[__method__]).to_a,
      }
    end

    def min_sdk
      # String
      [@base[__method__], @other[__method__]].uniq
    end

    def target_sdk
      # String
      [@base[__method__], @other[__method__]].uniq
    end

    def method_reference_count
      # Integer
      @base[__method__].to_i - @other[__method__].to_i
    end

    def dex_count
      # Integer
      @base[__method__].to_i - @other[__method__].to_i
    end
  end
end
