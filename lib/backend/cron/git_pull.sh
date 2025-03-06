#!/bin/bash
cd /home/bjpummer26/anodrexia
git fetch && git reset --hard HEAD && git merge '@{u}'
rm -rf build/web
cd build
flutter create --platforms web ./web
cd ..
flutter clean
flutter build web
sudo rm -rf /var/www/html/test.pummer.li
sudo mv build/web /var/www/html/test.pummer.li
sudo chmod 755 /var/www/html/test.pummer.li
sudo systemctl reload nginx
python3 /home/bjpummer26/anodrexia/lib/backend/webscraping/scrape.py