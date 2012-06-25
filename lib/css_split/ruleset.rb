class CssSplit::Ruleset
  def initialize(ruleset)
    @directives = Hash.new {|h,k| h[k] = Array.new}
    ruleset.each do |file,properties|
      properties.each do |prop|
        @directives[prop.dup] << file.dup
      end
    end
  end
  
  def tag_for_property(directive)
    @directives[directive].first || "styles"
  end
end