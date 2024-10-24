# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/task"

RSpec.describe KhoinguyenEhTodoList::Task do
  let(:task) { described_class.new("Write blog post") }

  it "initializes with a title" do
    expect(task.title).to eq("Write blog post")
  end

  it "is incomplete by default" do
    expect(task.completed?).to be_falsey
  end

  it "can toggle completion" do
    task.toggle_completion
    expect(task.completed?).to be_truthy

    task.toggle_completion
    expect(task.completed?).to be_falsey
  end

  it "returns the correct string representation" do
    expect(task.to_s).to eq("[ ] Write blog post")
    task.toggle_completion
    expect(task.to_s).to eq("[X] Write blog post")
  end
end
