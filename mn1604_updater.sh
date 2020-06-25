systemctl stop Ucacoin.service
sleep 5s
ucacoin-cli stop
sleep 5s
cd /usr/local/bin
wget https://github.com/ucacoin/Ucacoin2/releases/download/v3.1/ucacoind_ubuntu16.04.tar.gz
rm -rf ucacoind ucacoin-cli ucacoin-tx
tar -xzvf ucacoind_ubuntu16.04.tar.gz
cd
mv -f .Ucacoin .ucacoin
cd .ucacoin
rm -rf blocks chainstate sporks peers.dat database *.pid *.gz 
mv Ucacoin.conf ucacoin.conf
wget http://178.128.98.125/bootstrap.tar.gz
tar -xzvf bootstrap.tar.gz
cd
cd /etc/systemd/system
rm -rf Ucacoin.service
wget http://178.128.98.125/Ucacoin.service
systemctl daemon-reload
systemctl start Ucacoin.service
