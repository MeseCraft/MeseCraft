# Parties docs

Because it's always good to understand the API without surfing the code, init? :D

## 1 API

### 1.1 Utils

* `parties.is_player_invited(p_name)`: (bool) checks whether a player has a pending invite
* `parties.is_player_in_party(p_name)`: (bool) checks whether a player is in any party
* `parties.is_player_party_leader(p_name)`: (bool) checks whether a player is the party leader of any party
* `parties.chat_send_party(p_name, msg, as_broadcast)`: (nil) sends a message to every player inside the party where `p_name` is (`p_name` doesn't necessarily have to be the party leader). If `as_broadcast` is true, it'll be sent without following Minetest chat format. If false, `p_name` will be pointed as the sender when formatting the message
* `parties.change_party_leader(old_leader, new_leader)`: (nil) changes the party leader
* `parties.cancel_invite(p_name, inviter)`: (nil) cancels a pending invite from `inviter`
* `parties.cancel_invites(p_name)`: (nil) cancels all the pending invites of `p_name`

### 1.2 Getters

* `parties.get_inviters(p_name)`: (table) returns a table containing the name(s) of the player(s) who invited `p_name`, if an invite is pending
* `parties.get_party_leader(p_name)`: (string) returns the party leader of the party where `p_name` is in
* `parties.get_party_members(party_leader)`: (table) returns a list of every player inside the party where `party_leader` is in


## 2 Customisation

### 2.1 Callbacks

* `parties.register_on_pre_party_invite(function(sender, p_name))`: use it to run additional checks. Returning true keeps executing the invite, returning false/nil cancels it
* `parties.register_on_party_invite(function(sender, p_name))`: called when an invite has been successfully sent
* `parties.register_on_pre_party_join(function(party_leader, p_name))`: use it to run additional checks.Returning true keeps executing the join function, returning false/nil cancels it
* `parties.register_on_party_join(function(party_leader, p_name))`: called when a player successfully joined a party
* `parties.register_on_party_leave(function(party_leader, p_name))`: called when a player leaves a party
* `parties.register_on_party_disband(function(p_name))`: called when a party gets disbanded (by `p_name`, who is the party leader)

### 2.2 Chat

Chat is light blue by default and it adds the `[Party] ` prefix at the beginning of every message. It then follows the format of the chat set by the owner. By default is:  
`[Party] <playername> message`


