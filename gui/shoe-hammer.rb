#Gui written with Shoes to control the Hammer
Shoes.app :width => 200, :height => 250, :title => 'Hammer Controls' do
  @hostname = nil
  @default_drb_port = 9050
  
  #Set some background colors
  background '#FFFFFF'
  
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
        result = hammer.hammer_status
      end
      return { :status => 'ok', :message => result }
    rescue => err
      return { :status => 'error', :message => err }
    end
  end
  
  #Create a 'stack' of elements that are grouped together
  stack :center => true, :width => 200, :margin => 30 do
    @hostname = edit_line :width => 120
    button 'Hammer Status' do
      if @hostname.text == ''
        alert 'Please enter in a hostname and port in the text field (ie - localhost:9050)'
      else      
        result = connect_to_drb(@hostname.text, 'status')
        alert "Hammer Status is... #{result[:message]} @ #{@hostname.text}"
      end
    end
    button 'Start Hammer' do
      if @hostname.text == ''
        alert 'Please enter in a hostname and port in the text field (ie - localhost:9050)'
      else
        if confirm("Are you sure you want to start the hammer?")
          result = connect_to_drb(@hostname.text, 'start')
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