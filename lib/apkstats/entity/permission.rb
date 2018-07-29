module Apkstats::Entity
  class Permission
    # String
    attr_reader :name

    # String?
    attr_reader :max_sdk

    def initialize(name, max_sdk = nil)
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
  end

  class Permissions
    attr_reader :values

    # Array<Permission>
    def initialize(permission_arr)
      @values = permission_arr
    end

    def -(other)
      raise "#{self.class} cannot handle #{other.class} with the minus operator" unless other.class == Permissions

      self_name_hash = Permissions.name_hash(self)
      other_name_hash = Permissions.name_hash(other)

      diff_permissions = (self_name_hash.keys - other_name_hash.keys).map do |key|
        self_name_hash[key]
      end

      Permissions.new(diff_permissions)
    end

    def to_a
      values.map(&:to_s)
    end

    def self.name_hash(permissions)
      permissions.values.each_with_object({}) do |permission, acc|
        acc[permission.name] = permission
      end
    end
  end
end
