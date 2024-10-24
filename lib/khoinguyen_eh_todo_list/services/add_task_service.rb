# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to add a task to the list
    class AddTaskService
      def self.call(tasks, title)
        task = Task.new(title)
        tasks << task
        {
          success: true,
          message: "Task added successfully.",
          memento: Memento.new(:add, { index: tasks.size - 1, task: task })
        }
      rescue StandardError => e
        { success: false, error: e.message }
      end

      # Reverts the addition of the task
      def self.revert(tasks, memento)
        tasks.delete_at(memento.data[:index])
      end

      # Re-applies the addition of the task
      def self.apply(tasks, memento)
        tasks.insert(memento.data[:index], memento.data[:task])
      end
    end
  end
end
