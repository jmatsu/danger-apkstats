# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Helper
  describe Apkstats::Helper::Bytes do
    context "from_b" do
      let(:byte) { Bytes.from_b(100_000) }
      let(:negative_byte) { Bytes.from_b(-100_000) }

      it "to_b" do
        expect(byte.to_b).to be_within(0.01).of(100_000)
        expect(byte.to_s_b).to eq("+#{byte.to_b}")
        expect(negative_byte.to_b).to be_within(0.01).of(-100_000)
        expect(negative_byte.to_s_b).to eq(negative_byte.to_b.to_s)
      end

      it "to_kb" do
        expect(byte.to_kb).to be_within(0.01).of((100_000 / 1024.to_f).round(2))
        expect(byte.to_s_kb).to eq("+#{byte.to_kb}")
        expect(negative_byte.to_kb).to be_within(0.01).of((-100_000 / 1024.to_f).round(2))
        expect(negative_byte.to_s_kb).to eq(negative_byte.to_kb.to_s)
      end

      it "to_mb" do
        expect(byte.to_mb).to be_within(0.01).of(((100_000 / 1024.to_f).round(2) / 1024.to_f).round(2))
        expect(byte.to_s_mb).to eq("+#{byte.to_mb}")
        expect(negative_byte.to_mb).to be_within(0.01).of(((-100_000 / 1024.to_f).round(2) / 1024.to_f).round(2))
        expect(negative_byte.to_s_mb).to eq(negative_byte.to_mb.to_s)
      end
    end

    context "from_kb" do
      let(:byte) { Bytes.from_kb(1234.56) }
      let(:negative_byte) { Bytes.from_kb(-1234.56) }

      it "to_b" do
        expect(byte.to_b).to be_within(0.01).of(1234.56 * 1024)
        expect(byte.to_s_b).to eq("+#{byte.to_b}")
        expect(negative_byte.to_b).to be_within(0.01).of(-1234.56 * 1024)
        expect(negative_byte.to_s_b).to eq(negative_byte.to_b.to_s)
      end

      it "to_kb" do
        expect(byte.to_kb).to be_within(0.01).of(1234.56)
        expect(byte.to_s_kb).to eq("+#{byte.to_kb}")
        expect(negative_byte.to_kb).to be_within(0.01).of(-1234.56)
        expect(negative_byte.to_s_kb).to eq(negative_byte.to_kb.to_s)
      end

      it "to_mb" do
        expect(byte.to_mb).to be_within(0.01).of((1234.56 / 1024.to_f).round(2))
        expect(byte.to_s_mb).to eq("+#{byte.to_mb}")
        expect(negative_byte.to_mb).to be_within(0.01).of((-1234.56 / 1024.to_f).round(2))
        expect(negative_byte.to_s_mb).to eq(negative_byte.to_mb.to_s)
      end
    end

    context "from_mb" do
      let(:byte) { Bytes.from_mb(12.34) }
      let(:negative_byte) { Bytes.from_mb(-12.34) }

      it "to_b" do
        expect(byte.to_b).to be_within(0.01).of(12.34 * 1024 * 1024)
        expect(byte.to_s_b).to eq("+#{byte.to_b}")
        expect(negative_byte.to_b).to be_within(0.01).of(-12.34 * 1024 * 1024)
        expect(negative_byte.to_s_b).to eq(negative_byte.to_b.to_s)
      end

      it "to_kb" do
        expect(byte.to_kb).to be_within(0.01).of(12.34 * 1024)
        expect(byte.to_s_kb).to eq("+#{byte.to_kb}")
        expect(negative_byte.to_kb).to be_within(0.01).of(-12.34 * 1024)
        expect(negative_byte.to_s_kb).to eq(negative_byte.to_kb.to_s)
      end

      it "to_mb" do
        expect(byte.to_mb).to be_within(0.01).of(12.34)
        expect(byte.to_s_mb).to eq("+#{byte.to_mb}")
        expect(negative_byte.to_mb).to be_within(0.01).of(-12.34)
        expect(negative_byte.to_s_mb).to eq(negative_byte.to_mb.to_s)
      end
    end

    it "up_unit" do
      expect(Bytes.up_unit(100)).to be_within(0.01).of(100.to_f / 1024)
      expect(Bytes.up_unit(234)).to be_within(0.01).of(234.to_f / 1024)
    end

    it "down_unit" do
      expect(Bytes.down_unit(100)).to eq(100 * 1024)
      expect(Bytes.down_unit(234)).to eq(234 * 1024)
    end
  end
end
