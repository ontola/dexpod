# Generate root certificate
if [ ! -f /usr/share/ca-certificates/dexpods_proxy.crt ]; then
  sudo openssl req -x509 -nodes -days 365 \
       -config openssl.cfg \
       -newkey rsa:4096 \
       -subj "/C=NL/ST=Utrecht/L=Utrecht/O=Dexpods/OU=Dexpods Root/CN=dexpods.localdev" \
       -keyout devproxyCA/private/cakey.pem \
       -out devproxyCA/cacert.pem
  # Install in system
  sudo ln -s $PWD/devproxyCA/cacert.pem /usr/share/ca-certificates/dexpods_proxy.crt
  sudo dpkg-reconfigure p critical ca-certificates
  echo "4"
  # Install in firefox
  for certDB in $(find  ~/.mozilla* -name "cert8.db")
  do
    certDir=$(dirname ${certDB});
    certutil -A -n "Dexpods root" -t "TCu,Cuw,Tuw" -i "devproxyCA/cacert.pem" -d ${certDir}
  done
  # Install in chrome
  certutil -A -n "Dexpods root" -t "TCu,Cuw,Tuw" -i "devproxyCA/cacert.pem" -d sql:$HOME/.pki/nssdb
fi

# Generate serial
if [ ! -f devproxyCA/serial ]; then
  echo '1111111E' > devproxyCA/serial
fi

# Create index.txt
if [ ! -f devproxyCA/index.txt ]; then
  touch devproxyCA/index.txt
fi

# Generate CSR
sudo openssl req \
  -config openssl.cfg \
  -nodes \
  -newkey rsa:2048 \
  -keyout ssl/nginx.key \
  -subj "/C=NL/ST=Utrecht/L=Utrecht/O=Dexpods/OU=Dexpods Development/CN=dexpods.localdev" \
  -new -sha256 \
  -out ssl/dexpods.localdev.csr.pem

# Create signed server cert
sudo openssl ca \
  -batch \
  -config openssl.cfg \
  -extensions server_cert -days 365 -notext -md sha256 \
  -key devproxyCA/private/cakey.pem \
  -outdir ssl \
  -in ssl/dexpods.localdev.csr.pem \
  -out ssl/nginx.crt
