
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# ============================================
#  Prompt: cabeçalho contextual + prompt limpo
# ============================================

# ---- Cabeçalho user@host (uma vez + após clear)
__print_header() {
    echo -e "\033[01;32m${debian_chroot:+($debian_chroot)}$USER@$HOSTNAME\033[00m"
}

# Imprime só em shells interativos
case $- in
    *i*) __print_header ;;
esac

# Reimprime após o comando clear
clear() {
    command clear
    __print_header
}

# Ctrl+L também reimprime o cabeçalho
bind -x '"\C-l": command clear; __print_header' 2>/dev/null

# Carrega a função __git_ps1 (se existir)
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
    . /usr/lib/git-core/git-sh-prompt
fi

# Configurações do __git_ps1
GIT_PS1_SHOWDIRTYSTATE=1      # * = modificado, + = staged
GIT_PS1_SHOWUNTRACKEDFILES=1  # % = arquivos não rastreados
GIT_PS1_SHOWUPSTREAM=auto     # < atrás, > à frente, <> divergiu, = sincronizado

__my_git_ps1() {
    local out
    out=$(__git_ps1 " [  %s ]")
    [ -z "$out" ] && return

    # Cores (envoltas em \001/\002 = "largura zero" para o readline)
    local red=$'\001\033[31m\002'
    local green=$'\001\033[32m\002'
    local cyan=$'\001\033[37m\002'
    local magenta=$'\001\033[35m\002'
    local yellow=$'\001\033[37m\002'   # cor base (branch)
    local reset=$'\001\033[00m\002'

    out=${out//\*/${yellow}M${yellow}}          # modificado
    out=${out//+/${green}A${yellow}}            # staged
    out=${out//%/${green}U${yellow}}            # untracked
    out=${out//\$/${magenta} stash${yellow}}    # stash
    out=${out//</${red} behind${yellow}}        # atrás
    out=${out//>/${green} ahead${yellow}}       # à frente
    out=${out//=/${green} 󰓦${yellow}}           # sincronizado

    printf '%s%s%s' "$yellow" "$out" "$reset"
}


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[36m\]\w\[\033[00m\]$(__my_git_ps1)\n\[\033[01;30m\]\$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s)")\n\$ '
fi
unset color_prompt force_color_prompt

