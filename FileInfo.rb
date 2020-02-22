require 'digest'

class FileInfo
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def get_size()
    if @size.nil?
      @size = File.size?(filename)
    end
    return @size
  end

  def get_md5()
    if @md5.nil?
      @md5 = Digest::MD5.file(@filename).base64digest
    end
    return @md5
  end

  def get_sha1()
    if @sha1.nil?
      @sha1 = Digest::SHA1.file(@filename).base64digest
    end
    return @sha1
  end

  def get_sha256()
    if @sha256.nil?
      @sha256 = Digest::SHA256.file(@filename).base64digest
    end
    return @sha256
  end

  def get_hash(method)
    if method.casecmp('md5') == 0
      return get_md5()
    elsif method.casecmp('sha1') == 0
      return get_sha1()
    elsif method.casecmp('sha256') == 0
      return get_sha256()
    else
      return get_sha1()
    end
  end

  def byte_compare(target)
    # open files as read-binary
    f1 = IO.new(IO.sysopen(@filename, 'rb'))
    f2 = IO.new(IO.sysopen(target.filename, 'rb'))
    loop do
      # read each byte and increment seek
      b1 = f1.getbyte
      b2 = f2.getbyte
      break if b1.nil? or b2.nil?
      # if two bytes are different, file not a duplicate
      if (b1 != b2)
        return false
      end
    end
    return true
  end

  def compare(target, method)
    # first step, comparing file size (fastest)
    if get_size() != target.get_size()
      return false
    # second step (byte), comparing file byte per byte (slow for large files)
    elsif (method.casecmp('byte') == 0)
      return byte_compare(target)
    # first step, comparing file hash
    elsif get_hash(method) != target.get_hash(method)
      return false
    else
      return true
    end
  end
end