module Thunderbolt
  module Runnable
      def run_cmd(cmd)
        puts cmd.colorize(:green)
        result = system(cmd)
        (result == false)
      end
  end
end
