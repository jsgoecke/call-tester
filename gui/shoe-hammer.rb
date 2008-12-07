Shoes.app :width => 200, :height => 470, :title => 'Hammer Controls' do
  @hostname = nil
  background '#FFFFFF' #'rgb(255, 255, 255)'
  fill rgb(0, 0.6, 0.9, 0.1)
  stroke rgb(0, 0.6, 0.9)
  strokewidth 0.25
  20.times {
    oval :left => (-5..self.width).rand,
      :top => (-5..self.height).rand,
      :radius => (25..50).rand
  }
  stack :center => true, :resizeable => true, :margin => 30 do
    image 'img/hammer.jpg'
    #How do I get the text back?
    @hostname = edit_line :width => 120
    button 'Hammer Status' do
      alert 'Hammer Status is...'
    end
    button 'Start Hammer' do
      if confirm("Are you sure you want to start the hammer?")
        alert "Starting the hammer @ #{@hostname.text}"
      end
    end
    button 'Stop Hammer' do
      if confirm("Are you sure you want to stop the hammer?")
        alert 'Stoping the hammer...'
      end
    end
    button 'Quit' do
      if confirm("Are you sure you want to quit?")
        exit
      end
    end
  end
  #para 'Copyright (C) 2008 Jason Goecke', :align => 'center', :bottom => 0
end