# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/memento"

RSpec.describe KhoinguyenEhTodoList::Memento do
  let(:state) { [KhoinguyenEhTodoList::Task.new("Test task")] }
  let(:memento) { described_class.new(:add, { index: 0, task: state.first }) }

  it "initializes with the correct action and data" do
    expect(memento.action).to eq(:add)
    expect(memento.data[:index]).to eq(0)
  end

  it "can serialize and deserialize correctly" do
    allow(YAML).to receive(:safe_load).and_return({ action: :add, data: { index: 0, task: state.first } })
    loaded_memento = described_class.from_yaml(memento.to_yaml)

    expect(loaded_memento.action).to eq(:add)
    expect(loaded_memento.data[:index]).to eq(0)
  end
end
