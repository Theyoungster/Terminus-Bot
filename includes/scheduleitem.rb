#
#    Terminus-Bot: An IRC bot to solve all of the problems with IRC bots.
#    Copyright (C) 2010  Terminus-Bot Development Team
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#


class ScheduleItem
  attr_reader :task, :time, :repeat, :name

  # Create an object representing a scheduled task.
  # @param [String] name A user-readable name for the task.
  # @param [Proc] task A Proc object that will be executed when scheduled.
  # @param [Integer] time The time to run the task. If it is a repeated task, it will run at time % epoch == 0. If is not repeated, it will run at this epoch time.
  # @param [Boolean] repeat If true, repeat this task. Otherwise, execute at the given time and then delete.
  def initialize(name, task, time, repeat)
    @name = name
    @task = task
    @time = time
    @repeat = repeat
  end

  # Create a string representing this task.
  # @return [String] name will run [every time seconds / at time (epoch)].
  def to_s
    "\"#{@name}\" will run #{@repeat ? "every #{@time} seconds" : "at #{@time} (epoch)"}."
  end

end