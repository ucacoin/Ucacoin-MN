#/bin/bash

echo "Your Ucacoin Masternode Will be Updated To Latest Version Now" 
sudo apt-get -y install unzip
ucacoin-cli stop
systemctl stop ucacoin.service
sleep 10
rm -rf /usr/local/bin/ucacoin*
mkdir UCA_MN
cd UCA_MN
wget https://github.com/ucacoin/Ucacoin2/releases/download/3.4.0/ucacoin-3.4.0-mn.tar.gz
tar -xzvf ucacoin-3.4.0-mn.tar.gz
mv ucacoind /usr/local/bin/ucacoind
mv ucacoin-cli /usr/local/bin/ucacoin-cli
chmod +x /usr/local/bin/ucacoin*
rm -rf ~/.ucacoin/blocks
rm -rf ~/.ucacoin/chainstate
rm -rf ~/.ucacoin/sporks
rm -rf ~/.ucacoin/peers.dat
cd ~/.ucacoin/
wget https://github.com/ucacoin/Ucacoin2/releases/download/3.4.0/bootstrap.zip
unzip bootstrap.zip

cd ..
rm -rf ~/.ucacoin/bootstrap.zip ~/UCA_MN
systemctl start ucacoin.service
sleep 10
ucacoin-cli addnode 167.71.245.49 onetry
ucacoin-cli addnode 178.128.98.125  onetry
ucacoin-cli addnode 142.93.175.145 onetry
ucacoin-cli addnode 135.181.37.92 onetry
ucacoin-cli addnode 95.217.21.41 onetry


echo "Masternode Updated!"
echo "Please wait few minutes and start your Masternode again on your Local Wallet"