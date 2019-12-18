#!/usr/bin/env bash

AWS_ROLE_ARN="arn:aws:iam::838564864622:role/Developers"
AWS_PROFILE="Playground"
AWS_SESS_NAME="ecsession"

aws sts assume-role \
--role-arn ${AWS_ROLE_ARN} \
--role-session-name ${AWS_SESS_NAME} \
--profile ${AWS_PROFILE} \
--duration-seconds 3600 > session_token
