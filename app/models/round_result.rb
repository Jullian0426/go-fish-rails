# frozen_string_literal: true

class RoundResult
  attr_accessor :text

  def initialize(text)
    @text = text
  end

  def self.from_json(round_result_data)
    text = round_result_data['text']
    RoundResult.new(text)
  end
end
