# classes and methods for mta.rb

# Create a new Subway_Line instance
class Subway_Line
    attr_accessor :status, :stations

    def initialize(line_name, stations=[], status="On Time")
        @line_name = line_name
        @stations = stations
        @transfer_stations = {}
        @status = status
    end

    def transfer_station=(line,station)
        if @transfer_stations.has_key? line
            @transfer_stations.values_at(line.to_sym).push(station)
        else
            @transfer_stations[line.to_sym] = [station]
        end
    end
end

#create a new MTA instance
class MTA

    # initialize instance
    def initialize(lines={})
        @lines = lines
    end

    # print each line name to console
    def lines
        @lines.keys.each { |line| puts line }
    end
    
    def stops(line_name)
        @lines[line_name.to_sym].stations
    end

    def add_line(line_name, stops)
        new_line = Subway_Line.new(line_name, stops)
        @lines[line_name.to_sym] = new_line
        @lines.keys.each { |key|
            get_shared_stops(key, @lines[line_name.to_sym]).each { |stop|
                @lines[key.to_sym].transfer_stations(line_name.to_sym, stop)
                @lines[line_name.to_sym].transfer_stations(key.to_sym, stop)
            }
        }
    end

    def calculate(start_line, start_point, end_line, end_point)
        if !@lines[start_line.to_sym].include? start_point
            puts "Invalid stop given, #{start_line} doesn't go to #{start_point}"
           return 
        end

        if !line_has_stop(end_line, end_point)
            puts "Invalid stop given, #{end_line} doesn't go to #{end_point}"
           return 
        end

        if start_line != end_line
            transfer_points = get_shared_stops(start_line, end_line)
            shortest_route = 0
            transfer_points.each { |point|
                current_count = 0;
                current_count += count_stops(@lines[start_line.to_sym].stations, start_point, point)
                current_count += count_stops(@lines[end_line.to_sym].stations, point, end_point) 
                if shortest_route == 0 || shortest_route > current_count
                    shortest_route = current_count
                end
            }
            puts shortest_route
        else
            puts count_stops(@lines[start_line.to_sym].stations, start_point, end_point)
        end
    end

    private 

    def line_has_stop(line, stop)
        return @lines[line.to_sym].include? stop
    end

    def get_shared_stops(line_one, line_two)
        shared_stops = []
        first_line = stops(line_one)
        second_line = stops(line_two)
        first_line.each { |stop| 
            if second_line.include? stop 
                shared_stops.push(stop)
            end
        }
        shared_stops
    end

    def count_stops(stations, start_point, end_point)
        (stations.find_index(end_point) - stations.find_index(start_point)).abs
    end
end



