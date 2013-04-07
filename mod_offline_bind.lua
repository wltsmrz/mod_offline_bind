local st          = require "stanza";
local datamanager = require "util.datamanager";
local datetime    = require "util.datetime";
local jid_split   = require "util.jid".split;

module:hook("message/offline/handle", function(event)
  local origin, stanza = event.origin, event.stanza;
  local to = stanza.attr.to;
  local node, host;

  if to then
    node, host = jid_split(to)
  else
    node, host = origin.username, origin.host;
  end

  stanza.attr.stamp, stanza.attr.stamp_legacy = datetime.datetime(), datetime.legacy();
  local result = datamanager.list_append(node, host, "offline", st.preserialize(stanza));
  stanza.attr.stamp, stanza.attr.stamp_legacy = nil, nil;

  return result;
end);

module:hook("message/offline/broadcast", function(event)
  local origin = event.origin;
	local node, host = origin.username, origin.host;

	local data = datamanager.list_load(node, host, "offline");
	if not data then return true end

	for _, stanza in ipairs(data) do
		stanza = st.deserialize(stanza);
		stanza:tag("delay", {
      xmlns = "urn:xmpp:delay",
      from = host,
      stamp = stanza.attr.stamp
    }):up(); -- XEP-0203

		stanza:tag("x", {
      xmlns = "jabber:x:delay",
      from = host,
      stamp = stanza.attr.stamp_legacy
    }):up(); -- XEP-0091 (deprecated)

		stanza.attr.stamp, stanza.attr.stamp_legacy = nil, nil;
		origin.send(stanza);
	end

	datamanager.list_store(node, host, "offline", nil);

	return true;
end);

module:hook("resource-bind", function(event)
  module:fire_event("message/offline/broadcast", { origin = event.session });
end, 0);
