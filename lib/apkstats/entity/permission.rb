# frozen_string_literal: true

module Apkstats::Entity
  class Permission
    # String
    attr_reader :name

    # String?
    attr_reader :max_sdk

    def initialize(name, max_sdk: nil)
      @name = name
      @max_sdk = max_sdk
    end

    def to_s
      if max_sdk
        "#{name} maxSdkVersion=#{max_sdk}"
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
      h = name.hash

      if max_sdk
        h *= 31
        h += max_sdk.hash
      end

      h
    end
  end

  class Permissions
    attr_reader :values

    # Array<Permission>
    def initialize(permission_arr)
      @values = permission_arr
    end

    def -(other)
      raise "#{self.class} cannot handle #{other.class} with the minus operator" unless other.class == Permissions

      self_hash = Permissions.hashnize(self)
      other_hash = Permissions.hashnize(other)

      diff_permissions = (self_hash.keys - other_hash.keys).map do |key|
        self_hash[key]
      end

      Permissions.new(diff_permissions)
    end

    def to_a
      values.map(&:to_s)
    end

    def eql?(other)
      return if !other || other.class == Permissions
      other.values == values
    end

    def hash
      values.hash
    end

    def self.hashnize(permissions)
      permissions.values.each_with_object({}) do |permission, acc|
        acc[[permission.name, permission.max_sdk]] = permission
      end
    end
  end
end
