./run.py 10.50.234.131 --noreboot --config=SW --script=rt_vDCM_ConfigureScript_authentication --action=TestCase2_userAuthentication_local
./runtillerror.sh ./run.py 10.50.234.74 --script rt_vDCM_TSBackupTimings

# LISA REGRESSION TEST IN AWS
# https://wiki.cisco.com/display/DCMLAB/Testing+in+AWS

cd /users/kdekonin/NoBackupDir/DCM.git                                          # copy dcm_script to AWSDEV (on aurora)
tar -zcf DCM_SCRIPT.tar.gz DCM_SCRIPT
scp DCM_SCRIPT.tar.gz rtawsdev-testserver:/home/centos/kdekonin

ssh rtawsdev-testserver                                                         # log in to test server

cd /home/centos/kdekonin                                                        # unpack your files and enter the folder
tar -zxf DCM_SCRIPT.tar.gz
rm -f DCM_SCRIPT.tar.gz
cd DCM_SCRIPT

"10.0.10.203": {                                                                # Add this to device_information.json  (assuming you have device 10.0.10.205 reserved in LISA)
  "product_type": "vDCM",
  "capabilities": "LocAWS; SW"
},

./run.py 10.0.10.203 --add_packages vDCM:vdcm-9.0.0-89 --config="LocAWS;SW" --logs --script=vDCM_ConfigureScript_part2 --action=TestCase36

ssh -i ~/.ssh/id_rsa_dcm-script.pem 10.0.10.203                                 # to ssh to the device from the testserver itself
