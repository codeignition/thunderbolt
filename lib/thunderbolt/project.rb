require 'thunderbolt'

module Thunderbolt
  class Project
    attr_accessor :name,:key,:github

    def path
      "projects/#{name}"
    end
  end
end

