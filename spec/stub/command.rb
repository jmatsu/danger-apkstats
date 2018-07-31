# frozen_string_literal: true

module Apkstats::Stub
  class Command
    include Apkstats::Command::Executable

    def initialize(defaults = {})
      @command_path = __FILE__
      @defaults = defaults
    end

    def method_missing(name, *arguments, &block)
      Apkstats::Entity::ApkInfo::KEYS.include?(name.to_sym) && !block && arguments.size == 1 && @defaults[name.to_sym] || super
    end

    def respond_to_missing?(method_name, _include_private = false)
      Apkstats::Entity::ApkInfo::KEYS.include?(method_name.to_sym) || super
    end
  end
end
