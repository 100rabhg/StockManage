stdout_str = %x( lsof -wni tcp:3000 )
unless stdout_str.empty?
    stdout_str = system( "kill -INT #{stdout_str.lines[1].split(' ')[1]}" )
    puts 'Server Stoped' if stdout_str
end

unless ARGV.empty?
    puts %x( whoami )
    puts %x( cd $HOME/StockManage/current; rails s -e #{ ARGV[0] } -d )
else
    puts 'Running Environment Missing'
end