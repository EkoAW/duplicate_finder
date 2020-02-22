require 'digest'

class FileInfo
  attr_accessor :source

  def initialize(source)
    @source = source
  end

  def get_size()
    if @size.nil?
      @size = File.size?(source)
    end
    return @size
  end

  def get_sha1()
    if @sha1.nil?
      @sha1 = Digest::SHA1.file(@source).base64digest
    end
    return @sha1
  end

  def compare(target)
    if get_size() != target.get_size()
      return false
    elsif get_sha1() != target.get_sha1()
      return false
    else
      return true
    end
  end
end