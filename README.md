# terraform-example
Terraform example.


# pre-requisite
tfenv>=2.1.0

direnv>=2.27.0

pip install ec2instanceconnectcli

# setup
$direnv edit .

$tfenv install 0.14.5

$tfenv use 0.14.5

# to connect instance.
make connect-opsrv