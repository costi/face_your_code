#!/usr/bin/env ruby

require 'pry'

# For each face image I make a composite image with the screenshot nearest in time.
# Then I make a movie from the composite photos.
# I do this because webcam images have change detection and they are not guaranteed to be every
# then seconds. 
# The more efficient way to do this is to create two movie streams and make picture in picture, but
# it's hard to make the movies in sync.

unless ARGV.length == 3
  puts "usage: composite <screenshots_dir> <faces_dir> <movie_file_name>"
  exit
end

require 'tmpdir'
require_relative 'image_filename'

screenshots_dir = ARGV[0]
faces_dir = ARGV[1]
movie_file_name = ARGV[2]

def make_composites(screenshots_dir, faces_dir, composite_dir)
  # shot example: 2011-03-03-snap-09-46-39.jpg
  Dir.chdir(screenshots_dir) do
    @screenshots = ImageSet.new(Dir.glob("*.jpg").map{|s| Screenshot.new(s, File.mtime(s))})
  end

  # faces example: 2011-03-03-snap-09-47-19.jpg 
  Dir.chdir(faces_dir) do
    @faces = ImageSet.new(Dir.glob("*.jpg").map{|f| Faceshot.new(f, File.mtime(f))})
  end

  @matched_screenshots = []
  @faces.each do |face|
    #puts sprintf('%30s -> %30s', face.datetime, @matched_screenshots.last.datetime)
    composite_image_file = "#{composite_dir}/#{face.datetime.to_s}.jpg" 
    @matched_screenshots << @screenshots.nearest_in_time_bsearch(face)
    if !File.exist?(composite_image_file)
      # TODO: make my face bigger and make it a little transparent over the screen
      composite_command = "gm composite -compose Atop -gravity North -resize 30% #{faces_dir}/#{face.filename} #{screenshots_dir}/#{@matched_screenshots.last.filename} -noop -geometry 1280x800 #{composite_image_file}"
      puts composite_command
      %x[#{composite_command}]
    else
      #puts "Skipping: #{face.filename} matches #{@matched_screenshots.last.filename}"
    end

  end
end

def make_movie(composite_dir, movie_file_name)
  movie_command = "mencoder 'mf:/#{composite_dir}/*.jpg' -mf fps=10 -o #{movie_file_name} -ovc lavc -lavcopts vcodec=mpeg4"
  puts movie_command
  %[#{movie_command}]
end



# DOOOO IT!!!
Dir.mktmpdir { |composite_dir| 
  make_composites(screenshots_dir, faces_dir, composite_dir)
  make_movie(composite_dir, movie_file_name)
}



