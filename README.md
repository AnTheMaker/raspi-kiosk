# Raspi kiosk
A simple setup to run a public digital signage display showing a website in fullscreen + second display to config it all 

## Why?
I had to set up this kind of system multiple times before and I had to always look up the same commands over and over again... So I decided to make a repo containing the detailed instructions!

## Setup
1. First, flash Raspian (RaspberryPiOS) onto a micro SD card and plug it into the Pi 4. Then wire it up with the Main digital signage display/TV on the **second** micro-HDMI socket. Connect the first micro-HDMI socket to a small display with keyboard + mouse where you will configure and monitor everything.
2. 2Boot it up and install the following packages:
```
sudo apt-get install chromium-browser -y
sudo apt-get install unclutter -y 
```
Chrome is the browser and unclutter is a software to hide your cursor after a while.

3. Open chrome and install the following extension: [Autorefresh on Network Error](https://chrome.google.com/webstore/detail/autorefresh-on-network-er/milcogahlcilalagefhdhnoikibkoloo). This extension will refresh the page every X seconds whenever there is an error.

4. Now, let's configure the Pi so it doesnt show any warnings (such as "too little voltage"): `sudo nano /boot/config.txt` and add the following to the end of the file:
```
# Disable under-voltage warning
avoid_warnings=1
```
Now, reboot the system: `sudo reboot`
5. Next, we will edit the autostart script to automatically start unclutter (to hide the cursor), disable the screensaver and start our `kiosk.sh` script (which we will create in the next step) - add the below lines to the end of the file: `sudo nano /etc/xdg/lxsession/LXDE-pi/autostart`
```
# hide the cursor after some time:
@unclutter

# disable the Pi screensaver (black display):
@xset s off
@xset -dpms
@xset s noblank

# start the kiosk.sh script:
@bash /home/pi/kiosk.sh
```
6. Now, we create our `kiosk.sh` script to automatically start Chrome in kiosk mode on display 2 (the public display) and start chrome in "normal" mode on screen 1 (our admin screen): `nano /home/pi/kiosk.sh`
```
#!/bin/bash

echo "STARTING KIOSK SCRIPT"

# wait 12 seconds to make sure everything is done booting up:
sleep 12

# start chrome in fullscreen kiosk mode on display 1 (the public display):
chromium-browser --no-sandbox --enable-native-gpu-memory-buffers --kiosk --start-maximized --start-fullscreen --new-window --disable-features=Translate --disable-infobars --user-data-dir="/home/pi/Documents/Profiles/1" --window-position=1025,0 --app=http://localhost/ &

sleep 2

# start chrome in "normal" mode on display 2 (the admin display):
chromium-browser --enable-native-gpu-memory-buffers --start-maximized --start-fullscreen --new-window --disable-features=Translate --user-data-dir="/home/pi/Documents/Profiles/2" --window-position=0,0 --app=http://localhost/admin &


# if just a single monitor:
#chromium-browser --no-sandbox --enable-native-gpu-memory-buffers --kiosk --start-maximized --disable-features=Translate --incognito --disable-infobars http://localhost/

```
7. As a last thing, we will set up a cronjob to reboot the Pi every day at 1am at night, so it can do updates and fix itself if it should have any error :) - to do that, open crontab as admin: `sudo crontab -e` and add the following line to the end of it:
```
# reboot every night at 1am:
0 1 * * * /sbin/reboot

# get and install package updates after reboot
@reboot apt update && apt upgrade -y
```

8. (Optional) install a webserver (apacahe) and php!
```
sudo apt install apache2 -y
sudo apt install php libapache2-mod-php -y
sudo apt install php-mbstring php-zip php-xml php-curl -y
sudo chmod 777 /var/www/html #not ideal, but it works so yolo
```
9. If the time is incorrect (our school blocked the port of time servers!), install htpdate
```
sudo apt install htpdate
date
```

# Some helpful Links
Setting up the chrome kiosk mode on multiple displays:
- https://raspberrypi.stackexchange.com/a/104876
- https://www.raspberrypi.org/forums/viewtopic.php?t=257688
- https://www.raspberrypi.org/forums/viewtopic.php?t=247169

All chromium CLI parameters:
- https://peter.sh/experiments/chromium-command-line-switches/

Fix wrong time:
- https://www.raspberrypi.org/forums/viewtopic.php?t=222236

