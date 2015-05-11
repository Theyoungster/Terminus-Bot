
register 'Remember and recall moves.'

command 'learn', 'Remember a move. Example: Fire Breath me spits fire# at @#!' do
  level! 5
  argc! 1
  
  args = @params.first.partition(/\sme\s/)
  unless args[1].length == 4
    raise "Move must be learned with format learn [name] me [action]."
  end

  store_data(args[0].downcase, get_data(args[0].downcase, Array.new).insert(0, args[2]))

  if get_data(args[0].downcase, Array.new)[1] != nil
    send_action @msg.destination, "learned a variation of #{args[0]}!"
  else
    send_action @msg.destination, "learned #{args[0]}!"
  end

end

command 'unlearn', 'Forget a move.' do
  level! 5
  argc! 1

  key = @params.first.downcase

  if get_data(key) == nil
    raise "No such move."
  end

  delete_data key
  send_action @msg.destination, "forgot #{key}!"

end

command 'use', 'Use a move.' do
  argc! 1
  
  key = @params.first.partition(/\son\s/)
  keya = key[0].downcase.match(/[a-z\s]*/)
  keyb = key[2].match(/[a-zA-Z\s]+/)
  
  factoid = get_data keya[0]

  if factoid == nil
    raise "I don't know that move... (#{keya[0]})"
  end

  thismove = factoid[rand(factoid.size)-1]

  if thismove.match(/\#.*\@.*\#/) != nil && keyb != nil
    send_action @msg.destination, "#{thismove.sub(/\#(.*)\#/, '\1').sub(/\@/, keyb[0])}"
  else
    send_action @msg.destination, "#{thismove.sub(/\#.*\#/, '')}"
  end

end


# vim: set tabstop=2 expandtab:
