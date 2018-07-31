# frozen_string_literal: true

module Apkstats::Helper
  module Bytes
    STEP = 2**10.to_f

    def self.from_b(byte)
      Byte.new(byte)
    end

    def self.from_kb(k_byte)
      Byte.new(down_unit(k_byte))
    end

    def self.from_mb(m_byte)
      Byte.new(down_unit(down_unit(m_byte)))
    end

    def self.up_unit(size)
      (size.to_f / STEP).round(2)
    end

    def self.down_unit(size)
      size.to_f * STEP
    end

    class Byte
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_b
        value
      end

      def to_kb
        Bytes.up_unit(value)
      end

      def to_mb
        Bytes.up_unit(to_kb)
      end

      def to_s_b
        add_op(to_b)
      end

      def to_s_kb
        add_op(to_kb)
      end

      def to_s_mb
        add_op(to_mb)
      end

      private

      def add_op(size)
        size.negative? ? size.to_s : "+#{size}"
      end
    end
  end
end
