#!/bin/bash

# EDIT THESE VARIABLES
keystore=keystore.txt #keystore file
password="PASSWORD" #password to keystore
myICXaddress="ICX_ADDRESS" #your icx address

#
# DO NOT TOUCH BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING
#
endpoint="https://ctz.solidwallet.io/api/v3" #run by ICON Foundation
myPREPaddress="hx5b97bbec2e555289351806103833a465b7fbbd47"

#ISCore JSON templates
queryIScore=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_call",
    "params": {
        "to": "cx0000000000000000000000000000000000000000",
        "dataType": "call",
        "data": {
            "method": "queryIScore",
            "params": {
                "address": "$myICXaddress"
            }
        }
    }
}
EOF
)

claimIScore=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_sendTransaction",
    "params": {
	"version": "0x3",
	"to": "cx0000000000000000000000000000000000000000",
	"nid": "0x1",
        "nonce": "0x0",
        "value": "0x0",
        "dataType": "call",
        "data": {
            "method": "claimIScore"
        }
    }
}
EOF
)

#getStake JSON template
getStake=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_call",
    "params": {
        "to": "cx0000000000000000000000000000000000000000",
        "dataType": "call",
        "data": {
            "method": "getStake",
            "params": {
                "address": "$myICXaddress"
            }
        }
    }
}
EOF
)

#get the value of IScore
echo $queryIScore > temp.json
response=$(tbears call temp.json -u $endpoint)
response="${response##*\"iscore\": \"}"
response="${response%%\",*}"

if [ "$response" == "0x0" ]; then
    echo "Nothing to claim ... exiting."
    rm temp.json
else
    #claim IScore
    echo $claimIScore > temp.json
    tbears sendtx temp.json -u $endpoint -k $keystore -p $password
    sleep 5 #wait for TX to go through

    #get balance available for staking
    response="$(tbears balance -u $endpoint $myICXaddress)"
    response="${response##*balance in hex: 0x}"
    response="${response%%[[:space:]]*}" #contains available balance in hex
    response="$(echo $response | tr '[:lower:]' '[:upper:]')" #convert to uppercase so bc can work with it
    value="$(echo "obase=16;ibase=16; $response-29A2241AF62C0000" | bc)" #subtract 3 ICX to keep unstaked

    #add balance already staking
    echo $getStake > temp.json
    response="$(tbears call temp.json -u $endpoint)"
    response="${response##*\"stake\": \"0x}"
    response="${response%%\"*}"
    response="$(echo $response | tr '[:lower:]' '[:upper:]')" #convert to uppercase so bc can work with it
    value="$(echo "obase=16;ibase=16; $response+$value" | bc)"
    value="$(echo $value | tr '[:upper:]' '[:lower:]')" #convert back to lowercase
    value=0x$value #add 0x prefix

    #setStake JSON template
    setStake=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_sendTransaction",
    "params": {
        "version": "0x3",
        "to": "cx0000000000000000000000000000000000000000",
        "nid": "0x1",
        "nonce": "0x0",
        "value": "0x0",
        "dataType": "call",
        "data": {
            "method": "setStake",
            "params": {
                "value": "$value"
            }
        }
    }
}
EOF
    )

    #stake it all
    echo $setStake > temp.json
    tbears sendtx temp.json -u $endpoint -k $keystore -p $password
    sleep 5 #wait for TX to go through

    #get total voting power
    echo $getStake > temp.json
    response="$(tbears call temp.json -u $endpoint)" #retrieve voting power first
    response="${response##*\"stake\": \"}"
    voting="${response%%\"*}"

    #setStake JSON template
    setDelegation=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_sendTransaction",
    "params": {
        "version": "0x3",
        "to": "cx0000000000000000000000000000000000000000",
        "nid": "0x1",
        "nonce": "0x0",
        "value": "0x0",
        "dataType": "call",
        "data": {
            "method": "setDelegation",
            "params": {
                "delegations": [
                    {
                        "address": "$myPREPaddress",
                        "value": "$voting"
                    }
                ]
            }
        }
    }
}
EOF
    )

    #vote with all
    echo $setDelegation > temp.json
    tbears sendtx temp.json -u $endpoint -k $keystore -p $password
    rm temp.json
fi
