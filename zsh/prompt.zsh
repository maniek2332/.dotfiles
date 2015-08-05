function precmd
{
    # The following 9 lines of code comes directly from Phil!'s ZSH prompt
    # http://aperiodic.net/phil/prompt/
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    local PROMPTSIZE=${#${(%):--- %D{%R.%S %a %b %d %Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    PR_BRANCH=""
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1
    then
        GIT_BRANCH=$(git symbolic-ref -q --short HEAD)
        if [[ $? > 0 ]]
        then
            GIT_BRANCH="dHEAD"
        fi
        if [[ -n ${GIT_BRANCH} ]]
        then
            PR_BRANCH="${PR_BOLD_BLUE}[${GIT_BRANCH}]${PR_WHITE}"
        fi
    fi
    

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
	(( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi

    # set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        PR_SCREEN=" ${PR_WHITE}S:${PR_BOLD_WHITE}${WINDOW}"
    else
        PR_SCREEN=""
    fi

    # check if jobs are executing
    if [[ $(jobs | wc -l) -gt 0 ]]; then
        PR_JOBS=" J:${PR_BOLD_WHITE}%j"
    else
        PR_JOBS=""
    fi

    # check for virtualenv
    if [[ -n "$VIRTUAL_ENV" ]]
    then
        VENV_NAME=`basename "$VIRTUAL_ENV"`
        PR_VIRTUALENV="${PR_CYAN}[${VENV_NAME}]"
    else
        PR_VIRTUALENV=""
    fi

    # check if root
    if [[ $UID = 0 ]]
    then
        PR_NAME="${PR_BOLD_RED}%n${HOST_BCOLOR}@%m"
    else
        PR_NAME="${HOST_BCOLOR}%n@%m"
    fi

    # check if remote
    #if [[ -n $SSH_CONNECTION ]]
    #then
        #PR_SSH_HOST=" ${PR_BOLD_YELLOW}["`hostname`"]"
    #else
        #PR_SSH_HOST=""
    #fi

    PRECMD_PROMPT="${PR_BOLD_BLACK}>${HOST_COLOR}>${HOST_BCOLOR}>"
    #if [ $TERM = "xterm" ]
    #then
        #echo -ne "\033]12;White\007"
    #fi
} 

function zle-keymap-select {
    if [ "$KEYMAP" = "vicmd" ]
    then
        PRECMD_PROMPT="${HOST_BCOLOR}CMD"
        #if [ $TERM = "xterm" ]
        #then
            #echo -ne "\033]12;Yellow\007"
        #fi
    else
        PRECMD_PROMPT="${PR_BOLD_BLACK}>${HOST_COLOR}>${HOST_BCOLOR}>"
        #if [ $TERM = "xterm" ]
        #then
            #echo -ne "\033]12;White\007"
        #fi
    fi
    zle reset-prompt
}

zle -N zle-keymap-select

function pre-accept-line
{
    zle reset-prompt
    zle accept-line
}

zle -N pre-accept-line

function setprompt
{
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors

    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi

    if [ -z $HOST_PROMPT_COLOR ]
    then
        export HOST_PROMPT_COLOR="white"
    fi

    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
        eval HOST_COLOR='%{$fg_no_bold[${(L)HOST_PROMPT_COLOR}]%}'
        eval HOST_BCOLOR='%{$fg_bold[${(L)HOST_PROMPT_COLOR}]%}'
    done

    # default precmd prompt
    PRECMD_PROMPT="${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>"

    # PROMPT
    PROMPT='${PR_BOLD_BLACK}<${PR_RED}<${PR_BOLD_RED}<${PR_BOLD_WHITE} \
[%*]${PR_SSH_HOST} ${PR_NAME} ${PR_BOLD_WHITE}%${PR_PWDLEN}<...<%~%<< \
${PR_BRANCH}${PR_VIRTUALENV}${PR_SCREEN}${PR_BOLD_BLUE}${PR_JOBS}${PR_RED}%(?.. E:${PR_BOLD_WHITE}%?) \

${PRECMD_PROMPT}\
%{${reset_color}%} '
}

setprompt

