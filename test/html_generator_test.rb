require 'test_helper'
require 'pathname'
require 'tmpdir'

describe "the html generator" do
  before do
    @root = Pathname.new(Dir.mktmpdir)
    @input_file_name  = @root + 'source/input.md'
    @output_file_name = @root + 'destination/input.html'
    Dir.mkdir(@root + 'source')
    @generator = DoubleDoc::HtmlGenerator.new([@input_file_name], { :html_destination => @root + 'destination' })
  end

  after do
    FileUtils.rm_rf(@root)
  end

  describe "#generate" do
    before do
      File.open(@input_file_name, 'w') do |f|
        f.puts "## Hello"
        f.puts "and some text and a link to [the other file](other.md)"
        f.puts "and a link with params [params](params.md?foo=bar)"
        f.puts "and a link with a fragment [params](params.md#foo-bar)"
      end

      @generator.generate
    end

    it "should put an html document in the destination directory" do
      assert File.exist?(@output_file_name)
    end

    it "should convert .md links to .html links" do
      output = File.read(@output_file_name)
      output.must_match(/<a href="other.html">the other file<\/a>/)
      output.must_match(/<a href="params.html\?foo=bar">params<\/a>/)
      output.must_match(/<a href="params.html#foo-bar">params<\/a>/)
    end
  end
end
