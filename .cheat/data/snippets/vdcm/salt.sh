scp -r kdekonin@10.50.201.11:/home/kdekonin/git-repositories/SaltConfig/* /srv/ # Copy salt to device locally

sudo salt 'vdcm-10-50*' cmd.run 'command here'                                  # Execute a command on all vdcm's (as salt_install user)
cd /srv/.git/objects/ && sudo chown -R jenkins_gpk:eng * && cd -                # if an error when pulling on salt server

scp -r kdekonin@10.50.201.11:/home/kdekonin/git-repositories/SaltConfig/* /srv/ # Copy salt to device locally
salt-call state.apply -l debug mux.10-0 --local                                 # OR just one thingy: salt-call state.apply routes --local

salt-call state.apply mux.8-0 		                                              # general version
salt-call state.apply mux.7-0-0-98	                                            # Specefic version

# Reinstall salt on a minion
yum remove -y salt salt-minion
scp salt_install@10.50.232.186:/srv/scripts/install_salt.sh /tmp/
/tmp/install_salt.sh -P -A 10.50.232.186 -i $(cat /etc/salt/minion_id) stable 2017.7.4
