Copyright (C) 2008 Jason Goecke

== Hammer for Adhearsion

The Presence Hammer is used to generate live inbound call load on an Asterisk/OpenGate system. The Presence Hammer also provides a facility to play DTMF tones at the beginning of a call in order to traverse an IVR menu, such as one developed by IR/IR-VO. The intent is use this facility in both engineering QA as well as a tool for operations in the field to load test each and every OpenGate implementation as part of our project methodology.

=== Configuration

  See ahn_project/comoponents/hammer/config.yml for details on configuration. Also, if you would like to capture events to a CouchDB instance you must include this in the ahn_project/events.rb (filter as you like):

	events.asterisk.manager_interface.each do |event|
   	  log_event(event)
	end

=== Requirements

- Ruby 1.8.6+ or JRuby 1.1.6+ (Events capture currently not supported with JRuby)
- Adhearsion 0.8.0+
- CouchRest 0.10.1+ (only if you enable logging to the CouchDB)

=== Installing

  In path_to_your_ahn_project/components/ do the following:

  git clone git://github.com/jsgoecke/hammer.git

