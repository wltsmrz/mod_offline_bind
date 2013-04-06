#mod_offline_bind

This is an alternative to the `offline` module for [Prosody](http://prosody.im/) XMPP server. It has the same functionality; if a user is offline when messages are sent, they [the messages] will be stored in an offline queue and resent when the user re-appears. This module differs from the `offline` module in that, the `offline` module is dependent on `presence` module to send `message/offline/broadcast` event. This module, `mod_offline_bind` is independent of `presence`, and listens for `resource-bind` instead. It works. And it allows you to disable presence and keep your offline message functionality.

###Note

+ This module is not tested on previous versions, but it's simple enough that it either should "just work" or "just work with minor tweaking". It probably works.

###Usage

+ Clone this repository into your `plugins` directory.
+ Disable `offline` module in your `prosody.cfg.lua`
+ Replace it with `offline_bind` 
+ Reload config or restart Prosody server
