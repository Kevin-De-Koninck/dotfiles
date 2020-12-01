vdcm-configure firewall --disable --now           && \                          # clean stuff on vdcm
vdcm-configure service --stop                     && \
vdcm-configure external-iiop --enable             && \
vdcm-configure service --enable --with-all --now

vdcm-configure clean-settings --restart                                         # Cold reboot (erase all settings)
vdcm-configure --restart                                                        # Warm reboot (only reboot)
vdcm-configure service --restart                                                # Restart all services
