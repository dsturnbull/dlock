#require 'rush'

class DLock
  def self.lock(*args, &block)
    DLock.new.lock(*args, &block)
  end

  def process_running?(pid)
    if pid && pid != ''
      system("ps | grep -v grep | grep #{pid} > /dev/null")
    end
  end

  def lock_file
    File.join('/tmp', @lock)
  end

  def block_file
    @_block_file ||= File.open(lock_file, 'w')
  end

  def lock_active
    $stderr.print "#{lock_file} active\n" if @debug
  end

  def lock(options={})
    @debug = options[:debug] || false
    @lock  = options[:lock]  || caller[1].gsub(/['`\/ ]/, '_')

    if File.exist?(lock_file)
      if process_running?(File.read(lock_file))
        return lock_active
      end
    end

    write_pid

    unless unblocked?
      return lock_active
    end

    begin
      yield
    ensure
      block_file.flock(File::LOCK_UN)
      File.unlink(lock_file) if File.exist?(lock_file)
    end
  end

  def unblocked?
    Proc.new { block_file.flock(File::LOCK_EX | File::LOCK_NB) }.call
  end

  def pid
    $$
  end

  def write_pid
    block_file << pid
    block_file.fsync
  end
end


