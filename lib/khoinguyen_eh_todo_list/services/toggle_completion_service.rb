# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to toggle the completion status of a task
    class ToggleCompletionService
      def self.call(tasks, index) # rubocop:disable Metrics/MethodLength
        index = index.to_i - 1
        task = tasks[index]
        raise "Task not found" unless task

        # Toggle the task completion state
        task.toggle_completion

        message = task.completed? ? "Task completed." : "Task marked as incomplete."

        {
          success: true,
          message: message,
          memento: Memento.new(:toggle, { index: index })
        }
      rescue StandardError => e
        { success: false, error: e.message }
      end

      # Reverts the toggle action
      def self.revert(tasks, memento)
        task = tasks[memento.data[:index]]
        task.toggle_completion
      end

      # Re-applies the toggle action
      def self.apply(tasks, memento)
        task = tasks[memento.data[:index]]
        task.toggle_completion
      end
    end
  end
end
