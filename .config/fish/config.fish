if status is-interactive
    # Commands to run in interactive sessions can go here
    export PATH="$PATH"":/home/hege/.local/bin"

    setxkbmap -layout us,fi -option grp:rctrl_toggle
end
