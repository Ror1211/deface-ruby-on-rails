require 'spec_helper'

module Deface
  describe Environment do
    include_context "mock Rails.application"

    before(:each) do
      Deface::Override.new(:virtual_path => "posts/index", :name => "Posts#index", :replace => "h1", :text => "<h1>Argh!</h1>")
      Deface::Override.new(:virtual_path => "posts/new", :name => "Posts#new", :replace => "h1", :text => "<h1>argh!</h1>")
    end

    describe ".overrides" do

      it "should return all overrides" do
        Rails.application.config.deface.overrides.all.size.should == 2
        Rails.application.config.deface.overrides.all.should == Deface::Override.all 
      end

      it "should find overrides" do
        Rails.application.config.deface.overrides.find(:virtual_path => "posts/new").size.should == 1
      end
    end

  end
end
