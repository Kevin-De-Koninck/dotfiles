# Remove redis locks
# Go to: go to https://os2master01.os2.ino.krk.synamedialabs.com:8443/console/project/henk-redis/browse/pods/redis-master-1874722804-k24wq?tab=terminal (system/admin)
# Open the terminal and type:
bash
redis-cli
select 10
KEYS *                # Shows all locks
FLUSHDB
KEYS *
