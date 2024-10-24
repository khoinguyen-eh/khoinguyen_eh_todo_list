# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to remove a task from the list
    class RemoveTaskService
      def self.call(tasks, index)
        index = index.to_i - 1
        task = tasks.delete_at(index)
        raise "Task not found" unless task

        {
          success: true,
          message: "Task removed successfully.",
          memento: Memento.new(:remove, { index: index, task: task })
        }
      rescue StandardError => e
        { success: false, error: e.message }
      end

      # Reverts the removal of the task
      def self.revert(tasks, memento)
        tasks.insert(memento.data[:index], memento.data[:task])
      end

      # Re-applies the removal of the task
      def self.apply(tasks, memento)
        tasks.delete_at(memento.data[:index])
      end
    end
  end
end
