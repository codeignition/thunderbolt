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
      launch_term("cd  #{Dir.pwd}/secrets/#{project}/vpn && sudo #{Thunderbolt.config["openvpn_path"]} --config config.ovpn")
    end

    desc "switch" , "switch workspace"
    long_desc " > $ t project switch"
    def switch()
      project = @_invocations.first.last.first
      vpn
      launch_term("cd  #{Dir.pwd}/projects/#{project}/ && bundle exec knife status")
    end
  end

  class CLI < Thor
    include Thunderbolt::Runnable
    def self.exit_on_failure?
      true
    end

    desc "ls" , "list projects"
    long_desc " > $ t projects"
    def ls()
      Thunderbolt.projects.each{|p| puts "#{p.name.colorize(:green)}"}
    end

    Thunderbolt.projects.each do |project|
      desc "#{project.name} SUBCOMMAND ...ARGS", "sub commands in project"
      subcommand project.name, ProjectTasks
    end

    desc "switch" , "switch workspace"
    long_desc " > $ t switch project_name"
    def switch(project)
      fail("invalid project: #{project}".colorize(:red)) unless  Thunderbolt.projects.map(&:name).include? project
      launch_term("cd  #{Dir.pwd}/secrets/#{project}/vpn && sudo #{Thunderbolt.config["openvpn_path"]} --config config.ovpn")
      launch_term("cd  #{Dir.pwd}/projects/#{project}/ && bundle exec knife status")
      run_cmd("open #{Thunderbolt.projects.select{|p| p.name==project}.first.ci}")
    end

    desc "init" , "setup thunderbolt"
    long_desc " > $ t init"
    def init()
      puts "Installing OpenVpn Client".colorize(:blue)
      run_cmd("brew install openvpn")
      update
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
        copy_config project
        bundle project
      end
    end

    no_commands do

      def copy_config project
        run_cmd("cp -r -f secrets/#{project.name}/chef/* #{project.path}/.chef")
        run_cmd("cp -r -f secrets/#{project.name}/ssh/* #{project.path}/.chef/")
      end

      def bundle project
        puts "fetching gems for #{project.name}".colorize(:blue)
        run_cmd("cd  #{project.path} && rbenv rehash && ruby -v && bundle")
      end
    end
    default_task :init
  end
end
