
# Various patches for proper jumpdrive integration

## pipeworks

Teleport tube compat

```
cat ../jumpdrive/patches/pipeworks.patch | patch -p1
```

Adds the following interface:
```lua
-- expose for external batch use (jumpdrive)
pipeworks.tptube = {
        hash = hash,
        save_tube_db = save_tube_db,
        tp_tube_db = tp_tube_db,
        tp_tube_db_version = tp_tube_db_version
}
```

Notes:
* `tp_tube_db_version` should be 2.0
