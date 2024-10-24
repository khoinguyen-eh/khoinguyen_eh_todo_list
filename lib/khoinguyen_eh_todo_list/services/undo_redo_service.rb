# frozen_string_literal: true

module KhoinguyenEhTodoList
  module Services
    # Service object to handle undo and redo operations
    class UndoRedoService
      # Handles undo or redo operation based on the action passed
      # @param tasks [Array<Task>]
      # @param caretaker [Caretaker]
      # @param action [Symbol] - :undo or :redo
      # @return [Hash]
      def self.call(tasks, caretaker, action) # rubocop:disable Metrics/MethodLength
        memento = case action
                  when :undo
                    caretaker.undo
                  when :redo
                    caretaker.redo
                  else
                    return { success: false, message: "Invalid action. Use :undo or :redo." }
                  end

        return { success: true, message: "Nothing to #{action}." } unless memento && memento.action != :blank

        service = determine_service(memento.action)
        if service
          action == :undo ? service.revert(tasks, memento) : service.apply(tasks, memento)
          { success: true, message: "#{action.capitalize} successful." }
        else
          { success: false, message: "Action not supported." }
        end
      end

      # Determines the appropriate service for the given action
      # @param action [Symbol]
      # @return [Class, nil]
      def self.determine_service(action) # rubocop:disable Metrics/MethodLength
        case action
        when :add
          KhoinguyenEhTodoList::Services::AddTaskService
        when :remove
          KhoinguyenEhTodoList::Services::RemoveTaskService
        when :move
          KhoinguyenEhTodoList::Services::MoveTaskService
        when :toggle
          KhoinguyenEhTodoList::Services::ToggleCompletionService
        when :clear
          KhoinguyenEhTodoList::Services::ClearTasksService
        end
      end
    end
  end
end
