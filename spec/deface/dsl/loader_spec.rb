require 'spec_helper'

require 'deface/dsl/loader'

describe Deface::DSL::Loader do
  context '.load' do
    it 'should create a Deface::DSL::Context and ask it to create a Deface::Override' do
      file = mock('deface file')
      filename = 'example_name.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = mock('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = mock('file contents')
      file.should_receive(:read).and_return(file_contents)

      context.should_receive(:instance_eval).with(file_contents)
      context.should_receive(:create_override)

      Deface::DSL::Loader.load(filename)
    end
  end

  context '.register' do
    it 'should register the deface extension with the polyglot library' do
      Polyglot.should_receive(:register).with('deface', Deface::DSL::Loader)

      Deface::DSL::Loader.register
    end
  end
end