require 'csv'

class SLCSP

  def initialize
    @zips = CSV.read('./slcsp/zips.csv', headers: true)
    @slcsp = CSV.read('./slcsp/slcsp.csv', headers: true)
    @plans = CSV.read('./slcsp/plans.csv', headers: true)

    puts "#{@slcsp.headers[0]},#{@slcsp.headers[1]}"
    process_data
  end

  # iterate over each row, append slcsp to the row
  # and print it to stdout
  def process_data
    @slcsp.each do |line|
      if rate_area_count(line[0]) == 1
        rate_area = rate_areas(line[0])
        cost = get_slc(rate_area[0][1], rate_area[0][4])
        line[1] = format_cost(cost) unless cost.nil?
      end
      puts line
    end
  end

  # take a zip code and return a list of
  # matching records from zips.csv
  def get_zip_matches(zip)
    matches = @zips.select { |z| z[0] == zip }
  end

  # take a zip code and return the count of
  # unique records in zips.csv
  def rate_area_count(zip)
    matches = get_zip_matches(zip)
    count = matches.uniq { |z| z.values_at(1,4)}.count
  end

  # take a zip code and return a lit of unique
  # rate areas for that zip code
  def rate_areas(zip)
    matches = get_zip_matches(zip)
    rate_areas = matches.uniq { |z| z.values_at(1,4)}
  end

  # take a state and rate area and return the slcsp
  def get_slc(state, rate_area, metal='Silver')
    matches = @plans.select { |p| p[1] == state && p[4] == rate_area && p[2] == metal }
    costs = matches.uniq { |m| m[3] }.map { |u| u[3].to_f }
    costs.sort[1]
  end

  def format_cost(cost)
    '%.2f' % cost
  end

end

SLCSP.new