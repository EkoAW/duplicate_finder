require_relative 'FileInfo'

class DupeFinder
  def initialize(path, pattern, is_recursive, method)
    recurse = '/**'
    if (!is_recursive)
      recurse = ''
    end

    # generate search pattern
    @search_pattern = "#{path}#{recurse}/#{pattern}"
    @method = method
  end

  def find()
    dupe_hash = Hash.new ''
    dupe_index = 0
    dupe_top_key = 0
    dupe_top_count = 0

    # collecting all files into array
    files = Dir.glob(@search_pattern).reject{ |e| File.directory? e }
    files.map.each do |filename|
      file_info = FileInfo.new (filename)
      found = false

      unless dupe_hash.nil?
        # check current file_info against 1st array value from each dupe_hash
        dupe_hash.each do |key, value|
          if value[0].compare(file_info, @method)
            found = true
            # if it's a duplicate, add current file_info into current dupe_hash value
            value << file_info
            # update the top duplicates
            if value.length > dupe_top_count
              dupe_top_key = key
              dupe_top_count = value.length
            end
            break
          end
        end
      end

      # if not found any duplicates, add into new dupe_hash item
      if !found
        dupe_hash[dupe_index] = [file_info]
        dupe_index += 1
      end

    end

    if dupe_top_count == 0
      puts 'no duplicates found.'
    else
      # print the file content
      content = File.read(dupe_hash[dupe_top_key][0].filename)
      puts "#{content} #{dupe_top_count}"
    end
  end

  def run()
    find()
  end
end