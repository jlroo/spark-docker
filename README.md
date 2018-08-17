# Spark Docker
Instructions on building and running the Spark Docker image on Centos7, with samba volume.

## Create Volume cifs

	docker volume create 	--driver local 
				--opt type=cifs 
				--opt device=//SAMBA_SERVER_IP/PATH_TO_DATA/data
				--opt o=username=username,password=password VOLUME_NAME

## Running a Standalone Spark cluster using Docker-compose
1. Build the image worker image ```docker-compose build```
2. Start up a Spark master and n workers ```docker-compose up --scale worker=n```
3. Too destroy the cluster ```docker-compose down```

## Running a Standalone Spark Cluster of workers docker-compose
1. Build the worker image ```docker-compose -f worker.yml build```
2. Start up a Spark workers ```docker-compose -f worker.yml --scale worker=n```
3. To destroy the cluster of workers ```docker-compose -f worker.yml down```