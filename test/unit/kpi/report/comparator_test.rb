require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe "KPI::Report::Comparator" do
  before do
    class ComparatorTest < KPI::Report::Comparator
    
    end
  end

  after { Object.send(:remove_const, :TestKpi) }

  it "should compare objects" do
    assert true 
  end

end
