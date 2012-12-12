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
    @queue.keys.sort.each do |delay|
      @queue[delay].each do |job|
        job.call
      end
    end
  end
end