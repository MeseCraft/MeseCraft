ChatCmdBuilder.new("party", function(cmd)

    -- invito
    cmd:sub("invite :player", function(sender, p_name)
        parties.invite(sender, p_name)
        end)

    -- accettazione
    cmd:sub("join", function(sender)
        parties.join(sender)
        end)

    -- accettazione con nick
    cmd:sub("join :inviter", function(sender, inviter)
        parties.join(sender, inviter)
        end)

    -- abbandono
    cmd:sub("leave", function(sender)
        parties.leave(sender)
        end)

    -- scioglimento
    cmd:sub("disband", function(sender)
        parties.disband(sender)
        end)

end,{})



ChatCmdBuilder.new("p", function(cmd)

    -- chat party
    cmd:sub(":message:text", function(sender, message)
        parties.chat_send_party(sender, message)
        end)

end,{})
