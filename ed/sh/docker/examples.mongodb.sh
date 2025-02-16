# MongoDB

docker pull mongo:$tag

tag=latest
tag=3.4.4
tag=5.0.9
docker run -it --rm --net=xnet -p 27017:27017 --hostname xmongo --name xmongo \
    -v $PWD/.data/.docker/mongodb:/data/db mongo:$tag
    # -v /Users/k/Downloads/:/tmp/d \

# dump
docker exec -it xmongo mongorestore /tmp/d/creating_documents/dump
docker exec -it xmongo mongoimport --drop -d crunchbase -c companies /tmp/d/mongo/findAndCursorsInNodeJSDriver/companies.json

# test
docker exec -it xmongo mongo
docker exec -it xmongo mongo test --eval 'db.test.insert({code : "200", status: "ok"})'
docker exec -it xmongo mongo test \
    --eval 'db.createUser({user: "dbu", pwd: "dbp", roles: ["readWrite", "dbAdmin"]})'
docker exec -it xmongo mongo 'mongodb://localhost:27017/test'
docker exec -it xmongo mongo 'mongodb://localhost:27017/test' --username 'dbu' --password 'dbp'
docker exec -it xmongo mongo 'mongodb://localhost:27017/test' -u 'dbu' -p 'dbp'

#### MongoDB cluster (replica set)

# primary
docker run -it --rm --net=xnet -p 27017:27017 \
    --hostname xmongo-primary-1 --name xmongo-primary-1 \
    -v $PWD/.data/.docker/xmongo-primary-1:/data/db \
    mongo:$tag --port 27017 --replSet xmongo

# secondary
docker run -it --rm --net=xnet -p 27018:27018 \
    --hostname xmongo-secondary-1 --name xmongo-secondary-1 \
    -v $PWD/.data/.docker/xmongo-secondary-1:/data/db \
    mongo:$tag --port 27018 --replSet xmongo

# arbiter
docker run -it --rm --net=xnet -p 27019:27019 \
    --hostname xmongo-arbiter-1 --name xmongo-arbiter-1 \
    -v $PWD/.data/.docker/xmongo-arbiter-1:/data/db \
    mongo:$tag --port 27019 --replSet xmongo

# configure replica set
docker exec -it xmongo-primary-1 mongo --port 27017 --eval '
    rs.initiate({
        "_id": "xmongo",
        "members": [
            {"_id": 0, "host": "xmongo-primary-1:27017", "priority": 10},
            {"_id": 1, "host": "xmongo-secondary-1:27018"},
            {"_id": 2, "host": "xmongo-arbiter-1:27019", "arbiterOnly": true}
        ]
    })
'

# test
docker exec -it xmongo-primary-1 mongo --port 27017 --eval 'db.rs.insert({c:200})'
# docker exec -it xmongo-secondary-1 mongo --port 27018 --eval 'db.setSlaveOk()'
# docker exec -it xmongo-secondary-1 mongo --port 27018 --eval 'db.rs.find()'
docker exec -it xmongo-secondary-1 mongo --port 27018 --eval 'db.setSlaveOk();db.rs.find()'

#### MongoDB cluster (sharding)

# config server
docker run -it --rm --net=xnet -p 27016:27016 \
    --hostname xmongo-config-1 --name xmongo-config-1 \
    -v $PWD/.data/.docker/xmongo-config-1:/data/db \
    mongo:$tag --port 27016 --replSet xmongo-config --configsvr

# init config server
docker exec -it xmongo-config-1 mongo --port 27016 --eval '
    rs.initiate({ _id: "xmongo-config", members: [
        { _id : 0, host : "xmongo-config-1:27016" }
    ]});
'

# mongos (router) server
docker run -it --rm --net=xnet -p 27015:27015 \
    --hostname xmongo-mongos --name xmongo-mongos \
    -v $PWD/.data/.docker/xmongo-mongos:/data/db \
    mongo:$tag mongos --port 27015 --configdb xmongo-config/xmongo-config-1:27016

# shard-1
docker run -it --rm --net=xnet -p 27018:27018 \
    --hostname xmongo-shard-1 --name xmongo-shard-1 \
    -v $PWD/.data/.docker/xmongo-shard-1:/data/db \
    mongo:$tag --port 27018 --shardsvr

# shard-2
docker run -it --rm --net=xnet -p 27019:27019 \
    --hostname xmongo-shard-2 --name xmongo-shard-2 \
    -v $PWD/.data/.docker/xmongo-shard-2:/data/db \
    mongo:$tag --port 27019 --shardsvr

# init
docker exec -it xmongo-mongos mongo --port 27015 --eval '
    sh.addShard("xmongo-shard-1:27018");
    sh.addShard("xmongo-shard-2:27019");
    sh.enableSharding("test_db");
    sh.shardCollection("test_db.test_collection", {"country": 1, "number": 1});
    sh.status();
'
# test
docker exec -it xmongo-mongos mongo --port 27015 test_db --eval '
    db.test_collection.save({c: "200", t: "ok", country: "UA", number: "region_number_1"});
    db.test_collection.find({country: "UA"}).explain();
'
