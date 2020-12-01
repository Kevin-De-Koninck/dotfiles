lsof | grep deleted               # list open files that got deleted but still occupy space
lsof /path                        # List process that has this file open
lsof -i udp:1812                  # List open port: this is radiusd port
