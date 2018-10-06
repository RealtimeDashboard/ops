require_relative 'log'

class Cmn
  def self.cmd(cmd)
    Log.logger.info("Running : #{cmd}")
    value = `#{cmd}`
  end

  def self.user_input(msg)
    print "#{msg} : "
    gets.chomp
  end

  def self.script_path(level=0)
    File.join(File.dirname(__FILE__), "../"*level)
  end
end
