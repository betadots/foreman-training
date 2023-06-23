for line in $(find /usr/share/foreman/app/views/unattended/ -type f); do grep -o host_param\(.*\) $line | awk '{ print $1 }'; done | cut -d "'" -f2 | sort | uniq
