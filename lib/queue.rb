class Queue

  def initialize
    @queue = {}
  end

  def add(delay=0, &block)

    if @queue[delay].nil?
      @queue[delay] = [block]
    else
      @queue[delay] << block
    end
  end

  def run
    start_time = Time.now
    @queue.keys.sort.each do |delay|
      @queue[delay].each do |job|
        since_start = Time.now - start_time
        sleep(delay - since_start) if delay > since_start
        job.call
      end
    end
  end
end