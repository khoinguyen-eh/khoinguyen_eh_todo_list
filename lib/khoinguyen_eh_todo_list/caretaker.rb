# frozen_string_literal: true

require "yaml"

module KhoinguyenEhTodoList
  # Caretaker class to manage the undo and redo history
  class Caretaker
    UNDO_FILE = "undo_history.yml"
    REDO_FILE = "redo_history.yml"

    def initialize
      @undo_history = load_history(UNDO_FILE)
      @redo_history = load_history(REDO_FILE)
    end

    # Adds a memento to the undo history and saves to file
    # @param memento [Memento]
    def add_memento(memento)
      @undo_history.push(memento)
      save_history(@undo_history, UNDO_FILE)
      clear_redo_history # Clear redo history when a new action is added
    end

    # Returns the last memento from the undo history
    # @return [Memento, nil]
    def undo
      memento = @undo_history.pop
      save_history(@undo_history, UNDO_FILE)
      @redo_history.push(memento) if memento
      save_history(@redo_history, REDO_FILE)
      memento
    end

    # Returns the last memento from the redo history
    # @return [Memento, nil]
    def redo
      memento = @redo_history.pop
      save_history(@redo_history, REDO_FILE)
      @undo_history.push(memento) if memento
      save_history(@undo_history, UNDO_FILE)
      memento
    end

    # Clears the redo history
    def clear_redo_history
      @redo_history.clear
      save_history(@redo_history, REDO_FILE)
    end

    # Returns the history count for undo
    # @return [Integer]
    def undo_history_count
      @undo_history.size
    end

    # Returns the history count for redo
    # @return [Integer]
    def redo_history_count
      @redo_history.size
    end

    private

    # Loads history from a file
    # @param file [String] - The file to load from
    # @return [Array<Memento>]
    def load_history(file)
      return [] unless File.exist?(file)

      YAML.load_file(file).map { |yaml| Memento.from_yaml(yaml) }
    rescue StandardError
      [] # Return empty array if any error occurs while loading
    end

    # Saves the history to a file
    # @param history [Array<Memento>]
    # @param file [String]
    def save_history(history, file)
      File.open(file, "w") { |f| f.write(history.map(&:to_yaml).to_yaml) }
    end
  end
end
