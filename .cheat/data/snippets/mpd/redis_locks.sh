redis-cli -h 10.50.203.222 -p 6379 -n 10
# Then:
  keys *        # Show all keys
  flushdb       # Flush all
  DEL <keyname> # Delete specific key

