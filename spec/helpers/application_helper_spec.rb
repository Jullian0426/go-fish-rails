require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context '#format_time' do
    it 'formats time correctly when time is more than an hour' do
      expect(format_time(3665)).to eq('1h:1m') # 1 hour, 1 minute, and 5 seconds
    end

    it 'formats time correctly when time is more than a minute but less than an hour' do
      expect(format_time(125)).to eq('2m:5s') # 2 minutes and 5 seconds
    end

    it 'formats time correctly when time is less than a minute' do
      expect(format_time(45)).to eq('45s') # 45 seconds
    end
  end
end
