# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/services/toggle_completion_service"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Services::ToggleCompletionService do
  let(:tasks) { [KhoinguyenEhTodoList::Task.new("Task 1")] }

  it "toggles task completion" do
    result = described_class.call(tasks, 1)
    expect(result[:success]).to be_truthy
    expect(tasks.first.completed?).to be_truthy
  end

  it "creates a valid memento" do
    result = described_class.call(tasks, 1)
    memento = result[:memento]

    expect(memento.action).to eq(:toggle)
    expect(memento.data[:index]).to eq(0)
  end

  it "reverts the toggle action" do
    tasks.first.toggle_completion
    memento = KhoinguyenEhTodoList::Memento.new(:toggle, { index: 0 })
    described_class.revert(tasks, memento)

    expect(tasks.first.completed?).to be_falsey
  end

  it "applies the toggle action" do
    memento = KhoinguyenEhTodoList::Memento.new(:toggle, { index: 0 })
    described_class.apply(tasks, memento)

    expect(tasks.first.completed?).to be_truthy
  end
end
