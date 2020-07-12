Ignore mod by Mg
================

# API Documentation

## 0°) Namespaces
Ignore uses a few namespaces to organize its data. Here is a diagram explaining them :

    ignore <- main namespace
    |
    + lists <- all the players' ignore lists (see part 1)
    |     |
    |     + data <- the players' data
    |     |    |
    |     |    + foo <- player foo's ignore list
    |     |    + bar <- player bar's ignore list
    |     |    + ...
    |     |
    |     |
    |     + get_list <- basic api methods (lists, etc...)
    |     + get_ignore_names <- for all of them see part 1
    |     + set_list
    |     + del_list
    |     + init_list
    |     + get_ignore
    |     + add
    |     + del
    |     + save
    |     + load
    |
    + queue <- the entire queues, data and methods (see part 2)
    |     |
    |     + data <- queues data
    |     |    |
    |     |    + save <- 'save' type queue's data
    |     |    + ...
    |     |
    |     + add <- add method
    |     + workall <- workall method
    |     + work <- work method
    |     + flush <- flush method
    |
    + callback <- ignore's callback (see part 3)
    + config <- configuration values (see part 5)
           |
           + save_dir
           + enabled
           + queue_interval


## 1°) Lists

Lists are the basic containers of ignore data. Multiple methods are provided to manage, create, save and load lists. All lists are loaded in `ignore.lists[playername]` as a dictionary. The dictionary's key is the ignored player's name, and its value is the time stamp indicating the moment they were ignored.
Those methods come in `lists.lua` :
 - `ignore.get_list` :
    - 1 parameter : name (string)
    - returns the player's entry in `ignore.`
 - `ignore.get_ignore_names` :
    - 1 parameter : name (string)
    - returns a list of names the player is ignoring (mostly for size purposes)
 - `ignore.set_list(name, list)`
    - 2 parameters : name (string), list (dictionary of strings,timestamps)
    - sets name's ignore list to list
 - `ignore.del_list(name)`
    - 1 parameter : name (string)
    - unloads name's list from the loaded lists
 - `ignore.init_list(name)`
    - 1 parameter : name (string)
    - resets name's ignore list to an empty dictionary. Creates it if it doesn't exist
 - `ignore.get_ignore(ignored, name)`
    - 2 parameters : ignored (string), name (string)
    - returns name's entry about ignored, whether or not it exists. Tries to load names' ignore list, and return the error string given by `io.open`, returned by `ignore.load`, along with the value false, and creates an empty list for the player when it fails to load it.
 - `ignore.add(ignored, name)`
    - 2 parameters : ignored (string), name (string)
    - adds `ignored` to name's list, or warn if they're already ignored ('dejavu' return code)
    - if the player `ignored` is protected by `ignore_protection`, return false and the 'protected' code
 - `ignore.del(ignored, name)`
    - 2 parameters : ignored (string), name (string)
    - removes ignored from name's list, or warn if they're not being ignored ('notignored' return code)
 - `ignore.save`
    - 1 parameter : name (string)
    - saves name's list in ignore's configured save directory (under name's name)
 - `ignore.load`
    - 1 parameter : name (string)
    - loads name's list from their file in ignore's configured save directory
    - it is used before anyone with an empty ignore list uses `/ignore`

## 2°) Queue

Ignore uses queues to delay actions such as saving. Here is how to use them.
These methods come from `queues.lua`:
 - `ignore.queue.add`
    - 1 parameter : action (dictionary)
    - enqueues an action in the 'action.type' queue
    - currently supported types :
        - save : saving files (parameters : target (string))
    - if no type is provided, error code 'notype' returned
    - if an action of the same type and parameters is already queue, returns code 'dejavu'
 - `ignore.queue.workall`
    - no parameters
    - does one action in each filled queue
 - `ignore.queue.work`
    - 1 parameter : queuetype (string)
    - does one action in queue of type queuetype. If it doesn't exist, return error code 'nosuchqueue'. If it is empty, returns 'emptyqueue'
    - the error code 'noarget' alerts about the missing 'target' parameter on types like 'save'
 - `ignore.queue.flush`
    - no parameters
    - flushes all queues, doing all queued work until everything is empty
    - hooked by default to `minetest.register_on_shutdown`

## 3°) The callback

Ignore's callback is located inside `callback.lua`. It is by default hooked to `minetest.register_on_chat_message`. It does all the engine's work while filtering according to ignore lists.
The same file also contains an override of /me to block ignored user's actions.

## 4°) The chatcommand and privilege

Ignore's chatcommand, the users' basic interface, is implemented in `chatcommand.lua`, along with the definition of the `ignore_protection` privilege. A configuration key can allow you to disable this file, making ignore pointless. The chat command currently handles 5 subcommands :
 - `add` :
    - 1 parameter needed : the player's name
    - adds the player to the invoker's ignore list if the player isn't protected with the `ignore_protection` privilege, or warn them if they are already ignored
    - note : `add` can be replaced by `+`
 - `del` :
    - 1 parameter needed : the ignored player's name
    - removes the player from the invoker's ignore list, or warn them if they were not being ignored
    - note : `del` can be replaced by `-`
 - `help` :
    - no parameters needed
    - shows the basic help for the 5 subcommands
 - `show` :
    - no parameters needed
    - shows to the invoker their ignore list, or tell them if it is currently empty
 - `init` :
    - no parameters needed
    - resets the invoker's ignore list to an empty dictionary
 - `check` :
    - 1 parameter needed : a player's name
    - tells you whether or not player `name` is ignoring you

Note : players need the `shout` privilege to use `/ignore`.

## 5°) Configuration keys

Ignore uses some configuration keys as variable values :
 - `ignore.config.save_dir` :
    - directory in which are saved all ignore files
    - defaults to `minetest.get_worldpath() .. '/ignore'`
 - `ignore.config.enabled` :
    - indicates whether or not to load the callback
    - is the opposite value of the key `disable_ignore` in `minetest.conf`
    - defautls to `true`
 - `ignore.queue_interval` :
    - interval between two collective queue works (`ignore.queue.workall` calls) in seconds
    - from the key `ignore_queue_interval` in `minetest.conf`
    - defaults to 30 seconds
