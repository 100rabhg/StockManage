stdout_str = %x( lsof -wni tcp:3000 )
unless stdout_str.empty?
    stdout_str = system( "kill -INT #{stdout_str.lines[1].split(' ')[1]}" )
    puts 'Server Stoped'
end
puts %x( pwd )
unless ARGV.empty?
    puts %x( rails s -e #{ ARGV[0] } #{ (ARGV.count > 1) ? ARGV[1] : '' }  )
else
    puts 'running environment missing'
end