require File.join(File.dirname(__FILE__), '../../spec/spec_helper')

describe DLock do
  context 'checking pid' do
    DLock.new.process_running?($$).should == true
  end

  context 'reentrant locking' do
    it 'should lock' do
      a = DLock.lock :lock => 'test' do

        b = DLock.lock :lock => 'test' do
          true
        end
        b.should == nil

        true
      end

      a.should == true
    end
  end

  context 'different process' do
    it 'should lock depending on process state' do
      alock = DLock.new
      a = alock.lock :lock => 'test' do
        block = DLock.new

        block.stub!(:process_running?).and_return(true)
        b = block.lock :lock => 'test' do
          true
        end
        b.should == nil

        block.stub!(:process_running?).and_return(false)
        block.stub!(:unblocked?).and_return(true)
        b = block.lock :lock => 'test' do
          true
        end
        b.should == true

        true
      end

      a.should == true
    end
  end
end
