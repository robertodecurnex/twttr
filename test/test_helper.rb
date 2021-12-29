# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

SimpleCov.start do
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = 'coverage/lcov.info'
  end

  formatter SimpleCov::Formatter::LcovFormatter
end

require 'minitest'
require 'minitest/autorun'

require './lib/twttr'
