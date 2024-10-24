# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/add_task_service"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Services::AddTaskService do # rubocop:disable Metrics/BlockLength
  let(:tasks) { [] }

  it "adds a new task to the list" do
    result = described_class.call(tasks, "New Task")
    expect(result[:success]).to be_truthy
    expect(tasks.size).to eq(1)
    expect(tasks.first.title).to eq("New Task")
  end

  it "creates a valid memento" do
    result = described_class.call(tasks, "New Task")
    memento = result[:memento]

    expect(memento.action).to eq(:add)
    expect(memento.data[:task].title).to eq("New Task")
  end

  it "reverts the addition of a task" do
    described_class.call(tasks, "Task to Revert")
    memento = KhoinguyenEhTodoList::Memento.new(:add, { index: 0, task: tasks.first })
    described_class.revert(tasks, memento)

    expect(tasks).to be_empty
  end

  it "applies the addition of a task" do
    memento = KhoinguyenEhTodoList::Memento.new(:add,
                                                { index: 0, task: KhoinguyenEhTodoList::Task.new("Task to Apply") })
    described_class.apply(tasks, memento)

    expect(tasks.size).to eq(1)
    expect(tasks.first.title).to eq("Task to Apply")
  end
end
