# project-manager

> ####This is just initial notes for further development!

Manage your projects using aliases

Imagine you have 2 web projects `foo` and `bar`. For each one you have common task to do but in different way. Like each of this projects lives in different server. You obiously set ssh keys with agent and `~/.ssh/config` so you can quckly ssh to them with `ssh foo` and `ssh bar`. Both projects lives in different directories, `foo` in `/var/www/vhosts/foo.areo/publich_html/` and `bar` in `/var/www/bar/app/`. Additionally `bar` contain `files` directory inside project path under `sites/default/files/` and `foo` doesn't, but have special `cofnig` file you editing very often.

> There will be more information how to work with more then one server in future..


### Usage

OK so how *alias-manager* can help me?

You can simply set following aliases on your host and remote machine (`am` is *alias-manager* command):

> We assuming `foo` is your project name, of course it can be entyhitng else like single `a`, it's up to you how you name it.

First we want initialized project
```
$ pm init foo
Alias managment for project *foo* initialized.
Project *foo* set.
```

Then we'll create first simple alias..
```
$ pm add ssh='ssh john@123.234.1.2 -p 50683'
Alias created: foo.ssh
```
Nothing special. With simple bash alias I can do it as well, and also we could create `~/.ssh/config` entry. But we can adding more and more stuff relatead to our project and keep it under project name `foo.*`


What's next.. let's create project relatead variable `BASE`
```
$ pm add-path BASE=/var/www/vhosts/foo.areo
(foo) Path added: BASE=/var/www/vhosts/foo.areo
```
This variable will be remember for whole project and we can use it whenever and wherever we want.

So let do it in next alias `foo.public`. This will create this alias for you on remote `foo` host with some description.
```
$ pm add-remote public='cd {{BASE}}/public_html/' --desc='CD to main publich_html/'
foo: Remote alias created: CD to main publich_html/
```

Add remote `foo.files` alias
```
$ pm add-remote files='cd {{BASE}}/public_html/sites/default/files'
Remote alias created
foo.files='cd {{BASE}}/public_html/sites/default/files'
```


Now list all `foo` aliases
```
$ pm list foo
Aliases for *foo* project
 foo.ssh='ssh foo'
 foo.public='cd {{BASE}}/public_html/'  "CD to main publich_html/" (REMOTE)
 foo.files='cd {{BASE}}/public_html/sites/default/files' (REMOTE)

Aliases paths
 foo.BASE=/var/www/vhosts/foo.areo
```


This will also work without project name because is already SET using `init`.
```
$ pm list
Aliases for *foo* project
 foo.ssh='ssh foo'
 foo.public='cd {{BASE}}/public_html/'  "CD to main publich_html/" (REMOTE)
 foo.files='cd {{BASE}}/public_html/sites/default/files' (REMOTE)

Aliases paths
 foo.BASE=/var/www/vhosts/foo.areo
```

When you try do anything with project that doesn't exist then error will occur..
```
$ pm list bar
Project *bar* doesn't exist: Error
```

So now for `bar` project you can do similar things..
```
$ pm init bar
Alias managment for project *bar* initialized.
Project *bar* set.
```

First add path to project
```
$ pm add-path BASE=/var/www/projects/bar
(bar) Path added: BASE=/var/www/projects/bar
```

Next add quick jump to it
```
$ pm add cd='cd {{BASE}}'
Alias created: bar.cd='cd {{BASE}}' ('cd /var/www/projects/bar')
```

As alias-manager is aware of project we working on it's know `BASE` refer to project `bar` not `foo`.

Little more complicated example. We'll reuse our alias to work with another alias.
```
$ pm add pull='[[cd]]; git pull'
Alias created: bar.cd ()
```

List all projects
```
$ pm list-projects
Projects:
 foo
```


List of all avaiable commands
```
pm init <project_name> # Init project
pm destroy <project_name> # Remove project with all aliases and vars (ask [y/n])
pm list # list all projects
pm set <project_name> # Switch to another project
pm list <project_name> # List all project aliases and variables
pm list <project_name> alias # List all project aliases ONLY
pm list <project_name> vars # List all project variables ONLY
pm add <alias_name> # Add local alias
pm rename <alias_name> # Rename existing alias
pm remove <alias_name> # Remove alias from current project  (ask [y/n])
pm add-remote <alias_name> # Add alias on your remote machine
pm remove-remote <alias_name> # Remove alias on your remote machine  (ask [y/n])
```

This will list you all avaiable aliases (without vars) in your <project_name>. Same as in bash completion for all your  system commands and aliases.
```
$ <project_name>.[2xTAB]
```

If you have some other stuff to do on another box with the same project you can set something like this
```
$ pm add-remote --box=foo-box2 dostuff='cd /path/to/somewere && git branch'
```
.. where `foo-box2` needs to be define in you `~/.ssh/config` file.


#### Features
 * Very easy usage as normal aliases and shell variables
 * Syncing aliases
 * Support remote alias across different hosts
