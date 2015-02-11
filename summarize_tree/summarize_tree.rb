#!/usr/bin/env ruby

require 'find'

num_directories = 0
num_files = 0

Find.find(ARGV[0]) do |path|
  if FileTest.directory?(path)
    num_directories += 1
  elsif FileTest.file?(path)
    num_files += 1
  else
    puts "An unknown type of file: #{path}"
    exit(1)
  end
end

puts "There were #{num_directories} directories."
puts "There were #{num_files} regular files."
