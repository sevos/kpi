module ExtractOptions
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
end

Array.send(:include, ExtractOptions)