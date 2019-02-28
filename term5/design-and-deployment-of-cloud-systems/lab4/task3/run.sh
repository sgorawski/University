sudo docker ps -q | xargs sudo docker kill
sudo docker ps -q -a | xargs sudo docker rm
sudo docker rmi sgorawski/clouds2018-lab4:latest
sudo docker run -d -e MSG="hello from 8001" -p 8001:8000 sgorawski/clouds2018-lab4:latest
sudo docker run -d -e MSG="hello from 8002" -p 8002:8000 sgorawski/clouds2018-lab4:latest
