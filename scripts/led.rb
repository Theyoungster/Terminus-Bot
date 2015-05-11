require 'pi_piper'

register 'Control the RGB LED. Ask Emblem for pics.'

$numbers = {
  '000' => [false, false, false, 'black'],
  '100' => [true, false, false, 'red'],
  '010' => [false, true, false, 'green'],
  '110' => [true, true, false, 'yellow'],
  '001' => [false, false, true, 'blue'],
  '101' => [true, false, true, 'magenta'],
  '011' => [false, true, true, 'cyan'],
  '111' => [true, true, true, 'white']
}

$colors = {
  'black' => [false, false, false, '000'],
  'red' => [true, false, false, '100'],
  'green' => [false, true, false, '010'],
  'yellow' => [true, true, false, '110'],
  'blue' => [false, false, true, '001'],
  'magenta' => [true, false, true, '101'],
  'cyan' => [false, true, true, '011'],
  'white' => [true, true, true, '111']
}

=begin

initval = get_data "global", "000"
$log.debug(initval)
if ($numbers.has_key? initval == false) 
  initval = "000"
$log.debug(initval)
end

for i in 0..2 do
  pin = PiPiper::Pin.new(:pin => (22 + i), :direction => :out)
  $numbers[initval][i] == true ? pin.on : pin.off
end

=end

command 'led', 'Control the RGB LED. Ask Emblem for pics. Parameters: SET rgb|XOR rgb|GET' do
  argc! 1
  myargs = @params[0].downcase.split(/\s/)
  if myargs[0].eql?("set")
    secondarg = myargs[1]
    if $colors.has_key? secondarg
      prev = getrgb
      setrgb $colors[secondarg][3]
      reply "Changed led color from #{$numbers[prev][3]} to #{$numbers[getrgb][3]}."
    elsif $numbers.has_key? secondarg
      prev = getrgb
      setrgb secondarg
      reply "Changed led color from #{$numbers[prev][3]} to #{$numbers[getrgb][3]}."
    else
      reply "Unknown format. Use a color or color code (e.g. 'red' or '100', 'green' or '010')"
    end

#I'll be shocked if anyone makes it this far without cringing.

  elsif (myargs[0].eql?("xor"))

    secondarg = myargs[1]
    if $colors.has_key? secondarg
      prev = getrgb
      ledstr = ''
      for i in 0..2 do
        $numbers[prev][i] != $colors[secondarg][i] ? ledstr = ledstr + '1' : ledstr = ledstr + '0'
      end
      setrgb ledstr
      reply "Changed led color from #{$numbers[prev][3]} to #{$numbers[getrgb][3]}."
    elsif $numbers.has_key? secondarg
      prev = getrgb
      ledstr = ''
      for i in 0..2 do
        $numbers[prev][i] != $numbers[secondarg][i] ? ledstr = ledstr + '1' : ledstr = ledstr + '0'
      end
      setrgb ledstr
      reply "Changed led color from #{$numbers[prev][3]} to #{$numbers[getrgb][3]}."
    else
      reply "Unknown format. Use a color or color code (e.g. 'red' or '100', 'green' or '010')"
    end

  elsif (myargs[0].eql?("get"))
    reply "The led is currently #{$numbers[getrgb][3]}."
  else
    reply "Parameters: SET rgb|XOR rgb|GET"
  end

end

helpers do

  def getrgb
    get_data "global", "000" 
  end

  def setrgb val
    store_data "global", val
    for i in 0..2 do
      pin = PiPiper::Pin.new(:pin => (22 + i), :direction => :out)
      $numbers[val][i] == true ? pin.on : pin.off
    end
  end
  
end

  