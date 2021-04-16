class Ate
  @@current_stack = {}
  @@waiting_stack = {}

  def waiting_stack
    @@waiting_stack
  end

  def current_stack
    @@current_stack
  end

  def call(number, caller)
    if current_stack.has_key?(number)
      @callers = []
      if waiting_stack.has_key?(number)
        @callers = waiting_stack.fetch(number)
        waiting_stack.delete(number)        
      else
        @callers = []
      end
      @callers << caller
      waiting_stack[number] = @callers
      puts "#{caller.name} put to sleep"
    else
      current_stack[number] = caller
      puts "#{caller.name} started call to #{number}"
      thread = Thread.new do 
        begin
          mutex = Mutex.new
          mutex.lock
          Thread.sleep(5000)
          caller.abort(number)
          mutex.unlock
        rescue Interrupt 
          puts "Interrupted..."
        end
      end
    end
  end

  def abort(number, caller)
    if current_stack.has_key?(number)
      current_stack.delete(number)
      puts "#{caller.name} aborted call to #{number}"
      if waiting_stack.has_key?(number) 
        c = waiting_stack.fetch(number).fetch(0)
        waiting_stack.fetch(number).delete(0)
        if waiting_stack.fetch(number).size == 0
          waiting_stack.delete(number)
        end
        call(number, c)
      end
    end
  end
end

class Caller
  attr_accessor :name, :ate

  def initialize(name, ate)
    self.name = name
    self.ate  = ate
  end

  def call(number)
    puts "#{self.name} is trying to call to #{number}"
    ate.call(number, self)
  end

  def abort(number)
    ate.abort(number, self)
  end
end

proc do 
  ate = Ate.new

  Caller.new("Lera", ate).call("3434")
  Caller.new("Fox", ate).call("2345")
  Caller.new("Kira",  ate).call("3434")
  Caller.new("Sasha", ate).call("3434")
  Caller.new("Denis",  ate).call("2345")
  Caller.new("Ira",  ate).call("2345")
  Caller.new("Yeti",  ate).call("3434")
end.()