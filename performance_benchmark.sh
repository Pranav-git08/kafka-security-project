#!/bin/bash
TOPIC="secure-test"
BOOTSTRAP="localhost:9093"
CONFIG="client.properties"

kafka-producer-perf-test --topic $TOPIC --num-records 100000 --record-size 1024 --throughput -1 \
--producer-props bootstrap.servers=$BOOTSTRAP acks=1 batch.size=65536 linger.ms=20 \
--producer.config $CONFIG

kafka-producer-perf-test --topic $TOPIC --num-records 100000 --record-size 1024 --throughput -1 \
--producer-props bootstrap.servers=$BOOTSTRAP acks=all \
--producer.config $CONFIG
