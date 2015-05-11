#
# Terminus-Bot: An IRC bot to solve all of the problems with IRC bots.
#
# Copyright (C) 2010-2013 Kyle Johnson <kyle@vacantminded.com>, Alex Iadicicco
# (http://terminus-bot.net/)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

register "Provide on-protocol help for bot scripts and commands."

# "Show help for the given command or a list of all commands. Parameters: [command]"
# "Show a description of the given script or a list of all scripts. Parameters: [script]"

command 'help', 'Show command help. Syntax: help [command]' do
  if @params.empty? 
    list_commands 1
    next
  end
  
  name = @params.shift.downcase

  if Bot::Commands::COMMANDS.has_key? name

    command = Bot::Commands::COMMANDS[name]
    reply command[:help]
  else

    if name.lstrip.to_i < 1
      raise "There is no help available for that command."
    else
      list_commands(name.lstrip.to_i)
    end
  end


end

command 'script', 'Show script info. Syntax: script [name]' do
  if @params.empty?
    list_scripts
    next
  end

  target = @params.shift.downcase

  script = Bot::Scripts.script_info.select do |s|
    s.name.downcase == target
  end.first

  if script.nil?
    raise "There is no information available on that script."
  else
    reply script.description
  end
end


helpers do
  def list_commands page
    if get_config :multi_line, true
      s = Bot::Commands::COMMANDS.keys.sort.join(', ')
      line_length = get_config(:split_length, 400)
      pages = []
      current_page = 0
      last_break = 0
      while last_break < s.length do
        s.length < line_length + last_break ? line_length = s.length - last_break : 
        precut = s[last_break, line_length]
        pagelen = precut.rindex(',')
        pages[current_page] = s[last_break, pagelen - 0]
        last_break = pagelen + last_break + 2
        current_page = current_page + 1
      end
      if page-1 < pages.length
        reply pages[page - 1] + " [#{(page)}/#{pages.length}]"
      else
        raise "Maximum page number is #{pages.length}."
      end
    else
      reply Bot::Commands::COMMANDS.keys.sort.join(', ')
    end
  end

  def list_scripts
    if get_config :multi_line, false
      s = Bot::Scripts.script_info.sort_by {|s| s.name}.map{|s| s.name}.join(', ').chars.to_a
      line_length = get_config(:split_length, 400)
      script_ary = []
      until s.empty?
        script_ary <<  s.shift(line_length).join
      end
      script_ary.each do |script|
        reply script
      end
    else
      reply Bot::Scripts.script_info.sort_by {|s| s.name}.map{|s| s.name}.join(', ')
    end
  end
end

# vim: set tabstop=2 expandtab:
