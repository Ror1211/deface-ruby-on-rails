require 'spec_helper'

module Deface
  module Actions
    describe Replace do
      include_context "mock Rails.application"
      before { Dummy.all.clear }

      describe "with a single replace override defined" do
        before { Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "p", :text => "<h1>Argh!</h1>") }
        let(:source) { "<p>test</p>" }

        it "should return modified source" do
          Dummy.apply(source, {:virtual_path => "posts/index"}).should  == "<h1>Argh!</h1>"
        end
      end

      describe "with a single replace override with closing_selector defined" do
        before { Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :closing_selector => "h2", :text => "<span>Argh!</span>") }
        let(:source) { "<h1>start</h1><p>some junk</p><div>more junk</div><h2>end</h2>" }

        it "should return modified source" do
          Dummy.apply(source, {:virtual_path => "posts/index"}).should == "<span>Argh!</span>"
        end
      end
    end
  end
end
