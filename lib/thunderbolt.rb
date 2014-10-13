require "thunderbolt/version"
require 'thunderbolt/project'
require 'thunderbolt/runnable'
require 'yaml'
require 'colorize'

module Thunderbolt
  def self.configure_with(path_to_yaml_file)
    begin
      @@config = YAML::load(IO.read("#{path_to_yaml_file}/settings.yml"))
      project_config = YAML::load(IO.read("#{path_to_yaml_file}/projects.yml"))
      set_projects(project_config)  if project_config
    rescue Psych::SyntaxError
      p  "error while parsing yaml configuration file. using defaults."; return
    rescue Errno::ENOENT
      p  "yaml configuration file couldn't be found"
    end
  end

  def self.config
    @@config
  end

  def self.projects
    @@projects
  end

  def self.set_projects(config = {})
    @@projects = config["projects"].map do |project_config|
      project = Project.new
      project.name = project_config["name"]
      project.key = project_config["key"]
      project.github = project_config["github"]
      project
    end
  end
end
