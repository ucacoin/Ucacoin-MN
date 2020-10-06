# Ucacoin Masternode Setup (Ubuntu 16.04 / 18.04)
This guide will assist you in setting up a Ucacoin Masternode on a Linux Server running Ubuntu 16.04 / 18.04

If you require further assistance, contact the support team at <a href="https://discord.gg/EemcMKf" target="_blank">Discord</a>
***
- [Ucacoin Masternode Setup](#ucacoin-masternode-setup)  
  	* [Requirements](#requirements) 
  * [Connecting to the VPS and installing the masternode script](#Connecting-to-the-VPS-and-installing-the-masternode-script)  
         [1. Log into the VPS with **root**](#1-log-into-the-vps-with-root)  
         [2. Git Installation](#2-git-installation)  
         [3. Clone MN setup script](#3-clone-mn-setup-script)  
         [4. Start MN setup script](#4-start-mn-setup-script)  
         [5. Copy Masternode Private Key](#5-copy-masternode-private-key-from-vps-console-window-and-pres-enter)
  * [Setup QT wallet](#setup-qt-wallet)  
         [1. Create new receiving address and copy it](#1-create-new-receiving-address-and-copy-it)  
	 [2. Send Collateral amount of UCACoin to copied address](#2-send-collateral-amount-of-ucacoin-to-copied-address)  
	 [3. Get MN output and Set Masternode Configuration File](#3-open-console-get-mn-output-and-set-masternode-configuration-file-and-save-it)  
	 [4. Wait at least 15 confirmation of transaction](#4-wait-at-least-15-confirmation-of-transaction)  
         [5. Restart QT wallet](#5-restart-qt-wallet)  
         [6. Start MN in QT wallet console](#6-start-mn-in-qt-wallet-console)  
	 [7. Check Masternode Status in VPS](#7-check-masternode-status-in-vps)  

***
## Requirements
- MN Collateral amount of UCA coins.
- A VPS running Linux Ubuntu 16.04 or 18.04 with 1 CPU & 1GB Memory minimum (2gb Recommended) from [Vultr](https://www.vultr.com/?ref=8622028) or any other providers.
- Ucacoin Wallet (Local Wallet)
- An SSH Client (<a href="https://www.putty.org/" target="_blank">Putty</a> or <a href="https://dl.bitvise.com/BvSshClient-Inst.exe" target="_blank">Bitvise</a>)

***
## Connecting to the VPS and installing the masternode script
***
##### 1. Log into the VPS with **root**  
[![Vps](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/1.png)]
***
##### 2. Git Installation:  
- ```sudo apt-get install -y git-core```  

[![Git](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/2.png)]
***
##### 3. Clone MN setup script: 
- ```git clone https://github.com/ucacoin/Ucacoin-MN.git```  

[![Script1](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/3.png)] 
***
##### 4. Start MN setup script: 
- ```cd Ucacoin-MN && chmod +x ./ucacoin-3.2.0-mn.sh && ./ucacoin-3.2.0-mn.sh```
   
[![Script2](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/4.png)]  

**Now ask for VPS Public IP Address** 
[![Script3](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/5.png)]

**Now you need to wait some time, while script preparing the VPS to setup**  
***
##### 5. Copy masternode private key from VPS console window and pres "Enter":
[![Download Bitvise](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/6.png)] 

- if you see this, you are on the right track:
[![QT1](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/7.png)]

- to check VPS daemon status, type: ```ucacoin-cli getinfo```
[![QT2](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/8.png)]

**Don't close this window!** 
***		

## Setup QT wallet
##### 1. Create new receiving address and copy it
[![QT3](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/9.png)] 

***
##### 2. Send Collateral amount of UCACoin to copied address
[![QT4](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/10.png)]
***
##### 3. Open console Get MN output and set masternode configuration file and save it
- ```mn1 VPS_IP:33210 masternode_genkey masternode_output output_index```:
[![QT5](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/11.png)]
***
##### 4. Wait at least 15 confirmation of transaction
[![QT6](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/12.png)]
***
##### 5. Restart QT wallet  
- **it's important**
***
##### 6. Start MN in QT wallet console:
- ```startmasternode alias false TEST_MN```

[![QT7](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/13.png)]
***
##### 7. Check Masternode Status in VPS:
- ```ucacoin-cli startmasternode local false``` 
- ```ucacoin-cli getmasternodestatus```  
[![QT8](https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/assets/14.png)]  
***
**Сongratulations you did it!**


# Guide for UCACoin v3.2.0 MN Update:

For **Ubuntu**
```
wget -q https://raw.githubusercontent.com/ucacoin/Ucacoin-MN/master/ucacoin-3.2.0-mnupdate.sh
sudo chmod +x ucacoin-3.2.0-mnupdate.sh
./ucacoin-3.2.0-mnupdate.sh
```
***