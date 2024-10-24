# frozen_string_literal: true

module KhoinguyenEhTodoList
  # Represents a task in the todo list
  class Task
    attr_accessor :title, :completed

    def initialize(title)
      @title = title
      @completed = false
    end

    # Toggles the completion status of the task
    def toggle_completion
      @completed = !@completed
    end

    # Returns the completion status
    # @return [Boolean]
    def completed?
      @completed
    end

    def to_s
      status = @completed ? "[X]" : "[ ]"
      "#{status} #{@title}"
    end
  end
end
