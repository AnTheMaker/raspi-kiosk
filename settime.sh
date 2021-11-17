# I have no idea if this will work...
# execute as sudo or set as cronjob, idk

datetime=$(curl -I "http://google.com" -L -s 2>/dev/null | grep -i "^date:" -m 1 | sed "s/^[Dd]ate: //g");
date --set "$datetime";
