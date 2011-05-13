require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe "KPI::Report::Comparator" do
  
  before do
    class TestKpi < KPI::Report::Base
      def initialize return_value = 1
        super()
        @return = return_value
      end

      def test_kpi
        return ["title", @return, "description"]
      end

      def test_kpi_2
        return ["title 2 ", @return*2]
      end
    end
    class AnotherReport < KPI::Report::Base
    end
  end

  after do
    Object.send(:remove_const, :TestKpi)
    Object.send(:remove_const, :AnotherReport)
  end

  describe "when initializing" do
    it "should initialize with list of KPI::Report::Base objects and block" do
      KPI::Report::Comparator.new(TestKpi.new) {}
      KPI::Report::Comparator.new(TestKpi.new,TestKpi.new) {}
      KPI::Report::Comparator.new(TestKpi.new,TestKpi.new,TestKpi.new) {}
    end

    it "should require at least one element when initializing" do
      assert_raises(ArgumentError) do
        KPI::Report::Comparator.new() {}
      end
    end

    it "should require objects of the same type when initializing" do
      assert_raises(ArgumentError) do
        KPI::Report::Comparator.new(TestKpi.new,AnotherReport.new) {}
      end
    end

    it "should require block when initializing" do
      assert_raises(Exception) do
        KPI::Report::Comparator.new(TestKpi.new)
      end
    end
  end

  describe "when two reports given for average" do
    before do
      report1 = TestKpi.new(2)
      report2 = TestKpi.new(8)

      @average = KPI::Report::Comparator.new(report1, report2) do |*entries|
        average = entries.map{|e| KPI::Entry.new(*e).value }.sum / entries.size
        ["Average $$", average, "$$ (average)"]
      end
    end

    it "should calculate value using block given in initializer when asking for KPI" do
      assert_equal 5, @average.test_kpi[1]
    end

    it "should change $$ in title to indicator title" do
      assert_equal "Average title", @average.test_kpi[0]
    end

    it "should change $$ in description to indicator descripiton" do
      assert_equal "description (average)", @average.test_kpi[2]
    end

    it "should return nil description when no description" do
      assert_nil @average.test_kpi_2[2]
    end

    describe "entries" do
      it "should return enumerator with entries" do
        assert_kind_of Enumerable, @average.entries
      end

      it "should pack average entries to enumerator" do
        assert @average.entries.all? { |e| e.instance_of?(KPI::Entry) }
      end

      it "should have each average entry for each indicator" do
        assert_equal TestKpi.defined_kpis.size, @average.entries.size
      end

      it "should calculate averages for each indicator" do
        assert_equal [5,10], @average.entries.map(&:value)
      end
    end
  end
end
