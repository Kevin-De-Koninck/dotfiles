# this is usefull to, for example, open and close a connection
class UserDB:
    def __init__(self, allow_create=True):
        dbpath = os.path.join(VDCM_Constants.Paths.INSTALL_CONFIG_PATH, "users.db")
        db_exists = os.path.exists(dbpath)
        if not (db_exists or allow_create):
            self.db = None
            return
        db = bsddb.hashopen(dbpath, 'c', 0640)
        if not db_exists:  # only do this for newly created db
            os.chown(dbpath, 0, env.dcm_gid)
            # umask might have interfered...
            os.chmod(dbpath, 0640)
        self.db = db

    def __enter__(self):
        return self.db

    def __exit__(self, _type, value, tb):
        if self.db is not None:
            self.db.close()
            
# USAGE:
with UserDB(allow_create=False) as db:      # db will contain self.db (see __enter__)
    .... # no need to use the open or close function now
