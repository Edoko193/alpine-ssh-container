#!/bin/bash

# If we dont do that ssh service crashes because of openrc run policy.
touch /run/openrc/softlevel
rc-service sshd restart
# Drop to the bash shell
/bin/bash
