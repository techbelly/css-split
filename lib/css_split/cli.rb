require 'optparse'
require 'ostruct'
require 'stringio'
require 'json'

module CssSplit
  class Cli
    def self.parse_options(program)
      options = OpenStruct.new
      options.output_dir = "css_split.out"
      options.ruleset = File.expand_path("rules.json", File.dirname(__FILE__))
      
      optparse = OptionParser.new do |opts|
        executable = File.basename(program)
        opts.banner = "Usage: #{executable} [options] CSS_FILE..."
        opts.separator ""
        
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("--version", "Show version") do
           puts CssSplit::VERSION
           exit
        end
        
        opts.on("-o", "--output DIR") do |dir|
          options.output_dir = dir
        end
        
        opts.on("-r", "--ruleset FILE") do |r|
          options.ruleset = r
        end
        
      end
      optparse.parse!
      options.css_files = ARGV
      options
    end

    def self.execute(program)
      options = parse_options(program)
            
      app = CssSplit::Application.new(options)
      app.start
    end
  end
end
