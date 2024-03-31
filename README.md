# terraform-example
業務で使う前に色々と検証するためのアレ

# requirements
make(GNU)>=3.81

jq>=1.6

tfenv>=2.1.0

direnv>=2.27.0

# python requirements
python>=3.8

ec2instanceconnectcli(pip)

# setup
$direnv edit .

$tfenv install 0.14.5

$tfenv use 0.14.5

# to connect instance.
make connect-opsrv
