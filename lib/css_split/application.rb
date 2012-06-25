require 'css_parser'
require 'pp'
class CssSplit::Application
  def initialize(options)
    css = StringIO.new
    options.css_files.each do |f|
        css << File.new(f).read
        css << "\n"
    end

    @ruleset = CssSplit::Ruleset.new(JSON.parse(File.new(options.ruleset).read))
    @outdir  = options.output_dir
    @parser = CssParser::Parser.new
    @parser.add_block!(css.string, {:media_types => :all, :base_dir => Dir.pwd})
  end

  def start
    media_types = @parser.rules_by_media_query
    split_rules = Hash.new {|a,k| a[k] = Hash.new {|a,b| a[b] = Hash.new {|b,v| b[v] = Array.new }}}
    media_types.each do |media_type,properties|
      properties.each do |property|
        property.create_shorthand!
        selectors = property.selectors.join
        property.each_declaration do |prop,value,important|
          base_file = @ruleset.tag_for_property(prop)
          importance = important ? ' !important' : ''
          split_rules[base_file][media_type][selectors] << "#{prop}: #{value}#{importance}; "
        end
      end
    end
    output split_rules
  end
  
  def output(rules)
    `mkdir -p #{@outdir}`
    rules.each do |file,media_types|
      File.open("#{@outdir}/#{file}.css","w") do |f|
        media_types.each do |media_type,selectors|
          f << "@media #{media_type} {\n" unless media_type == :all
          selectors.each do |selector,properties|
            f << "#{selector} {\n"
            f << properties.join("\n")
            f << "}\n"
          end
          f << "}\n" unless media_type == :all
        end
      end
      `sass-convert #{@outdir}/#{file}.css #{@outdir}/#{file}.scss`
    end
    
  end
end
