# Kafka Security Hardening Project

# Summary
Implementation of a Zero-Trust Kafka cluster using mTLS and SASL/PLAIN.

# Steps Completed:
1. Configured TLS encryption for data-in-transit.
2. Enabled mTLS for client identity verification.
3. Implemented SASL/PLAIN for user authentication.
4. Activated Kafka ACLs for granular authorization.

# Performance Analysis:
Tested the 4 pillars (Availability, Durability, Throughput, Latency). 
Used `batch.size` and `linger.ms` to optimize throughput against SSL overhead.