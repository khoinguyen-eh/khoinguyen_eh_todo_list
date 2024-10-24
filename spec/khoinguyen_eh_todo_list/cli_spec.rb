# frozen_string_literal: true

require "spec_helper"
require "khoinguyen_eh_todo_list/cli"

RSpec.describe KhoinguyenEhTodoList::CLI do
  let(:cli) { described_class.new }

  it "adds a task" do
    expect { cli.add("Test Task") }.to change { cli.instance_variable_get(:@tasks).size }.by(1)
  end

  it "toggles task completion" do
    cli.add("Test Task")
    expect { cli.toggle(1) }.to change { cli.instance_variable_get(:@tasks).first.completed? }.to(true)
  end

  it "undoes an action" do
    cli.add("Test Task")
    expect { cli.undo }.to change { cli.instance_variable_get(:@tasks).size }.by(-1)
  end

  it "redoes an undone action" do
    cli.add("Test Task")
    cli.undo
    expect { cli.redo }.to change { cli.instance_variable_get(:@tasks).size }.by(1)
  end
end
