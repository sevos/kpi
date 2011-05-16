require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe "KPI::MergedReport" do
  
  before do
    class TestKpi < KPI::Report
      def initialize return_value = 1
        super()
        @return = return_value
      end

      def test_kpi
        result "title", @return, :description => "description"
      end

      def test_kpi_2
        result "title 2 ", @return*2, :unit => 'EUR'
      end
    end
    class AnotherReport < KPI::Report
      def test_kpi
        result "title", 3, :description => "description"
      end

      def another_kpi
        result "another", 5
      end
    end
  end

  after do
    Object.send(:remove_const, :TestKpi)
    Object.send(:remove_const, :AnotherReport)
  end

  describe "when initializing" do
    it "should initialize with list of KPI::Report::Base objects and block" do
      KPI::MergedReport.new(TestKpi.new) {}
      KPI::MergedReport.new(TestKpi.new, TestKpi.new) {}
      KPI::MergedReport.new(TestKpi.new,TestKpi.new, TestKpi.new) {}
    end

    it "should require at least one element when initializing" do
      assert_raises(ArgumentError) do
        KPI::MergedReport.new() {}
      end
    end

    it "should allow objects of the same type when initializing" do
      KPI::MergedReport.new(TestKpi.new, AnotherReport.new) {}
    end

    it "should require block when initializing" do
      assert_raises(Exception) do
        KPI::MergedReport.new(TestKpi.new)
      end
    end
  end

  describe "when two identical reports given for average" do
    before do
      @report1 = TestKpi.new(2)
      @report2 = TestKpi.new(8)

      @average = KPI::MergedReport.new(@report1, @report2) do |*entries|
        average = entries.map(&:value).sum / entries.size
        KPI::Entry.new "Average $$", average, :description => "$$ (average)"
      end
    end

    it "should calculate value using block given in initializer when asking for KPI" do
      assert_equal 5, @average.test_kpi.value
    end

    it "should change $$ in title to indicator title" do
      assert_equal "Average title", @average.test_kpi.name
    end

    it "should change $$ in description to indicator descripiton" do
      assert_equal "description (average)", @average.test_kpi.description
    end
    
    it "should have unit" do
      assert_equal "EUR", @average.test_kpi_2.unit
    end
    
    it "should allow to override unit" do
      @merged = KPI::MergedReport.new(@report1, @report2) do |*entries|
        KPI::Entry.new "merged $$", 1, :unit => "$"
      end
      assert_equal '$', @merged.test_kpi.unit
      assert_equal '$', @merged.test_kpi_2.unit
    end

    it "should return nil description when no description" do
      assert_nil @average.test_kpi_2.description
    end

    describe "entries" do
      it "should return enumerator with entries" do
        assert_kind_of Enumerable, @average.entries
      end

      it "should pack average entries to enumerator" do
        assert @average.entries.all? { |e| e.instance_of?(KPI::Entry) }
      end

      it "should have each average entry for each indicator" do
        assert_equal TestKpi.defined_kpis.size, @average.entries.to_a.size
      end

      it "should calculate averages for each indicator" do
        assert_equal [5,10], @average.entries.map(&:value)
      end
    end
    
    describe :defined_kpis do
      it "should return KPIs defined by all compounds" do
        assert_equal TestKpi.defined_kpis, @average.defined_kpis
      end
    end
  end

  describe "when different reports given for merge" do
    before do
      @report1 = TestKpi.new(2)
      @report2 = AnotherReport.new
    end

    describe "when intersection" do
      before do
        @merge = KPI::MergedReport.new(@report1, @report2) do |test, another|
          KPI::Entry.new "$$", {:test => test, :another => another}, :description => '$$'
        end
      end

      it "should have only common KPI defined" do
        assert_equal [:test_kpi], @merge.defined_kpis
      end

      it "should not repospond for not common KPI" do
        assert_raises(NoMethodError) { @merge.another_kpi }
      end

      it "should return values for common KPI" do
        assert_instance_of Hash, @merge.test_kpi.value
      end
    end
    
    describe "when conjunction" do
      before do
        @merge = KPI::MergedReport.new(@report1, @report2, :mode => :|) do |test, another|
          merge = {:test => test.try(:value), :another => another.try(:value)}
          KPI::Entry.new "$$", merge, :description => '$$'
        end
      end
    
      it "should have all KPI of both reports" do
        assert_equal [:test_kpi, :test_kpi_2, :another_kpi], @merge.defined_kpis
      end
    
      it "should return KPI" do
        assert_equal({:test => nil, :another => 5}, @merge.another_kpi.value)
      end
    end
  end
end
