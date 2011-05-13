require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe "KPI::Report::Comparator" do
  before do
    class ComparatorTest < KPI::Report::Comparator
    
    end
  end

  it "should have class Comparator" do
    assert true 
  end

end
