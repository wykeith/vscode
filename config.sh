#!/bin/bash

# gets the line number in this script of the "PAYLOAD:" line
echoPayloadLinenum() {
  echo $(grep --text --line-number '^PAYLOAD:$' $0 | cut -d ':' -f 1)
}

# prints only the payload
echoPayload() {
  local payload_linenum=$(echoPayloadLinenum)
  local crypted_linenum=$((payload_linenum + 1))
  
  tail -n +$crypted_linenum $0
}

# prints this script without the payload
echoSelf() {
  payload_linenum=$(echoPayloadLinenum)

  head -n $payload_linenum $0
}

# echoes the decrypted payload after user types in password
echoDecryptedPayload() {
  PAYLOAD=$(echoPayload)
  echo "$PAYLOAD" | gpg -d
}

# executes the decrypted payload after user types in password
runDecryptedPayload() {
  gpg -o decrypt_config.sh -d $0
  bash ./decrypt_config.sh
  #SCRIPT=$(echoDecryptedPayload)
  #echo "$SCRIPT" | sh -
}

if [[ $* == *--encrypt* ]]; then
  echo "write payload"
  # clear payload
  echo "$(echoSelf)" > $0
  gpg -o dummy.asc -c -a $2
  cat dummy.asc >> $0
  cat "}" >> $0
  rm dummy.asc
else
  runDecryptedPayload
fi

wrapper (){
PAYLOAD:
-----BEGIN PGP MESSAGE-----

jA0ECQMCyQFl+FIEnej40sD/Aek3zLeEzEbExeqxHs3LafeApck2IEWMmmOSt2F1
plRaJ4/PgNhiQkTYIxw0zwDhec/JqRG/CHkmPWoHr8vvQkpwxhDSwdfmEi0Dx85B
gpHBBXWRrYgFfq7UGmL5SdC5pbvgRGWtjm9t5LLqa0DG695t3vfm5QdaJbfiywxQ
m5nfI2qhONe8HK57k+QAgMzwwdcJR74RWYnpJJUjsJxVAnzBDzR72uaa7n4svEfO
uAHEY6aBBvMUt49P1Y0visPiemI4Fkl1hk5JF7ppe3zWTMda0hJqTKf9LC+ptKSl
4oJjMczlCdrY36qpQSMmfMyVXFnwDSrrEy5FdJL4ZhOA8B01dk4af8REKEiG9D64
RlRCqbKBeaKjOpzT9XHh+wqCKtg/vVd4lWcUjJqnl1L2l4eTBI9Rh89+lesvvOeC
lMVPMMNf9+NwuE771z2o+ut00dkRNrTHq9AekR5DVMlg2r+RWuc1bHprGz0CX04s
gqYOD4H29l+i2+tou3+ZrTBkjwED+R8a2w7q5XI6LF94byBgE6KCFSc0ZhY7DK4+
2OaCA0+ARQzjiyYYUnMIKOQfV9SqY6GQBeJ3dov21D5R
=jTWI
-----END PGP MESSAGE-----
}