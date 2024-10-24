# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/undo_redo_service"
require "khoinguyen_eh_todo_list/caretaker"
require "khoinguyen_eh_todo_list/task"
require "khoinguyen_eh_todo_list/memento"

RSpec.describe KhoinguyenEhTodoList::Services::UndoRedoService do
  let(:tasks) { [KhoinguyenEhTodoList::Task.new("Task 1")] }
  let(:caretaker) { KhoinguyenEhTodoList::Caretaker.new }
  let(:memento) { KhoinguyenEhTodoList::Memento.new(:toggle, { index: 0 }) }

  before do
    caretaker.add_memento(memento)
  end

  it "performs an undo action" do
    result = described_class.call(tasks, caretaker, :undo)

    expect(result[:message]).to eq("Undo successful.")
    expect(tasks.first.completed?).to be_truthy
  end

  it "performs a redo action" do
    caretaker.undo
    result = described_class.call(tasks, caretaker, :redo)
    expect(result[:message]).to eq("Redo successful.")
    expect(tasks.first.completed?).to be_truthy
  end
end
