# cat test.ini
# [general]
# authentication_method = local
#
#[radius]
#ip =

import ConfigParser
conf = ConfigParser.ConfigParser()
conf.read("authentication.ini")
conf.get('general', 'authentication_method')  # 'local'
conf.get('radius', 'ip')  # ''
conf.set('radius', 'ip', '1.2.3.4')
with open('test.ini', 'wb') as configfile:
    conf.write(configfile)
