# Kafka Security Implementation & Performance Analysis

This project documents the end-to-end security hardening of a Kafka cluster and an analysis of the resulting system behavior.

## 🛠 1. Steps Followed (Implementation Roadmap)

### Phase 1: Infrastructure & Encryption
* **CA Creation:** Generated a private Certificate Authority to establish a chain of trust.
* **Identity Generation:** Created RSA keys and signed certificates for the Kafka broker and all clients.
* **Keystore Setup:** Configured JKS (Java KeyStores) to store the identity and Truststores to verify the CA.

### Phase 2: Broker Hardening
* **Listener Configuration:** Set up the `SASL_SSL` protocol on port 9093.
* **mTLS Enforcement:** Set `ssl.client.auth=required` to ensure no client can connect without a verified certificate.
* **Inter-Broker Security:** Configured brokers to communicate with each other using encrypted tunnels.

### Phase 3: Identity & Authorization
* **SASL Layer:** Implemented `PLAIN` mechanism via JAAS for secondary authentication.
* **ACL Activation:** Enabled `AclAuthorizer` to move from an "Open" system to a "Zero-Trust" system where every action requires an explicit permit.

---

## 🔬 2. Technical Analysis: What's happening in the Cluster?

### The "Security Handshake" Process
When a producer connects to our cluster, the following chain reaction occurs:
1.  **Transport Level (SSL):** The broker and client perform a TLS handshake. Because we enabled **mTLS**, the broker requests the client's certificate. If invalid, the connection is dropped immediately.
2.  **Authentication Level (SASL):** Once the encrypted tunnel is open, the client sends its JAAS credentials. The broker verifies these against the `kafka_server_jaas.conf` file.
3.  **Authorization Level (ACL):** After the identity is confirmed, the broker checks the ACL metadata. If the user `admin` tries to write to `topic-A`, the broker checks if a `DESCRIBE` and `WRITE` permission exists.

### Performance Impact Analysis (The 4 Pillars)
Implementing this security model affects the system in the following ways:

* **Latency:** There is a "Security Tax." Every connection now requires cryptographic math for encryption/decryption, which increases the CPU cycles per message.
* **Throughput:** Because encryption adds overhead to each packet, I observed that increasing `batch.size` (e.g., to 64KB) helps recover throughput by encrypting larger chunks of data at once.
* **Durability:** By using `acks=all` alongside SSL, we ensure the highest data safety, though this represents the "slowest" possible configuration.
* **Availability:** The inter-broker security ensures that even if one node is compromised, the attacker cannot easily spoof another broker to corrupt the cluster state.
