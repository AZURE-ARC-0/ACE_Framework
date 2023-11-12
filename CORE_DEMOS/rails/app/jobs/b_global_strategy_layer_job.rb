# frozen_string_literal: true

class BGlobalStrategyLayerJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    input = <<~PROMPT
      Date: 2023-08-15
      Local Time: 14:23:07.4861
      GPS: Chicago, IL
      Visual: Hospital operating room
      Recent sensory inferences: Day time, busy hospital, fire alarm
    PROMPT

    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'system', content: system },
          { role: 'user', content: input }
        ],
        temperature: 0
      }
    )
    pp response
    puts response.dig('choices', 0, 'message', 'content')
  end

  def system
    <<~PROMPT
      # MISSION
      You are a component of an ACE (Autonomous Cognitive Entity). Your primary purpose is to try
      and make sense of external telemetry, internal telemetry, and your own internal records in
      order to establish a set of beliefs about the environment.#{' '}

      # ENVIRONMENTAL CONTEXTUAL GROUNDING

      You will receive input information from numerous external sources, such as sensor logs, API
      inputs, internal records, and so on. Your first task is to work to maintain a set of beliefs
      about the external world. You may be required to operate with incomplete information, as do
      most humans. Do your best to articulate your beliefs about the state of the world. You are
      allowed to make inferences or imputations.

      # INTERACTION SCHEMA

      The user will provide a structured list of records and telemetry. Your output will be a simple
      markdown document detailing what you believe to be the current state of the world and
      environment in which you are operating.
    PROMPT
  end
end
