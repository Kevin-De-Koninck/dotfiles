import cProfile
import pstats
import tempfile
from functools import wraps
from time import time


def time_me(f):
    @wraps(f)
    def wrap(*args, **kw):
        ts = time()
        result = f(*args, **kw)
        te = time()
        print("[TIMING] Function '{}' took: {} s".format(f.__name__, te-ts))
        return result
    return wrap


def profile_me(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        file = tempfile.mktemp()
        profiler = cProfile.Profile()
        result = profiler.runcall(f, *args, **kwargs)
        profiler.dump_stats(file)
        metrics = pstats.Stats(file)
        metrics.strip_dirs().sort_stats('cumulative').print_stats(100)
        return result
    return wrap
    
