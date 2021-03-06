sudo apt-get update -y
sudo apt-get install -y nginx git-core qrencode python-virtualenv

mkdir /opt/qrencode
cd /opt/qrencode

git clone https://github.com/ZajtsevD/AWS
sudo cp AWS/config/qrencode.conf /etc/nginx/sites-available/default

git clone https://github.com/chubin/qrenco.de
cd qrenco.de
virtualenv ve/
ve/bin/pip install -r requirements.txt

mkdir -p log/
nohup ve/bin/python bin/srv.py >> log/qrencode.log 2>&1 &
                                 
sudo /etc/init.d/nginx restart
