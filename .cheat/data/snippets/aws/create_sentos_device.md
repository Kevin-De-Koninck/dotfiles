Region
Set region in upper right corner. E.g.: London.

EC2
Step 0
Go to Services -> Compute -> EC2.
Click on button: 'Launch instance'.

Step 1: Choose an Amazon Machine Image (AMI)
AWS Marketplace -> filter on Centos -> Choose: CentOS 7 (x86_64) - with Updates HVM

Step 2: Choose an Instance Type
Select 'c5.9xlarge'. This has 72GB RAM and 36 cores. Ideal for transcoding. Plus a 10Gbps network connection.

Step 3: Configure Instance Details
Keep defaults.

Step 4: Add Storage
64 GB and delete on termination

Step 5: Add Tags
(optional) Add as desired.
E.g. key 'User' with value 'kdekonin'.

Step 6: Configure Security Group
Choose existing or create a new one. Remember that:

172.31.0.0/16 is the internal network range
173.38.128.0/17 is the external network range
64.103.40.0/21 is the cisco network
An example:

HTTP    TCP     80      173.38.128.0/17     HTTP external EC2
HTTP    TCP     80      64.103.40.0/21      HTTP external cisco
HTTP    TCP     80      172.31.0.0/16       HTTP internal EC2
SSH     TCP     22      172.31.0.0/16       SSH internal EC2
SSH     TCP     22      173.38.128.0/17     SSH external EC2
SSH     TCP     22      64.103.40.0/21      SSH external Cisco
Step 7
Click on your instance and give it a name.

Elastic IP
By default, the instance gets a public IP automatically assigned. Thus it will change after each reboot. To mittigate this, we will use an elastic IP.
An elastic IP is a static IP that you can assign to an instance.

Go to Services -> compute -> EC2 -> network and security -> Elastic IPs.

Click on 'Allocate new address' -> 'Allocate' -> 'Close'.

Give the Allocated IP a name. Then select it -> Actions -> Associate address.
Here chose your device that you've named in step 7.

Make root accessible via SSH
```
ssh <elastic_ip>
cd .ssh
sudo bash
cp authorized_keys /root/.ssh/
```
