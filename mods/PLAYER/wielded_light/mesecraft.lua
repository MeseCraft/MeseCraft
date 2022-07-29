-- mesecraft lit node registration

local rln = wielded_light.register_lightable_node
minetest.register_on_mods_loaded(function()
      rln("default:ladder_wood", nil, "ladder_wood_")
      rln("default:ladder_steel", nil, "ladder_steel_")
      rln("mtg_plus:ladder_papyrus", nil, "ladder_papyrus_")
      rln("df_trees:spore_tree_ladder", nil, "ladder_sporetree_")
      rln("ropes:ropeladder_top", nil, "ladder_ropetop_")
      rln("ropes:ropeladder", nil, "ladder_ropemid_")
      rln("ropes:ropeladder_bottom", nil, "ladder_ropebottom_")
      rln("moreblocks:rope", nil, "mb_rope_")


      local mtgplus = {
	 "gold",
	 "bronze",
	 "copper",
	 "tin",
	 "aspen_wood",
	 "acacia_wood",
	 "pine_wood",
	 "junglewood",
      }

      for i = 1, #mtgplus do
	 rln("mtg_plus:ladder_"..mtgplus[i], nil, "ladder_"..mtgplus[i].."_")
      end
      local rtype = {
	 "wood",
	 "copper",
	 "steel",
      }
      for i = 1,#rtype do
	 for len = 1,9 do
	    local name = "ropes:"..rtype[i]..len.."rope_block"
	    if minetest.registered_nodes[name] then
	       rln(name, nil, rtype[i]..len.."ropeblock_")
	    end
	 end
      end
      rln("ropes:rope_bottom", nil , "rope_bottom_")
      rln("ropes:rope", nil , "rope_")
end)
