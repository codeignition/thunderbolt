module Thunderbolt
  module Runnable
      def run_cmd(cmd)
        puts cmd.colorize(:green)
        result = system(cmd)
        (result == false)
      end

      def launch_term(cmd)
        command =  "osascript -e  'activate application \"iTerm\"' -e 'tell application \
          \"System Events\" to keystroke \"t\" using command down' -e 'tell application \
         \"iTerm\" to tell session -1 of current terminal to write text \"#{cmd}\"'"
        run_cmd(command)
      end
  end
end
