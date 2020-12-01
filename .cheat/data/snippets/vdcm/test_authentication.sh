# Test user
cd /opt/cisco/embgui/lib/python2.7/site-packages
python -c "from pam import pam; print 'Success' if pam().authenticate('USER', 'PASS', 'vdcm-iiop') else 'Fail'"
