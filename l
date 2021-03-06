#!/usr/bin/env python
#
# See also: http://alestic.com/2014/11/aws-lambda-shell
#
# Usage:
#   export LAMBDASH_FUNCTION=[FUNCTIONNAME]
#   lambdash [SHELLCOMMAND]
# 
from __future__ import print_function
import boto3, json, sys, os, base64

client = boto3.client('lambda', region_name='us-east-1')
response = client.invoke(
    InvocationType='RequestResponse',
    FunctionName='lambdash',
    Payload='{"command":'+json.dumps(" ".join(sys.argv[1:]))+'}')
result = json.load(response['Payload'])

os.write(sys.stdout.fileno(), base64.b64decode(result['stdout']))
os.write(sys.stderr.fileno(), base64.b64decode(result['stderr']))

if result['error'] and 'code' in result['error']:
    exit(result['error']['code'])
exit(0)
