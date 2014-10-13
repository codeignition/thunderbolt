require "thunderbolt/version"
require 'thunderbolt/cli'
require 'thunderbolt/project'
require 'yaml'
require 'colorize'

module Thunderbolt
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Psych::SyntaxError
      p  "error while parsing yaml configuration file. using defaults."; return
    rescue Errno::ENOENT
      p  "yaml configuration file couldn't be found. using defaults."; return
    end
    configure(config)  if config
  end

  def self.projects
    @@projects
  end

  def self.configure(config = {})
    @@projects = config["projects"].map do |project_config|
      project = Project.new
      project.name = project_config["name"]
      project.key = project_config["key"]
      project.github = project_config["github"]
      project
    end
  end

end
