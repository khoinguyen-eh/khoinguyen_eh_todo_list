# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/clear_tasks_service"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Services::ClearTasksService do
  let(:tasks) { [KhoinguyenEhTodoList::Task.new("Task 1"), KhoinguyenEhTodoList::Task.new("Task 2")] }

  it "clears all tasks from the list" do
    result = described_class.call(tasks)
    expect(result[:success]).to be_truthy
    expect(tasks).to be_empty
  end

  it "creates a valid memento" do
    result = described_class.call(tasks)
    memento = result[:memento]

    expect(memento.action).to eq(:clear)
    expect(memento.data[:tasks].size).to eq(2)
  end

  it "reverts the clear action" do
    tasks.clear
    memento = KhoinguyenEhTodoList::Memento.new(:clear, { tasks: [KhoinguyenEhTodoList::Task.new("Task to Revert")] })
    described_class.revert(tasks, memento)

    expect(tasks.size).to eq(1)
    expect(tasks.first.title).to eq("Task to Revert")
  end

  it "applies the clear action" do
    described_class.apply(tasks, nil)
    expect(tasks).to be_empty
  end
end
