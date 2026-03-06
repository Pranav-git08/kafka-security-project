#!/bin/bash
TOPIC="secure-test"
BOOTSTRAP="localhost:9093"
CONFIG="client.properties"

kafka-consumer-perf-test --bootstrap-server $BOOTSTRAP --topic $TOPIC --messages 100000 \
--consumer.config $CONFIG
