# IAM role

Go To service IAM -> role -> create role.
AWS service -> Lambda.
Enable 'AmazonEC2FullAccess' policy.
Skip tags.
Role name: ' lambda_start_stop_ec2' -> description: 'Role to let a Lambda function start and stop EC2 instances.' -> save.

# Lambda function

Create function -> Author from scratch -> name: 'AutoStopEC2InstancesByTag' -> Runtime: 'Python 2.7'.
Unfold permissions and click on IAM role -> Use an existing role: 'lambda_start_stop_ec2'. -> Create function.
code:

```
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    filters = [{
            'Name': 'tag:AutoOff',
            'Values': ['True']
        },
        {
            'Name': 'instance-state-name', 
            'Values': ['running']
        }
    ]
    instances = ec2.instances.filter(Filters=filters)
    RunningInstances = [instance.id for instance in instances]

    if len(RunningInstances) > 0:
        shuttingDown = ec2.instances.filter(InstanceIds=RunningInstances).stop()
        print shuttingDown
```

Basic settings -> Timeout: 10s.
Save lambda.

# Cloudwatch

Events -> Rules -> Create rule.
Select schedule -> Cron expression: 0 17 * * ? * (every day at 18h in belgium) Add target -> lambda function: 'AutoStopEC2InstancesByTag'. Name: 'AutoStopEC2InstancesOnTag' -> Description: 'Automatically stop all instances that are tagged 'AutoOff' with value 'True' at 17h UTC time.' -> state: Enabled.

# EC2 instances

Add tag: 'AutoOff' with value 'False'

