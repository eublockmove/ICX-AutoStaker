# ICX AutoStaker
![Blockmove logo](https://i.imgur.com/eMSxYRR.png)

This is a Bash Script automating the process of claiming I-Score (1 ICX minimum), staking and voting. It should be run once a day in order to gain effect of compouding and thus increasing earnings of ICX staking/voting.
Crucial component of ICX AutoStaker is [T-Bears](https://github.com/icon-project/t-bears), tool developped by ICON Foundation which supports Linux and Mac OS. Therefore, ICX AutoStaker is also limited to these platforms. Windows 10 is supported by running Windows Subsystem for Linux.

## Windows 10 + Windows Subsystem for Linux
Open PowerShell as Administrator and run:
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
Restart if needed.
Open Microsoft Store, search for Ubuntu 18.04 LTS and install it. Set up login and password when prompted.

Install T-Bears and its dependancies:
```
sudo apt update && sudo apt -y upgrade && sudo apt -y install pkg-config python3-pip libsecp256k1-dev && pip3 install tbears
```
Download ICX AutoStaker:
```
wget ADD_DOWNLOAD_LINK
```
Export your keystore from ICONex and copy it to the same directory. Now open autostaker.sh and edit variables keystore, password and myICXaddress on the top. **Warning: use this only on a secure system! If your keystore in combination with password leaks, you might lose all your ICX!**

You should be all set now and ready for your first test ride:
```
bash autostaker.sh
```

## Run ICX AutoStaker after login (Windows 10)
Download batch script calling ICX AutoStaker from Linux Subsystem:
```
wget ADD_DOWNLOAD_LINK
```
Press Winkey+R and open:
```
shell:startup
```
Copy the run.bat into this directory and you're all set! Every time you log in to your Windows, ICX AutoStaker is going to check if there is more than 1 ICX to claim. If there is, then it will automatically claim, stake and vote.

## Run ICX AutoStaker as a Scheduled Task (Windows 10)
Download batch script calling ICX AutoStaker from Linux Subsystem:
```
wget ADD_DOWNLOAD_LINK
```
Follow [this tutorial](https://www.technipages.com/scheduled-task-windows) and create a Scheduled Task executing the batch file according to your criteria.

## Linux Setup (Ubuntu 18.04)
Install T-Bears and its dependancies:
```
sudo apt update && sudo apt -y upgrade && sudo apt -y install pkg-config python3-pip libsecp256k1-dev && pip3 install tbears
```
Download ICX AutoStaker:
```
wget ADD_DOWNLOAD_LINK
```
Export your keystore from ICONex and copy it to the same directory. Now open autostaker.sh and edit variables keystore, password and myICXaddress on the top. **Warning: use this only on a secure system! If your keystore in combination with password leaks, you might lose all your ICX!**

You should be all set now and ready for your first test ride:
```
bash autostaker.sh
```

## Run ICX AutoStaker after login (Ubuntu 18.04)
```
echo "bash autostaker.sh" >> ~/.profile
```
Change path if the script is located in other place than your home directory.
Every time you log in to your Ubuntu, ICX AutoStaker is going to check if there is more than 1 ICX to claim. If there is, then it will automatically claim, stake and vote.

## Mac OS Setup
Install Homebrew:
```
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
```
Install T-Bears and its dependancies:
```
brew install python3 leveldb autoconf automake libtool pkg-config && pip install tbears
```
Download ICX AutoStaker:
```
wget ADD_DOWNLOAD_LINK
```
Export your keystore from ICONex and copy it to the same directory. Now open autostaker.sh and edit variables keystore, password and myICXaddress on the top. **Warning: use this only on a secure system! If your keystore in combination with password leaks, you might lose all your ICX!**

You should be all set now and ready for your first test ride:
```
bash autostaker.sh
```

## Run ICX AutoStaker automatically with Cron (Linux, Mac OS)
If you have a system that is running 24/7, you can add it to Cron:
```
crontab -e
```
Create new entry:
```
0 6 * * * bash autostaker.sh
```
This will run ICX AutoStaker (located in your home directory) every morning at 6AM. You can use [Crontab Guru](https://crontab.guru) to generate your entry.

## Feedback
As always, we'd love to hear your feedback and ideas! The best place to reach us is our [Telegram group](https://t.me/blockmove).
