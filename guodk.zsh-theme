
# gdate for macOS
# REF: https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal
if [[ "$OSTYPE" == "darwin"* ]]; then
    {
        gdate
    } || {
        echo "\n$fg_bold[yellow]passsion.zsh-theme depends on cmd [gdate] to get current time in milliseconds$reset_color"
        echo "$fg_bold[yellow][gdate] is not installed by default in macOS$reset_color"
        echo "$fg_bold[yellow]to get [gdate] by running:$reset_color"
        echo "$fg_bold[green]brew install coreutils;$reset_color";
        echo "$fg_bold[yellow]\nREF: https://github.com/ChesterYue/ohmyzsh-theme-passion#macos\n$reset_color"
    }
fi


# time
function real_time() {
    local color="%{$fg_no_bold[red]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    local time="[$(date +%H:%M:%S)]";
    local color_reset="%{$reset_color%}";
    echo "${color}${time}${color_reset}";
}

# login_info
function login_info() {
    local color="%{$fg_no_bold[red]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    local ip
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        ip="$(ifconfig | grep ^eth1 -A 1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        ip="$(ifconfig | grep ^en1 -A 4 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown.
    fi
    local color_reset="%{$reset_color%}";
    echo "${color}[%n@${ip}]${color_reset}";
}


# directory
function directory() {
    local color="%{$fg_no_bold[red]%}";
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local pwd_length=20
#    local newPWD="${PWD/#$HOME/~}"
#    if [ $(echo -n $newPWD | wc -c | tr -d " ") -gt $pwd_length ]
#    then newPWD="$(echo -n $newPWD | awk -F '/' '{
#    print "../" $(NF-1) "/" $(NF)}')"
#    else newPWD="$(echo -n $newPWD)"
#    fi
    local newPWD="[${PWD/#$HOME/~}]"
    if [ $(echo -n $newPWD | wc -c | tr -d " ") -gt $pwd_length ]
    then if [ $(echo -n $newPWD | wc -c | tr -d " ") -gt 40 ]
        then newPWD="$(echo -n "[..${newPWD: -40}")
"
        else newPWD="$(echo -n $newPWD)
"
        fi
    else newPWD="$(echo -n $newPWD)"
    fi
    
    local color_reset="%{$reset_color%}";
    echo "${color}${newPWD}${color_reset}";
}


# git
ZSH_THEME_GIT_PROMPT_PREFIX="<"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}>"
ZSH_THEME_GIT_PROMPT_CLEAN=">"

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function git_status() {
    echo "${GIT_STATUS}"
}


# command
function update_command_status() {
    local arrow="%{$fg_bold[red]%}❱❱";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
#    COMMAND_RESULT=$1;
#    export COMMAND_RESULT=$COMMAND_RESULT
#    if $COMMAND_RESULT;
#    then
#        arrow="%{$fg_bold[black]%}❱❱❱";
#    else
#        arrow="%{$fg_bold[red]%}❱❱❱";
#    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}


# output command execute after
#output_command_execute_after() {
#    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
#    then
#        return 1;
#    fi
#
#    # cmd
#    local cmd="${$(fc -l | tail -1)#*  }";
#    local color_cmd="";
#    if $1;
#    then
#        color_cmd="$fg_no_bold[green]";
#    else
#        color_cmd="$fg_bold[red]";
#    fi
#    local color_reset="$reset_color";
#    cmd="${color_cmd}${cmd}${color_reset}"
#
#    # time
#    local time="[$(date +%H:%M:%S)]"
#    local color_time="$fg_no_bold[cyan]";
#    time="${color_time}${time}${color_reset}";
#
#    # cost
#    local time_end="$(current_time_millis)";
#    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}");
#    COMMAND_TIME_BEIGIN="-20200325"
#    local length_cost=${#cost};
#    if [ "$length_cost" = "4" ];
#    then
#        cost="0${cost}"
#    fi
#    cost="[cost ${cost}s]"
#    local color_cost="$fg_no_bold[cyan]";
#    cost="${color_cost}${cost}${color_reset}";
#
#    echo -e "${time} ${cost} ${cmd}";
#    echo -e "";
#}


# command execute before
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
#preexec() {
#    COMMAND_TIME_BEIGIN="$(current_time_millis)";
#}
#
#current_time_millis() {
#    local time_millis;
#    if [[ "$OSTYPE" == "linux-gnu" ]]; then
#        # Linux
#        time_millis="$(date +%s.%3N)";
#    elif [[ "$OSTYPE" == "darwin"* ]]; then
#        # macOS
#        time_millis="$(gdate +%s.%3N)";
#    elif [[ "$OSTYPE" == "cygwin" ]]; then
#        # POSIX compatibility layer and Linux environment emulation for Windows
#    elif [[ "$OSTYPE" == "msys" ]]; then
#        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#    elif [[ "$OSTYPE" == "win32" ]]; then
#        # I'm not sure this can happen.
#    elif [[ "$OSTYPE" == "freebsd"* ]]; then
#        # ...
#    else
#        # Unknown.
#    fi
#    echo $time_millis;
#}


# command execute after
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
#precmd() {
#    # last_cmd
#    local last_cmd_return_code=$?;
#    local last_cmd_result=true;
#    if [ "$last_cmd_return_code" = "0" ];
#    then
#        last_cmd_result=true;
#    else
#        last_cmd_result=false;
#    fi
#
#    # update_git_status
#    update_git_status;
#
#    # update_command_status
#    update_command_status $last_cmd_result;
#
#    # output command execute after
##    output_command_execute_after $last_cmd_result;
#}


# set option
#setopt PROMPT_SUBST;


# timer
#REF: https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
TMOUT=1;
TRAPALRM() {
    # $(git_prompt_info) cost too much time which will raise stutters when inputting. so we need to disable it in this occurence.
    # if [ "$WIDGET" != "expand-or-complete" ] && [ "$WIDGET" != "self-insert" ] && [ "$WIDGET" != "backward-delete-char" ]; then
    # black list will not enum it completely. even some pipe broken will appear.
    # so we just put a white list here.
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}


# prompt
# PROMPT='$(real_time) $(login_info) $(directory) $(git_status)$(command_status) ';
PROMPT='$(real_time) $(git_status)$(directory) $(command_status) '