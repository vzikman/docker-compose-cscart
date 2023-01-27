#!/bin/sh
CERTS_PATH="/tmp/certs"

for dom in $CSCART_ADDITIONAL_DOMAINS; do
	addext=$addext"DNS:$dom,"
done
addext="$addext""DNS:$CSCART_DOMAIN"

cat << EOF > $CERTS_PATH/ca.cnf
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
EOF

cat << EOF > $CERTS_PATH/cert.cnf
[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = $addext
subjectKeyIdentifier=hash
EOF

openssl genrsa -out "$CERTS_PATH/ca.key" 4096
openssl req -new -key "$CERTS_PATH/ca.key" -out "$CERTS_PATH/ca.csr" -sha256 -subj '/CN=Local Test Root CA'
openssl x509 -req -days 3650 -in "$CERTS_PATH/ca.csr" -signkey "$CERTS_PATH/ca.key" -sha256 -out "$CERTS_PATH/ca.crt" -extfile "$CERTS_PATH/ca.cnf" -extensions root_ca
openssl genrsa -out "$CERTS_PATH/cert.key" 4096
openssl req -new -key "$CERTS_PATH/cert.key" -out "$CERTS_PATH/cert.csr" -sha256 -subj "/CN=$CSCART_DOMAIN"
openssl x509 -req -days 750 -in "$CERTS_PATH/cert.csr" -sha256 -CA "$CERTS_PATH/ca.crt" -CAkey "$CERTS_PATH/ca.key" -CAcreateserial -out "$CERTS_PATH/cert.crt" -extfile "$CERTS_PATH/cert.cnf" -extensions server

openssl dhparam -dsaparam -out "$CERTS_PATH/dhparam.pem" 4096
