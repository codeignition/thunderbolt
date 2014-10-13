require "thor"
require 'thunderbolt'

module Thunderbolt
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "projects" , "list projects"
    long_desc " > $ t projects"
    def projects()
      Thunderbolt.projects.each{|p| puts "#{p.name.colorize(:green)}"}
    end

    desc "init" , "setup thunderbolt"
    long_desc " > $ t setup spec_dir"
    def init(spec_dir ='spec')
    end
  end
end

