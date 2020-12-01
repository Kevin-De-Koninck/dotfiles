# Via command:
python -m cProfile -s cumtime <script>

# Via code:
import cProfile

def do_cprofile(func):
    def profiled_func(*args, **kwargs):
        profile = cProfile.Profile()
        try:
            profile.enable()
            result = func(*args, **kwargs)
            profile.disable()
            return result
        finally:
            profile.print_stats(sort='cumtime')
    return profiled_func
    
@do_cprofile
def test_this():
  return
