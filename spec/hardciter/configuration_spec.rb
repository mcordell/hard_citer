# encoding: utf-8
require 'spec_helper'

module HardCiter


  describe '#configuration' do
    let(:default_csl) { HardCiter::Configuration::CSL }
    let(:default_bibliography_pattern) { HardCiter::Configuration::BIBLIOGRAPHY_PATTERN }
    let(:default_intext_pattern) { HardCiter::Configuration::INTEXT_PATTERN }

    it 'should allow access to default CSL path' do
      HardCiter.configuration.csl.should eq default_csl
    end

    it 'should allow access to default Bibliography intext key' do
      HardCiter.configuration.bibliography_pattern.should eq default_bibliography_pattern
    end

    it 'should allow access to default intext regex' do
      HardCiter.configuration.intext_pattern.should eq default_intext_pattern
    end
  end

  describe '#configure' do
    context 'when provided a block' do
      after { HardCiter.configuration.reset }
      it 'should change configuration values of the HardCiter' do
        csl_new_value = 'Testing new value'
        HardCiter.configure do |config|
          config.csl = csl_new_value
        end

        HardCiter.configuration.csl.should eq csl_new_value
      end
    end
  end
end