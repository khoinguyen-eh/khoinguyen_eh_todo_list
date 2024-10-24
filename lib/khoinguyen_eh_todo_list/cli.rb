# frozen_string_literal: true

require "yaml"
require "thor"

DIR = File.dirname(__FILE__)
Dir[File.join(DIR, "*.rb")].sort.each { |file| require file }
Dir[File.join(DIR, "services", "*.rb")].sort.each { |file| require file }

module KhoinguyenEhTodoList
  # Command line interface for the todo list
  class CLI < Thor
    TASKS_FILE = "tasks.yml"

    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @tasks = load_tasks
      @caretaker = Caretaker.new
    end

    desc "add TITLE", "Add a new task"

    def add(title)
      execute_action(KhoinguyenEhTodoList::Services::AddTaskService, title)
    end

    desc "remove INDEX", "Remove a task by index"

    def remove(index)
      execute_action(KhoinguyenEhTodoList::Services::RemoveTaskService, index)
    end

    desc "clear", "Clear all tasks"

    def clear
      execute_action(KhoinguyenEhTodoList::Services::ClearTasksService)
    end

    desc "move FROM TO", "Move a task from one index to another"

    def move(from, to)
      execute_action(KhoinguyenEhTodoList::Services::MoveTaskService, from, to)
    end

    desc "toggle INDEX", "Toggle task completion status"

    def toggle(index)
      execute_action(KhoinguyenEhTodoList::Services::ToggleCompletionService, index)
    end

    desc "undo", "Undo the last action"

    def undo
      execute_action(KhoinguyenEhTodoList::Services::UndoRedoService, @caretaker, :undo)
    end

    desc "redo", "Redo the last undone action"

    def redo
      execute_action(KhoinguyenEhTodoList::Services::UndoRedoService, @caretaker, :redo)
    end

    desc "list", "List all tasks"

    def list
      @tasks.each_with_index { |task, index| puts "#{index + 1}. #{task}" }
    end

    desc "history", "Show the number of undoable and redoable actions"

    def history
      puts "Undoable actions: #{@caretaker.undo_history_count}"
      puts "Redoable actions: #{@caretaker.redo_history_count}"
    end

    private

    # Executes an action and saves the memento
    # @param service [Class] - The service class to execute
    # @param args [Array] - Arguments for the service call
    def execute_action(service, *args)
      result = service.call(@tasks, *args)

      if result && result[:success]
        @caretaker.add_memento(result[:memento]) if result[:memento]
        puts result[:message] if result[:message]
        save_tasks
      elsif result && result[:error]
        puts "[ERROR] #{result[:error]}"
      end
    end

    def load_tasks
      return [] unless File.exist?(TASKS_FILE)

      YAML.load_file(TASKS_FILE) || []
    end

    def save_tasks
      File.open(TASKS_FILE, "w") { |file| file.write(@tasks.to_yaml) }
    end
  end
end
