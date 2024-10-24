# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to clear all tasks from the list
    class ClearTasksService
      def self.call(tasks)
        previous_tasks = tasks.dup
        tasks.clear
        {
          success: true,
          message: "Tasks cleared successfully.",
          memento: Memento.new(:clear, { tasks: previous_tasks })
        }
      rescue StandardError => e
        { success: false, error: e.message }
      end

      # Reverts the clear action
      def self.revert(tasks, memento)
        tasks.concat(memento.data[:tasks])
      end

      # Re-applies the clear action
      def self.apply(tasks, _memento)
        tasks.clear
      end
    end
  end
end
