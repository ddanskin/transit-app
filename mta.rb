# process commands 
require_relative 'structure.rb'

my_mta = MTA.new
my_mta.add_line('L', ['8th','6th','Union Square','3rd','1st'])
my_mta.add_line('N', ['Times Square','34th','28th','23rd','Union Square','8th'])
my_mta.add_line('6', ['Grand Central','33rd','28th','23rd','Union Square','Astor Place'])

def error_message(method_called)
    if method_called == "lines"
       "This method cannot be called with arguments"
    elsif method_called == "stops"
        "You must provide 1 argument with this method: name of subway line"
    elsif method_called == "calculate"
        "You must provide 4 arguments with this method: starting subway line, starting station, ending subway line, ending station"
    else
        "You've provided an invalid method, methods available: lines, stops, or calculate"
    end
end

case ARGV.length
    when 0
        puts 'You must provide a method name'
    when 1
        if ARGV[0] == 'lines'
            my_mta.lines
        else
            error_message(ARGV[0])          
        end
    when 2
        if ARGV[0] == 'stops'
            my_mta.stops(ARGV[1])
        else 
            error_message(ARGV[0])
        end
    when 5
        if ARGV[0] == 'calculate'
            start_point = ARGV[2].dup
            end_point = ARGV[4].dup
            
            if ARGV[2].include? '_'
                start_point = start_point.gsub!("_"," ")
            end

            if ARGV[4].include? '_'
                end_point = end_point.gsub!("_"," ")
            end

            my_mta.calculate(ARGV[1],start_point,ARGV[3],end_point)
        else
            error_message(ARGV[0])
        end
    else
        error_message(ARGV[0])
end

