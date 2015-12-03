# alias-manager

> For now this is only initial notes for future development..

Manage your projects using aliases

Imagine you have 2 web projects `alpha` and `delta`. For each one you have common task to do but in different way. Like each of this projects lives in different server. You obiously set ssh keys with agent and `~/.ssh/config` so you can quckly ssh to them with `ssh alpha` and `ssh delta`. Both projects lives in different directories, `alpha` in `/var/www/vhosts/alpha.areo/publich_html/` and `delata` in `/var/www/delta/app/` addicinally `delta` have files directory inside project path under `sites/default/files/` and `alpha` doesn't have it but have special `cofnig` file you editing very often. 

OK so how *alias-manager* can help me?

You can simply set following aliases on your host and remote machine (`am` is *alias-manager* command):
```bash
john@box $ am init alpha
Alias managment for project *alpha* initialized.
john@box $ am add alpha.ssh='ssh alpha'                               # yeah nothing special with simple alias I can do it as well..
alpha: Alias created

john@box $ am add alpha --var BASE_PATH=/var/www/vhosts/alpha.areo    # this will be remember for whole project
alpha: Alias project variable created

john@box $ am add --comment='CD to main publich_html/' --remote alpha.public='cd $BASE_PATH/public_html/' # it will create this alias for you on remote (alpha) host
alpha: Remote alias created: CD to main publich_html/

john@box $ am add --remote alpha.files='cd $BASE_PATH/public_html/sites/default/files'
alpha: Remote alias created

john@box $ am list alpha
Aliases for *alpha* project
 ssh='ssh alpha'
 publich='cd $BASE_PATH/public_html/' (on alpha box): CD to main publich_html/
 files='cd $BASE_PATH/public_html/sites/default/files' (on alpha box)
 
Aliases variables
  VAR=......
  VAR=.....
```
if you have some other stuff to do on another box with the same project you can set something like this
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
