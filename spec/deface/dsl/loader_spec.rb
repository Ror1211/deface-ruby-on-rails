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

    it 'should create a Deface::DSL::Context from a .html.erb.deface file' do
      file = mock('html/erb/deface file')
      filename = 'example_name.html.erb.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = mock('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = mock('file contents')
      file.should_receive(:read).and_return(file_contents)

      Deface::DSL::Loader.should_receive(:extract_dsl_commands).
        with(file_contents).
        and_return(['dsl commands', 'text'])

      context.should_receive(:instance_eval).with('dsl commands')
      context.should_receive(:text).with('text')
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

  context '.extract_dsl_commands' do
    it 'should work in the simplest case' do
      example = "<!-- test 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands(example)
      dsl_commands.should == "test 'command'\n"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should combine multiple comments' do
      example = "<!-- test 'command' --><!-- another 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands(example)
      dsl_commands.should == "test 'command'\nanother 'command'\n"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should leave internal comments alone' do
      example = "<br/><!-- test 'command' --><!-- another 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands(example)
      dsl_commands.should == ""
      the_rest.should == example
    end

    it 'should work with comments on own lines' do
      example = "<!-- test 'command' -->\n<!-- another 'command' -->\n<h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands(example)
      dsl_commands.should == "test 'command'\nanother 'command'\n"
      the_rest.should == "\n<h1>Wow!</h1>"
    end

    it 'should work with newlines inside the comment' do
      example = "<!--\n test 'command'\nanother 'command'\n -->\n<h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands(example)
      dsl_commands.should == "test 'command'\nanother 'command'\n"
      the_rest.should == "\n<h1>Wow!</h1>"
    end
  end
end