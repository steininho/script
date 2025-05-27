# Update userconfig
alias upducfg='/mp/software/usercfg/upd_usercfg.sh'

# Print server status
alias st='uptime; echo ..; dmesg -T | tail; echo ..; free -m; echo ..; ps aux --sort=-pcpu | head -n 10'

# Switch to root
alias root='sudo su -'

# Clear display
alias c='clear'

# Go up one dir
alias ..='cd ..'

# Go back to the previous dir
alias cd-='cd -'

# Print date and time
alias dt='date "+%Y-%m-%d %H:%M"'

# List open ports
alias ports='ss -tulpn'

# List all files (detailed), including hidden files
alias l.='ls -la . --color=auto'

# List files sorted by modify time, most recent at the bottom
alias ltr='ls -ltr'

# Count number of files in current dir
alias count='find . -type f | wc -l'

# Grep history
alias gh='history|grep'

# Grep ps
alias gps='ps -ef | grep'

# Lun
alias lun='ls -ld /sys/block/sd*/device'

# Du maxdepth
alias du.='du -h --max-depth 1'

# Parted
part() {
  if [[ -z "$1" ]]; then
    echo "  Supply disk as parameter; eg: part /dev/sdX"
  else
    sudo parted -a optimal $1 mklabel gpt mkpart primary 0% 100%
  fi
}
