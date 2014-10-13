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
    long_desc " > $ t init"
    def init()
      puts "Installing OpenVpn Client".colorize(:blue)
      run_cmd("brew install openvpn")
      update()
    end

    desc "update" , "update projects"
    long_desc " > $ t update"
    def update()
      Thunderbolt.projects.each do |project|
        if Dir.exist?(project.path)
          puts "Getting latest code for #{project.name}".colorize(:blue)
          run_cmd("cd  #{project.path} && git pull")
        else
          puts "Cloning #{project.name}".colorize(:blue)
          run_cmd("git clone #{project.github} #{project.path}")
        end
      end
    end

    def run_cmd(cmd)
      puts cmd.colorize(:green)
      result = system(cmd)
      (result == false)
    end
  end
end

