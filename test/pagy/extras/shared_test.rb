# encoding: utf-8
# frozen_string_literal: true

if ENV['ENABLE_OJ']

  require_relative '../../test_helper'
  require 'oj' # all the other tests run without Oj
  require 'pagy/extras/shared'

  SimpleCov.command_name 'shared' if ENV['RUN_SIMPLECOV']

  # add tests for oj and pagy_id
  describe Pagy::Frontend do

    let(:frontend) { TestSimpleView.new }

    describe "#pagy_json_tag" do

      it 'should use oj' do
        frontend.pagy_json_tag(:test_function, 'some-id', 'some-string', 123, true).must_equal \
          "<script type=\"application/json\" class=\"pagy-json\">[\"test_function\",\"some-id\",\"some-string\",123,true]</script>"
      end

    end


    describe "#pagy_id" do

      it 'should return different SHA1 ids' do
        id1 = call_pagy_id
        id2 = call_pagy_id
        id1.must_be_kind_of String
        id2.must_be_kind_of String
        id1.must_be :!=, id2
      end

    end

    describe "#pagy_marked_link" do

      it 'should return only the "standard" link' do
        pagy = Pagy.new(count: 100, page: 4)
        frontend.instance_eval do
          pagy_marked_link(pagy_link_proc(pagy)).must_equal("<a href=\"/foo?page=__pagy_page__\"   style=\"display: none;\"></a>")
        end
        pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
        frontend.instance_eval do
          pagy_marked_link(pagy_link_proc(pagy)).must_equal("<a href=\"/foo?p=__pagy_page__\"   style=\"display: none;\"></a>")
        end
      end

    end

    # we need an intermediate call to get the right caller
    def call_pagy_id
      frontend.pagy_id
    end

  end

end
