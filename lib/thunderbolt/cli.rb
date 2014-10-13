require "thor"
require 'thunderbolt'

module Thunderbolt
  class ProjectTasks < Thor
    include Thunderbolt::Runnable
    namespace "{project_name}"
    desc "vpn" , "launch vpn"
    long_desc " > $ t project vpn"
    def vpn()
      project = @_invocations.first.last.first
      run_cmd("cd  secrets/#{project}/vpn && #{Thunderbolt.config["openvpn_path"]} --config config.ovpn")
    end
  end
  class CLI < Thor
    include Thunderbolt::Runnable
    def self.exit_on_failure?
      true
    end

    desc "projects" , "list projects"
    long_desc " > $ t projects"
    def projects()
      Thunderbolt.projects.each{|p| puts "#{p.name.colorize(:green)}"}
    end

    Thunderbolt.projects.each do |project|
      desc "#{project.name} SUBCOMMAND ...ARGS", "sub commands in project"
      subcommand project.name, ProjectTasks
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
        bundle project
      end
    end

    no_commands do
      def bundle project
        puts "fetching gems for #{project.name}".colorize(:blue)
        run_cmd("cd  #{project.path} && source ~/.bash_profile && rbenv shell `cat .ruby-version` && ruby -v && bundle")
      end
    end
  end
end
