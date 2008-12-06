require 'uuidtools'

#Method exposed to dialplan.rb that will treat the incoming calls
methods_for :dialplan do  
  
  #Call this method from the dialplan to treat the resulting call being placed out
  def treat_call
    #First we collect the variables from the Asterisk channel with instructions on what to do with this call
    strategy_name = get_variable "strategy_name"

    treatment_strategy = COMPONENTS.hammer[:treatment_strategies].find { |value| value[strategy_name] }

    if treatment_strategy[strategy_name][:record] == true
      execute("MixMonitor","hammer-#{strategy_name}-#{UUID.random_create}.gsm")
    end
    
    #Now, lets treat the call
    sleep COMPONENTS.hammer[:common][:before_delay].to_i
    if treatment_strategy[strategy_name][:send_dtmf] != nil
      dtmf treatment_strategy[strategy_name][:dtmf]
      sleep treatment_strategy[strategy_name][:after_delay].to_i
    end
    
    start_time = Time.now
    while Time.now < start_time + treatment_strategy[strategy_name][:call_length].to_i.seconds do
      if treatment_strategy[strategy_name][:message] != nil
        begin
          play treatment_strategy[strategy_name][:message]
        rescue => err
          ahn_log.hammer.warn "Tried to play a file to a hungup channel"
          return
        end
      else
        sleep treatment_strategy[strategy_name][:call_length].to_i
      end
    end
    
    hangup
  end
  
  #Call this method from the dialplan if you would also like to serve some treatments to the receiving Asterisk
  def treat_called
    start_time = Time.now
    while Time.now < start_time + COMPONENTS.hammer[:called_treatment][:call_length].to_i.seconds do
      play COMPONENTS.hammer[:called_treatment][:message]
    end
    hangup
  end
end

#Hammer class
class Hammer
  
  def initialize  
  end
  
  def start
    #Loop making the calls until someone kills us
    loop do
      make_calls
      sleep COMPONENTS.hammer[:common][:delay_between_cycles]
    end
  end
  
  private 
  
  #Method to initiate the call blocks and determine if they 
  #should be done in threads simultaneously or synchronously 
  def make_calls
    cnt = 0
    while cnt < COMPONENTS.hammer[:common][:cycle_length] do
      if COMPONENTS.hammer[:common][:thread_cycles] == true
        Thread.new do
          execute_strategies
        end
      else
        execute_strategies
      end
    cnt += 1
    end
  end
  
  #Method to execute a call for each of the treatment strategies set
  def execute_strategies
    COMPONENTS.hammer[:treatment_strategies].each do |treatment_strategy|

      strategy_name = nil
      treatment_strategy.each_key {|key| strategy_name = key}
      treatment_strategy.each_value {|value| treatment_strategy = value}

      result = launch_call(strategy_name, treatment_strategy)

      if COMPONENTS.hammer[:common][:delay_between_calls] == 'random'
        sleep rand(COMPONENTS.hammer[:common][:max_random_between_calls])
      else
        sleep COMPONENTS.hammer[:common][:delay_between_calls]
      end
    end
  end
  
  #Launch the individual phone calls
  def launch_call(strategy_name, treatment_strategy)
    channel = COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:channel] + treatment_strategy[:number].to_s
    options = { "Channel" => channel,
                "Context" =>  COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:context],
                "Exten" =>  COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:extension],
                "Priority" => COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:priority],
                "Callerid" => treatment_strategy[:callerid],
                "Timeout" => COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:timeout],
                "Variable" => "strategy_name=" + strategy_name,
				        "Async" => COMPONENTS.hammer[:dial_strategies][0][treatment_strategy[:dial]][:async] }
    result = Adhearsion::VoIP::Asterisk.manager_interface.originate options
    ahn_log.hammer.debug result["Message"]
    return result
  end

end

begin
  #Now launch the hammer and let it run
  Thread.new do
    sleep COMPONENTS.hammer[:common][:initial_delay].to_i
    Hammer.new.start
  end
rescue => err
  ahn_log.hammer.error "Error when attempting to start the Hammer"
  ahn_log.hammer.error err
end