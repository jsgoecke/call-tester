Copyright (C) 2008 Jason Goecke

What is Hammer?
==============

The Hammer is an [Adhearsion] component used to generate live inbound call load on an another Asterisk or Telephony system. The Hammer also provides a facility to play DTMF tones at the beginning of a call in order to traverse an IVR menu. The intent is to use this component to load test telephony systems.

Requirements?
=============

[Ruby v1.8.6+]: http://www.rubylang.org or [JRuby v1.1.5+]: http://jruby.codehaus.org/
[Asterisk v1.4+]: http://www.asterisk.org
[Adhearsion v0.8+]: http://www.adhersion.com
[Uuid-tools gem]

How does it work?
=================

The Hammer component uses Adhearsion to generate call traffic via Asterisk. More to come...

Installing
==========

In path_to_your_ahn_project/components/ do the following:

git clone git://github.com/jsgoecke/hammer.git

Setting up Hammer
=================
