require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

describe "KPI::Report::Comparator" do
  before do
    class ComparatorTest < KPI::Report::Comparator
    
    end
  end

  it "should have class Comparator" do
    assert true 
  end

  it "should initialize with array of args" do
    assert !!ComparatorTest.new(1,2,3,4,5)
  end

end
