# alias-manager

> ####This is just initial notes for future development!

Manage your projects using aliases

Imagine you have 2 web projects `alpha` and `delta`. For each one you have common task to do but in different way. Like each of this projects lives in different server. You obiously set ssh keys with agent and `~/.ssh/config` so you can quckly ssh to them with `ssh alpha` and `ssh delta`. Both projects lives in different directories, `alpha` in `/var/www/vhosts/alpha.areo/publich_html/` and `delata` in `/var/www/delta/app/`. Addicinally `delta` contain `files` directory inside project path under `sites/default/files/` and `alpha` doesn't, but have special `cofnig` file you editing very often. 

> There will be more information how to work with more then one server in future..

OK so how *alias-manager* can help me?

You can simply set following aliases on your host and remote machine (`am` is *alias-manager* command):

> We assuming `alpha` is your project name, of course it can be entyhitng else like single `a`, it's up to you how you name it.

First we want initialized project
```bash
$ am init alpha
Alias managment for project *alpha* initialized.
Project *alpha* set.
```

Then we'll create first simple alias..
```bash
$ am add ssh='ssh john@123.234.1.2 -p 50683'
Alias created: alpha.ssh
```
Nothing special. With simple bash alias I can do it as well, and also we could create `~/.ssh/config` entry. But we can adding more and more stuff relatead to our project and keep it under project name `alpha.*`


What's next.. let's create project relatead variable `BASE_PATH`
```bash
$ am add var BASE_PATH=/var/www/vhosts/alpha.areo
Alias project variable created: 
```
This variable will be remember for whole project and we can use it whenever and wherever we want.

So let do it in next alias `alpha.public`. This will create this alias for you on remote `alpha` host with some description.
```bash
$ am add-remote public='cd $BASE_PATH/public_html/' --desc='CD to main publich_html/'
alpha: Remote alias created: CD to main publich_html/
```

Add remote `alpha.files` alias
```bash
$ am add-remote files='cd $BASE_PATH/public_html/sites/default/files'
Remote alias created
alpha.files='cd $BASE_PATH/public_html/sites/default/files'
```


Now list all `alpha` aliases
```bash
$ am list alpha
Aliases for *alpha* project
 alpha.ssh='ssh alpha'
 alpha.public='cd $BASE_PATH/public_html/'  "CD to main publich_html/" (REMOTE)
 alpha.files='cd $BASE_PATH/public_html/sites/default/files' (REMOTE)
 
Aliases variables
 alpha.BASE_PATH=/var/www/vhosts/alpha.areo
```

When you try do entything with project that doesn't exist then error will occure..
```bash
$ am list beta
Project *beta* doesn't exist: Error
```

List all projects
```
$ am list
Projects:
 alpha
```


List of all avaiable commands
```
am init <project_name> # Init project
am destroy <project_name> # Remove project with all aliases and vars (ask [y/n])
am list # list all projects
am set <project_name> # Switch to another project
am list <project_name> # List all project aliases and variables
am list <project_name> alias # List all project aliases ONLY
am list <project_name> vars # List all project variables ONLY
am add <alias_name> # Add local alias
am remove <alias_name> # Remove alias from current project  (ask [y/n])
am add-remote <alias_name> # Add alias on your remote machine
am remove-remote <alias_name> # Remove alias on your remote machine  (ask [y/n])
```

This will list you all avaiable aliases (without vars) in your <project_name>. Same as in bash completion for all your  system commands and aliases.
```
$ <project_name>.[2xTAB]
```

If you have some other stuff to do on another box with the same project you can set something like this
```bash
john@box $ am add --remote:alpha-box2 alpha.stuff='cd /path/to/somewere && git branch'
```

Now for `delta` project you can do similar things..
```bash
@TODO
```

#### Features
 * Very easy usage as normal aliases and shell variables
 * Syncing aliases
 * Support remote alias across different hosts
