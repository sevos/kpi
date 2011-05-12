require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class TestKpi < KPI::Report::Base
  def test_kpi
    return ["title", 1, "description"]
  end

  def another_kpi
    return ["another title", 0]
  end
end

describe "KPI::Report::Base" do
  it "should define indicators" do
    assert_equal [:test_kpi, :another_kpi], TestKpi.defined_kpis
  end

  describe :collect! do
    before { @kpi = TestKpi.new }
    it "should collect all KPIs" do
      assert_equal 2, @kpi.collect!.entries.count
    end
  end

  describe :entries do
    before { @kpi = TestKpi.new }

    it "should return enumerator" do
      assert @kpi.entries.kind_of?(Enumerable)
    end

    it "should return enumerator with entries" do
      assert @kpi.entries.first.kind_of?(KPI::Entry)
    end

    it "should fill entries with names" do
      assert_equal ["title", "another title"], @kpi.entries.map(&:name)
    end

    it "should fill entries with values" do
      assert_equal [1, 0], @kpi.entries.map(&:value)
    end

    it "should fill entries with descriptions" do
      assert_equal ["description", nil], @kpi.entries.map(&:description)
    end
  end

  describe :title do
    it "should return class name by default" do
      assert_equal "TestKpi", TestKpi.new.title
    end
  end
end