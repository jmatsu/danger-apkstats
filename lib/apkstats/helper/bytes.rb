module Apkstats::Helper
  module Bytes
    STEP = 2**10.to_f

    def self.from_b(byte)
      Byte.new(byte)
    end

    def self.from_kb(kb)
      Byte.new(down_unit(kb))
    end

    def self.from_mb(mb)
      Byte.new(down_unit(down_unit(mb)))
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

      def to_b(show_plus: false)
        handle_plus(value, show_plus)
      end

      def to_kb(show_plus: false)
        handle_plus(Bytes.up_unit(value), show_plus)
      end

      def to_mb(show_plus: false)
        handle_plus(Bytes.up_unit(to_kb), show_plus)
      end

      private

      def handle_plus(size, show_plus)
        !show_plus || size < 0 ? size : "+#{size}"
      end
    end
  end
end