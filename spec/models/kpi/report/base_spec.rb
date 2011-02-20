require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "KPI::Report::Base" do
  before(:all) do
    class TestKpi < KPI::Report::Base
      def test_kpi
        return ["title", 1, "description"]
      end

      def another_kpi
        return ["another title", 0]
      end
    end
  end

  it "should define indicators" do
    TestKpi.defined_kpis.should == [:test_kpi, :another_kpi]
  end

  describe :collect! do
    before { @kpi = TestKpi.new }
    it "should call all KPIs" do
      TestKpi.defined_kpis.each do |kpi_method|
        @kpi.should_receive(kpi_method)
      end
      @kpi.collect!
    end
  end

  describe :entries do
    before { @kpi = TestKpi.new }

    it "should return enumerator" do
      @kpi.entries.should be_kind_of(Enumerable)
    end

    it "should return enumerator with entries" do
      @kpi.entries.first.should be_kind_of(KPI::Entry)
    end

    it "should fill entries with names" do
      @kpi.entries.map(&:name).should == ["title", "another title"]
    end

    it "should fill entries with values" do
      @kpi.entries.map(&:value).should == [1, 0]
    end

    it "should fill entries with descriptions" do
      @kpi.entries.map(&:description).should == ["description", nil]
    end
  end

  describe :title do
    it "should return class name by default" do
      TestKpi.new.title.should == "TestKpi"
    end
  end
end