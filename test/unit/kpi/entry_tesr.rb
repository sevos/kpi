require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe "KPI::Entry" do
  it "should require exactly 2 arguments" do
    assert_raises(ArgumentError)) { KPI::Entry.new }
    assert_raises(ArgumentError)) { KPI::Entry.new "test" }
    assert_raises(ArgumentError)) { KPI::Entry.new "test", 1, "aaa" }
  end

  describe "when title and value given" do
    before { @entry = KPI::Entry.new "name", "value" }
    
    it "returns name" do
      assert_equal("name", @entry.name)
    end
    
    it "returns value" do
      assert_equal("value", @entry.value)
    end
    
    it "returns nil as description" do
      assert_nil(@entry.description)
    end
    describe "when description given" do
      before { @entry = KPI::Entry.new "name", "value", :description => "desc" }
    
      it "returns description" do
        assert_equal("desc", @entry.description)
      end
    end
    
    describe "when unit given" do
      before { @entry = KPI::Entry.new "Income", 1294.23, :description => "€" }
    
      it "returns description" do
        assert_equal("€", @entry.unit)
      end
    end
  end
end