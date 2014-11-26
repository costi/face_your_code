require 'date'
class ImageFilename
  
  include Comparable
  def <=>(other)
    self.datetime <=> other.datetime
  end

  def self.time_separator
    raise 'reimplement time_separator in child classes'
  end

  attr_reader :datetime, :filename

  def initialize(some_filename, mtime = nil)
    @filename = some_filename
    if mtime
      @datetime = DateTime.new(mtime.year, mtime.month, mtime.day, mtime.hour, mtime.min, mtime.sec, Rational(mtime.utc_offset, 60*60*24))
    else
      @datetime = parse_filename
    end
  end

  def inspect
    sprintf("%30s -> %30s", @filename, datetime)
  end

  private
  def parse_filename
    @date, @hour = @filename.sub('.jpg', '').split(self.class.time_separator)
    @hour.gsub!('-', ':')
    DateTime.parse([@date, @hour].join('T'))
  end



end

class Screenshot < ImageFilename
  def self.time_separator
    '-shot-'
  end
end

class Faceshot < ImageFilename
  def self.time_separator
    '-snap-'
  end
end

class ImageSet
  include Enumerable

  def each 
    @images.each { |image| yield image }

  end

  def initialize(array)
    @images = array.sort
  end

  def nearest_in_time(image)
    best_candidate = @images.first
    @images.each do |new_candidate|
      if (best_candidate.datetime - image.datetime).abs  >= (new_candidate.datetime - image.datetime).abs
        best_candidate = new_candidate
      else
        break #array is sorted so it's not gonna get any better
      end
    end
    best_candidate
  end

  def nearest_in_time_bsearch(image, start_index = 0, end_index = @images.length-1)
    if end_index - start_index <= 1
      right = (@images[end_index].datetime - image.datetime).abs
      left = (@images[start_index].datetime - image.datetime).abs
      return left <= right ? @images[start_index] : @images[end_index]
    end
    mid = (end_index + start_index) / 2
    image.datetime < @images[mid].datetime ? nearest_in_time_bsearch(image, start_index, mid) : nearest_in_time_bsearch(image, mid, end_index)

  end

  def <<(new_one)
    @images << new_one
  end

  def inspect
    @images.map{|i| i.inspect}.join("\n")
  end

end
