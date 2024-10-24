# frozen_string_literal: true

require "yaml"

module KhoinguyenEhTodoList
  # Represents a memento for the undo and redo history
  class Memento
    attr_reader :action, :data

    # @param action [Symbol] The type of action (e.g., :add, :remove)
    # @param data [Hash] The details of the change
    def initialize(action, data)
      @action = action
      @data = data
    end

    # Serializes the memento to YAML
    # @return [String]
    def to_yaml
      YAML.dump({ action: @action, data: @data })
    end

    # Deserializes memento from YAML
    # @param yaml [String]
    # @return [Memento]
    def self.from_yaml(yaml)
      state = YAML.safe_load(yaml)
      new(state[:action], state[:data])
    end
  end
end
