# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to move a task in the list
    class MoveTaskService
      def self.call(tasks, from, to)
        from_idx = from.to_i - 1
        to_idx = to.to_i - 1

        if from_idx.negative? || to_idx.negative? || from_idx >= tasks.size || to_idx >= tasks.size
          raise "Invalid indices"
        end

        task = tasks.delete_at(from_idx)
        tasks.insert(to_idx, task)

        { success: true, memento: Memento.new(:move, { from: from_idx, to: to_idx }) }
      rescue StandardError => e
        { success: false, error: e.message }
      end

      # Reverts the move action
      # @param tasks [Array<Task>] the list of tasks
      # @param memento [Memento] the memento to revert
      # @return [void]
      def self.revert(tasks, memento)
        task = tasks.delete_at(memento.data[:to])
        tasks.insert(memento.data[:from], task)
      end

      # Re-applies the move action
      # @param tasks [Array<Task>] the list of tasks
      # @param memento [Memento] the memento to apply
      # @return [void]
      def self.apply(tasks, memento)
        task = tasks.delete_at(memento.data[:from])
        tasks.insert(memento.data[:to], task)
      end
    end
  end
end
