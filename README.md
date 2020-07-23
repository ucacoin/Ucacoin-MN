# Uca-MN: Scripts to setup Masternode


Need a fresh VPS ubuntu(16x or 18x) with atleast 1 Gb RAM and 15 Gbs free space

0. update apt-get and install git

apt-get update
apt-get install git

1. download the file: 
```
git clone https://github.com/ucacoin/Ucacoin-MN.git
cd Ucacoin-MN
```
2. change the permissions:
```
chmod +x mn18.sh (in case of Ubuntu 18)
OR
chmod +x mn16.sh (in case of Ubuntu 16)

```
3. prepare the windows wallet:
- go to debug console and type:
```
getnewaddress MN1
```
- send 150.000 UCAs to this address and let atleast confirm by 1 blocks
- get the MN key and save in txt:
```
createmasternodekey
```
4. back to vps and execute the file reemn.sh:
```
sudo ./mn18.sh
```
5. wait to ask genkey and put by control+V the info getted in 4.3 point and give enter to go on.
6. let finish and note the IP:PORT given at the end of the script execution
7. back to your windows wallet and get masternode outputs:
```
getmasternodeoutputs
```
will give you something like this: you will only need anote what are between "" 
```
txhash: "7a1ebb4baadf9ff39bbbfc2d58fd57ff15b65a5096069c8b232d3d312fb4xxxx",
outputidx: 1
```
8. open the masternode conf file and put:
```
MN1 IP:PORT masternodekey masternodeouputs txnumber
EXAMPLE: 38.25.122.251:33210 7NEGGttKZojkAzViEYXXXxKTFdAtC2uSiMg8NSFqYVBtN6mYdU 7a1ebb4baadf9ff39bbbfc2d58fd57ff15b65a5096069c8XXX3fb4cb5c 1
```
9. save masternode conf file reopen wallet and in masternode section type START ALL
10. need atleast 22 blocks to be confirmed and start to work

# Uca MN Updater Script to Update Masternode in v3.0:

For **Ubuntu 16.04**
```
wget -q https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/mn1604_updater.sh
sudo chmod +x mn1604_updater.sh
./mn1604_updater.sh
```
***

For **Ubuntu 18.04**
```
wget -q https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/mn1804_updater.sh
sudo chmod +x mn1804_updater.sh
./mn1804_updater.sh
```
***

enjoy :)
