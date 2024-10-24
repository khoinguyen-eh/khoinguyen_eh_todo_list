# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/remove_task_service"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Services::RemoveTaskService do
  let(:tasks) { [KhoinguyenEhTodoList::Task.new("Task 1")] }

  it "removes a task from the list" do
    result = described_class.call(tasks, 1)
    expect(result[:success]).to be_truthy
    expect(tasks).to be_empty
  end

  it "creates a valid memento" do
    result = described_class.call(tasks, 1)
    memento = result[:memento]

    expect(memento.action).to eq(:remove)
    expect(memento.data[:task].title).to eq("Task 1")
  end

  it "reverts the removal of a task" do
    memento = KhoinguyenEhTodoList::Memento.new(:remove,
                                                { index: 0, task: KhoinguyenEhTodoList::Task.new("Task to Revert") })
    described_class.revert(tasks, memento)

    expect(tasks.size).to eq(2)
    expect(tasks.first.title).to eq("Task to Revert")
  end

  it "applies the removal of a task" do
    memento = KhoinguyenEhTodoList::Memento.new(:remove, { index: 0, task: tasks.first })
    described_class.apply(tasks, memento)

    puts tasks

    expect(tasks).to be_empty
  end
end
