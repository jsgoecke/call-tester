#Gui written with Shoes to control the Hammer
Shoes.app :width => 200, :height => 500, :title => 'Hammer Controls' do
  @hostname = nil
  @default_drb_port = 9050
  
  #Set some background colors
  background '#FFFFFF' #'rgb(255, 255, 255)'
  fill rgb(0, 0.6, 0.9, 0.1)
  stroke rgb(0, 0.6, 0.9)
  strokewidth 0.25
  20.times {
    oval :left => (-5..self.width).rand,
      :top => (-5..self.height).rand,
      :radius => (25..50).rand
  }
  
  #Create a 'stack' of elements that are grouped together
  stack :center => true, :width => 200, :margin => 30 do
    @hostname = edit_line :width => 120
    button 'Hammer Status' do
      if @hostname.text == ''
        alert 'Please enter in a hostname and port in the text field (ie - localhost:9050)'
      else      
        #Add some code here
        alert "Hammer Status is... @ #{@hostname.text}"
      end
    end
    button 'Start Hammer' do
      if @hostname.text == ''
        alert 'Please enter in a hostname and port in the text field (ie - localhost:9050)'
      else
        if confirm("Are you sure you want to start the hammer?")
          #Add some code here
          alert "Starting the hammer @ #{@hostname.text}"
        end
      end
    end
    button 'Stop Hammer' do
      if @hostname.text == ''
        alert 'Please enter in a hostname and port in the text field (ie - localhost:9050)'
      else
        if confirm("Are you sure you want to stop the hammer?")
          result = connect_to_drb(@hostname.text, 'stop')
          alert "Stopping the hammer @ #{@hostname.text}. Result: #{result[:message]}"
        end
      end    
    end
    button 'Quit' do
      if confirm("Are you sure you want to quit?")
        exit
      end
    end
  end
  
  para 'Copyright (C) 2008 Jason Goecke', :align => 'center', :size => 8
end

#Use this method to connect to the DRb service
def connect_to_drb(url, action)
  begin
    hammer = DRbObject.new_with_uri url
    case action
    when 'start'
      result = hammer.start_calls
    when 'stop'
      result = hammer.stop_calls
    when 'status'
      result = hammer.running_status
    end
    return { :status => 'ok', :message => result }
  rescue => err
    return { :status => 'error', :message => err }
  end
end