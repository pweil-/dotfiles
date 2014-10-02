setupMacEnv() {
	alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    # MacPorts Installer addition on 2013-10-23_at_18:08:49: adding an appropriate PATH variable for use with MacPorts.
    # Finished adapting your PATH environment variable for use with MacPorts.
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
}

setupAliases () {
	###
	# shell command aliases
	###
	alias ll='ls -al'
	alias l='ls'

	###
	# editing aliases
	###
	alias profile='vi ~/.profile'
	alias sop="source ~/.profile"


	alias vi=vim

	alias vimrc='vi ~/.vimrc'

	alias cb="cd ~/codebase"
	alias svns="svn status"

	alias ij="open -a /Applications/Intellij\ Idea\ 13.app"
}

devTwoBook () {
	# mamp php version
	export PATH=/Applications/MAMP/bin/php/php5.3.27/bin:$PATH
	export PATH=/Applications/MAMP/Library/bin:$PATH


	alias phpini='vi /Applications/MAMP/bin/php/php5.3.27/conf/php.ini'
	alias vhosts='vi /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'
	alias httpdc='vi /Applications/MAMP/conf/apache/httpd.conf'
	alias nginxc='vi /usr/local/etc/nginx/nginx.conf'
	alias fpmc='sudo vi /etc/php-fpm.conf'

	###
	# work aliases
	###
	alias start="sudo /Applications/MAMP/bin/apache2/bin/apachectl -f /Applications/MAMP/conf/apache/httpd.conf -k start; /Applications/MAMP/bin/startMysql.sh"

	alias stop="sudo /Applications/MAMP/bin/apache2/bin/apachectl stop; /Applications/MAMP/bin/stopMysql.sh"

	alias db="mysql -u root -proot"

	alias cb="cd ~/codebase/twobook_git/twobook_naansense"
	alias cbb="cd ~/codebase/twobook_naansense/branches"
	alias cbg="cd ~/codebase/git/dotfiles"

	alias phplog="tail -f /Applications/MAMP/logs/php_error.log"

	alias nglog="tail -f /usr/local/var/log/nginx/error.log"

	alias fpm="sudo php-fpm -c /Applications/MAMP/bin/php/php5.3.27/conf/php.ini"
	alias rnginx="sudo nginx -s reload"

	alias tbv="cb; cd etc/vagrant-prod"
	alias tbu="tbv; vagrant resume"
	alias tbd="tbv; vagrant suspend"
	alias tbb="tbv; vagrant ssh beanstalk"
	alias tbdb="tbv; vagrant ssh db"
	alias tbw="tbv; vagrant ssh web-1"
	alias tbn="tbv; vagrant ssh lb"

	#Git stuff
	alias restash="cb; git checkout etc/vagrant-prod/Vagrantfile src/application/config/database.php src/scripts/server_setup/setup/nginx/development/default.conf"
	alias unstash="git stash apply stash@{0}"
	alias gu="restash; git checkout master; git svn rebase; unstash"

}

gitSetup () {
	alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
}

devGoLangTutorial () {
	export GOROOT=/usr/local/go
	export GOPATH=/Users/paul/codebase/Go
	export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
}

devOpenShift () {
    export OS_ROOT=/home/pweil/codebase/openshiftgo/src/github.com/openshift/origin
    export OS_BIN=${OS_ROOT}/_output/go/bin
    export GOPATH=${OS_ROOT}/Godeps/_workspace:/home/pweil/codebase/openshiftgo
	export PATH=$PATH:~/bin:$GOPATH/bin:/usr/local/go/bin:${OS_BIN}

    ###
    # Making the decision to always run OS via aliases in the hack directory for consistency even though it's on the path
    ###
	alias cbo='cd ${OS_ROOT}'
	alias cboh="cbo; cd hack"
	alias osrb='cbo; make clean; make; cd hack'

    # lifecycle
	alias osk="ps -ef | grep 'openshift start' | grep -v grep | awk '{ print $2 }' | xargs kill"
	alias oss="cboh; openshift start 1>&2"
	alias osc="cboh; rm -Rf openshift.local.*; rm -Rf /tmp/openshift.local.*"
	alias os="openshift"


	alias osdtt="cboh; ./test-deploy.sh 192.168.1.139 8080 1"
}

#########################
# Other utility functions
#########################
fixAppleFn() {
    echo "You must sudo su and run the following command:"
    echo "echo 0 > /sys/module/hid_apple/parameters/fnmode"
}

#setupMacEnv
setupAliases
gitSetup

###
# setup the correct dev env here
###
#devTwoBook
#devGoLangTutorial
devOpenShift



