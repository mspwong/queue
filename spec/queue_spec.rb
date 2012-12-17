require 'queue'

describe Queue do
  let(:queue) { Queue.new }

  context "no delay" do
    it "can add and run one item" do
      block_called = false
      queue.add do
        block_called = true
      end

      block_called.should be_false
      queue.run
      block_called.should be_true
    end

    it "runs the jobs in the same order as added" do
      blocks_called = []
      queue.add do
        blocks_called << 1
      end
      queue.add do
        blocks_called << 2
      end

      queue.run
      blocks_called.should == [1, 2]
    end
  end

  context 'delay' do
    it "run job at correct order" do
      blocks_called = []
      queue.add(2) do
        blocks_called << 2
      end
      queue.add(1) do
        blocks_called << 1
      end

      queue.run
      blocks_called.should == [1, 2]

    end

    it "runs multiple jobs in order as added" do
      blocks_called = []
      queue.add(2) do
        blocks_called << 2
      end
      queue.add(2) do
        blocks_called << 3
      end
      queue.add(1) do
        blocks_called << 1
      end

      queue.run
      blocks_called.should == [1, 2, 3]
    end

    it "runs multiple jobs at the specified delays" do
      time_5 = nil
      queue.add(5) { time_5 = Time.now }
      time_2_0 = nil
      queue.add(2) { time_2_0 = Time.now }
      time_0 = nil
      queue.add(0) { time_0 = Time.now }
      time_2_1 = nil
      queue.add(2) { time_2_1 = Time.now }
      start_time = Time.now

      queue.run
      (time_0 - start_time).should be_within(0.05).of(0)
      (time_2_0 - start_time).should be_within(0.05).of(2)
      (time_2_1 - start_time).should be_within(0.05).of(2)
      (time_5 - start_time).should be_within(0.05).of(5)
    end
  end

end