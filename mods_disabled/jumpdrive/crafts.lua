
if minetest.get_modpath("default") then
  minetest.register_craft({
    output = 'jumpdrive:engine',
    recipe = {
      {'jumpdrive:backbone', 'default:steelblock', 'jumpdrive:backbone'},
      {'default:steelblock', 'default:steelblock', 'default:steelblock'},
      {'jumpdrive:backbone', 'default:steelblock', 'jumpdrive:backbone'}
    }
  })

  minetest.register_craft({
    output = 'jumpdrive:backbone',
    recipe = {
      {'default:mese_block', 'default:steelblock', 'default:mese_block'},
      {'default:steelblock', 'default:steelblock', 'default:steelblock'},
      {'default:mese_block', 'default:steelblock', 'default:mese_block'}
    }
  })
end
