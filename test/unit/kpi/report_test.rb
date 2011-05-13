require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe "KPI::Report" do
  before do
    class TestKpi < KPI::Report
      def test_kpi
        return KPI::Entry.new "title", 1, :description => "description"
      end

      def another_kpi
        return KPI::Entry.new "another title", 0
      end
    end
    @kpi = TestKpi.new
  end

  after { Object.send(:remove_const, :TestKpi) }

  it "should define indicators" do
    assert_equal [:test_kpi, :another_kpi], TestKpi.defined_kpis
  end
  
  it "should not define indicator from private method" do
    class TestKpi
      private
      def not_kpi
      end
    end
    assert !TestKpi.defined_kpis.include?(:not_kpi)
  end

  describe :collect! do
    it "should collect all KPIs" do
      assert_equal 2, @kpi.collect!.entries.count
    end
  end
  
  describe :defined_kpis do
    it "should return KPIs defined by class" do
      assert_equal TestKpi.defined_kpis, @kpi.defined_kpis
    end
  end

  describe :entries do
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
      assert_equal "TestKpi", @kpi.title
    end
  end
  
  describe :time do
    it "should return overriden time" do
      assert_equal(:time, TestKpi.new(:time => :time).time)
    end
  end
  
  describe :result do
    it "creates KPI::Entry" do
      class TestKpi
        def super_kpi
          result "test", 2, :description => "desc"
        end
      end
      
      @entry = TestKpi.new.super_kpi
      assert_equal("test", @entry.name)
      assert_equal(2, @entry.value)
      assert_equal("desc", @entry.description)
    end
  end
end
