#!/usr/bin/env bash

AWS_ROLE_ARN="arn:aws:iam::838564864622:role/Developers"
AWS_PROFILE="Playground"
AWS_SESS_NAME="ecsession"

AWS_EXE=$(command -v aws 2> /dev/null)
JQ_EXE=$(command -v jq 2> /dev/null)

if [ -z "${AWS_EXE}" ]; then
  echo "aws not found"
  exit 1
fi

if [ -z "${JQ_EXE}" ]; then
  echo "jq not found"
  exit 1
fi

aws sts assume-role \
--role-arn ${AWS_ROLE_ARN} \
--role-session-name ${AWS_SESS_NAME} \
--profile ${AWS_PROFILE} \
--duration-seconds 3600 > session_token

ACCESS_KEY=$(cat session_token | jq '.Credentials.AccessKeyId')
SECRET_KEY=$(cat session_token | jq '.Credentials.SecretAccessKey')
SESS_TOKEN=$(cat session_token | jq '.Credentials.SessionToken')

cat << EOF > ./terraform/terraform.tfvars
aws_access_key = ${ACCESS_KEY}
aws_secret_key = ${SECRET_KEY}
aws_profile = "${AWS_PROFILE}"
session_token = ${SESS_TOKEN}

EOF
