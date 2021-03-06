require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + "/../lib/js_fu_matchers")

describe :call_js do
  include JavascriptFu::Matchers
  
  it 'should match script content using a regexp' do
    string = '<script>foo</script>'
    string.should call_js(/fo*/)
    lambda { string.should call_js(/bar/) }.should raise_error("should call js(/bar/), but did not")
    lambda { string.should_not call_js(/foo/) }.should raise_error("should not call js(/foo/), but did")
  end

  describe "with a function name" do
    it 'should match a function call' do
      string = '<script>fname()</script>'
      string.should call_js('fname')
    end
    
    it 'should match a method call' do
      string = '<script>obj.fname()</script>'
      string.should call_js('fname')
      string.should call_js('obj.fname')
    end
    
    it 'should require parentheses' do
      string = '<script>fname</script>'
      string.should_not call_js('fname')
    end
    
    it 'should not match part of a name' do
      string = '<script>fname()</script>'
      string.should_not call_js('fnam')
      string.should_not call_js('name')
    end
    
    it 'should not match outside of a script tag' do
      string = '<script>text</script><p>fname()</p>'
      string.should_not call_js('fname')
    end
  end
  
  describe "with a constructor" do
    it 'should match a constructor with arguments' do
      string = '<script>var obj = new klass()</script>'
      string.should call_js('new klass')
    end
    
    it 'should match a constructor without arguments' do
      string = '<script>var obj = new klass()</script>'
      string.should call_js('new klass')
    end
    
    it 'should not match part of a name' do
      string = '<script>var obj = new klass()</script>'
      string.should_not call_js('new klas')
    end
  end
  
  describe "argument list parsing" do
    it "should match the arguments of a function call" do
      string = '<script>fname("string", 2)</script>'
      string.should call_js('fname') do |args|
        args.should == ['string', 2]
      end
    end
    
    it "should match the arguments of a method call" do
      string = '<script>obj.fname("string", 2)</script>'
      string.should call_js('obj.fname') do |args|
        args.should == ['string', 2]
      end
    end
    
    it "should ignore following material" do
      string = '<script>fname("string", 2);g()</script>'
      string.should call_js('fname') do |args|
        args.should == ['string', 2]
      end
    end
    
    it "should parse nested objects" do
      string = '<script>fname("string", [1,2], {a:3})</script>'
      string.should call_js('fname') do |args|
        args.should == ['string', [1,2], {'a' => 3}]
      end
    end
  end
end
