require_relative 'FileInfo'
require 'benchmark'

class DupeFinder
  def initialize(path, pattern, is_recursive)
    recurse = '/**'
    if (!is_recursive)
      recurse = ''
    end
    @search_pattern = "#{path}#{recurse}/#{pattern}"
  end

  def find()
    dupe_hash = Hash.new ''
    dupe_top_key = 0
    dupe_top_count = 0
    dupe_index = 0

    print 'collecting... '
    files = Dir.glob(@search_pattern).reject{ |e| File.directory? e }
    puts "#{files.length} files"
    puts 'finding duplicates...'

    files.map.each do | filename |
      file_info = FileInfo.new (filename)

      found = false

      unless dupe_hash.nil?
        dupe_hash.each do |key, value|
          if value[0].compare(file_info)
            found = true
            value << file_info
            if value.length > dupe_top_count
              dupe_top_key = key
              dupe_top_count = value.length
            end
            break
          end
        end
      end

      if !found
        dupe_hash[dupe_index] = [file_info]
        dupe_index += 1
      end

    end

    if dupe_top_count == 0
      puts 'no duplicates found.'
    else
#      firstline = File.open(dupe_hash[dupe_top_key][0].source, &:gets)
#      puts "#{firstline} #{dupe_top_count}"
      puts "found #{dupe_top_count} duplicates"
      dupe_hash[dupe_top_key].each do |fi|
        puts fi.source
      end
    end
  end

  def run()
    time = Benchmark.measure {
      find()
    }
    puts "#{time.real}"
end
end