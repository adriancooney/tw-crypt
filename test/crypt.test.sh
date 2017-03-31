#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
crypt=$DIR/../bin/crypt

(
    set -evx

    # Simple encryption decryption
    $crypt --key foo \
        encrypt $DIR/../package.json $DIR/package.json.encrypted

    # Decryption
    $crypt --key foo \
        decrypt $DIR/package.json.encrypted $DIR/package.json.decrypted

    # Compare files
    [[ "$(md5 -q $DIR/package.json.decrypted)" == "$(md5 -q $DIR/../package.json)" ]]

    # Cleanup
    rm $DIR/package.json.encrypted $DIR/package.json.decrypted

    # Using env var
    NODE_CRYPT=foo $crypt \
        encrypt $DIR/../package.json $DIR/package.json.encrypted

    # Decryption
    NODE_CRYPT=foo $crypt \
        decrypt $DIR/package.json.encrypted $DIR/package.json.decrypted

    # Compare files
    [[ "$(md5 -q $DIR/package.json.decrypted)" == "$(md5 -q $DIR/../package.json)" ]]

    # Cleanup
    rm $DIR/package.json.encrypted $DIR/package.json.decrypted
)

if (( $? != 0)); then
    echo "Tests failed"
else
    echo "Tests passed"
fi