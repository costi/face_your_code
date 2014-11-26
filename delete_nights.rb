#!/usr/bin/env ruby


unless ARGV.length == 2
  puts "usage: delete_nights <screenshots_dir> <faces_dir>"
  exit
end

require_relative 'image_filename'

screen_dir = ARGV[0]
faces_dir = ARGV[1]

# shot example: 2011-03-03-snap-09-46-39.jpg
Dir.chdir(screen_dir) do
  @screenshots = ImageSet.new(Dir.glob("*.jpg").map{|s| 
    file = Screenshot.new(s, File.mtime(s))
    if (0..7).include?(file.datetime.hour) || (20..23).include?(file.datetime.hour)
      File.delete(s)
    end
  })
end

# faces example: 2011-03-03-snap-09-47-19.jpg 
Dir.chdir(faces_dir) do
  @faces = ImageSet.new(Dir.glob("*.jpg").map{|f| 
    file = Faceshot.new(f, File.mtime(f))
    if (0..7).include?(file.datetime.hour) || (20..23).include?(file.datetime.hour)
      File.delete(f)
    end
  })
end

