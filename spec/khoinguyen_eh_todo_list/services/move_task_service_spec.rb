# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/move_task_service"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Services::MoveTaskService do
  let(:tasks) { [KhoinguyenEhTodoList::Task.new("Task 1"), KhoinguyenEhTodoList::Task.new("Task 2")] }

  it "moves a task from one index to another" do
    result = described_class.call(tasks, 1, 2)
    expect(result[:success]).to be_truthy
    expect(tasks[1].title).to eq("Task 1")
  end

  it "creates a valid memento" do
    result = described_class.call(tasks, 1, 2)
    memento = result[:memento]

    expect(memento.action).to eq(:move)
    expect(memento.data[:from]).to eq(0)
    expect(memento.data[:to]).to eq(1)
  end

  it "reverts the move action" do
    memento = KhoinguyenEhTodoList::Memento.new(:move, { from: 0, to: 1 })
    described_class.revert(tasks, memento)

    expect(tasks[0].title).to eq("Task 2")
  end

  it "applies the move action" do
    memento = KhoinguyenEhTodoList::Memento.new(:move, { from: 0, to: 1 })
    described_class.apply(tasks, memento)

    expect(tasks[1].title).to eq("Task 1")
  end
end
