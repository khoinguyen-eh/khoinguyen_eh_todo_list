# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/caretaker"
require "khoinguyen_eh_todo_list/memento"

RSpec.describe KhoinguyenEhTodoList::Caretaker do
  let(:caretaker) { described_class.new }
  let(:memento) { KhoinguyenEhTodoList::Memento.new(:add, { index: 0, task: "Task 1" }) }

  before do
    caretaker.add_memento(memento)
  end

  it "adds mementos to the undo history" do
    expect(caretaker.undo_history_count).to eq(1)
  end

  it "performs an undo" do
    undone_memento = caretaker.undo
    expect(undone_memento.action).to eq(:add)
    expect(caretaker.undo_history_count).to eq(0)
    expect(caretaker.redo_history_count).to eq(1)
  end

  it "performs a redo" do
    caretaker.undo
    redone_memento = caretaker.redo
    expect(redone_memento.action).to eq(:add)
    expect(caretaker.undo_history_count).to eq(1)
    expect(caretaker.redo_history_count).to eq(0)
  end
end
