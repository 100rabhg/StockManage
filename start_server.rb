stdout_str = %x( lsof -wni tcp:3000 )
unless stdout_str.empty?
    stdout_str = system( "kill -INT #{stdout_str.lines[1].split(' ')[1]}" )
    puts 'Server Stoped'
end
puts %x( pwd )
puts %x( rails s -e production -d )