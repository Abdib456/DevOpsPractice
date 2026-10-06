# Networking — Key Notes

These notes contain the main networking concepts I want to remember for DevOps.

They are not intended to cover networking in depth. They are a quick reference for the concepts, commands and mental models that are most important to understand.

---

# 1. Networking Fundamentals

## What Is a Network?

A network is a group of devices that can communicate with each other.

Examples include:

- Home networks
- Office networks
- Cloud networks
- The internet

The internet is essentially a huge collection of interconnected networks.

---

## LAN vs WAN

### LAN — Local Area Network

A network covering a relatively small area.

Examples:

- Home Wi-Fi
- Office network

### WAN — Wide Area Network

Connects networks across larger geographical areas.

The internet is the largest example of a WAN.

---

## Switches, Routers and Firewalls

### Switch

Connects devices within the same local network.

```text
Laptop
   |
   v
 Switch
   |
   v
Server
```

### Router

Connects different networks together and decides where packets should be sent next.

```text
Home Network
     |
   Router
     |
  Internet
```

### Firewall

Controls which network traffic is allowed or blocked.

Example:

```text
Internet
   |
   v
Firewall
   |
   | Port 80 allowed
   v
Web Server
```

AWS Security Groups perform a firewall-like role for resources such as EC2 instances.

---

## IP Addresses

An IP address identifies a network interface so that network traffic can be sent to the correct destination.

IPv4 example:

```text
192.168.1.10
```

### Private IP

Used for communication inside private networks.

Typical private IPv4 ranges include:

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

### Public IP

Used to communicate across the internet.

An EC2 instance can have both:

```text
Private IP → communication inside the AWS network

Public IP → communication over the internet
```

A public IP address is an address, not a password or secret.

However, credentials used to access the server must remain secret.

---

## MAC Addresses

A MAC address identifies a network interface at the local network / Data Link layer.

Simple mental model:

```text
MAC → local network communication

IP → communication across networks
```

---

## Ports

An IP address identifies the machine/network interface.

A port identifies a service/application on that machine.

Mental model:

```text
IP address = building address

Port = door inside the building
```

Example:

```text
EC2 Public IP
      |
      | Port 80
      v
    NGINX
```

A service must be listening on a port for it to handle traffic sent to that port.

### Common Ports

| Port | Service |
|---|---|
| 22 | SSH |
| 53 | DNS |
| 80 | HTTP |
| 443 | HTTPS |
| 5432 | PostgreSQL |

---

## TCP vs UDP

TCP and UDP are Transport Layer protocols.

### TCP

TCP is connection-oriented and focuses on reliable communication.

Important characteristics:

- Reliable delivery
- Ordered data
- Detects missing data
- More overhead than UDP

Used by protocols/services such as:

```text
HTTP
HTTPS
SSH
```

### UDP

UDP sends data without establishing the same type of reliable connection.

Important characteristics:

- Faster/lower overhead
- No guarantee of delivery
- No guarantee packets arrive in order

Useful when speed is more important than perfect delivery.

---

# 2. OSI Model

The OSI model describes networking using seven conceptual layers.

```text
7  Application
6  Presentation
5  Session
4  Transport
3  Network
2  Data Link
1  Physical
```

The most important layers for me to recognise are:

```text
Application → HTTP, DNS, SSH

Transport   → TCP, UDP, ports

Network     → IP addresses, routing

Data Link   → MAC addresses, Ethernet

Physical    → cables, radio signals, hardware
```

Example of data travelling through the stack:

```text
HTTP
 ↓
TCP :80
 ↓
IP
 ↓
Ethernet / Wi-Fi
 ↓
Physical network
```

On the receiving machine, the process effectively happens in reverse.

---

## TCP/IP Model

The TCP/IP model is the model more commonly associated with real-world internet networking.

A simplified view is:

```text
Application
Transport
Internet
Network Access
```

The OSI model is useful for understanding and troubleshooting networking, while TCP/IP more closely represents how modern internet networking is implemented.

---

# 3. DNS

## What Is DNS?

DNS stands for Domain Name System.

DNS allows humans to use names instead of remembering IP addresses.

Example:

```text
abdibasid.co.uk
       |
       | DNS lookup
       v
EC2 Public IPv4
```

DNS answers questions such as:

> What IP address belongs to this hostname?

---

## Important DNS Components

### Domain

Example:

```text
abdibasid.co.uk
```

### DNS Resolver

A resolver performs DNS lookups on behalf of a client.

### Nameserver

A nameserver stores/provides DNS information for domains it is authoritative for.

### DNS Zone

A zone contains DNS records for a domain.

---

## Important DNS Records

### A Record

Maps a hostname to an IPv4 address.

```text
example.com
     ↓
203.0.113.10
```

### AAAA Record

Maps a hostname to an IPv6 address.

### CNAME

Maps one hostname to another hostname.

```text
www.example.com
       ↓
example.com
```

### `@`

In DNS management interfaces, `@` commonly represents the root/apex domain.

For example:

```text
@ → abdibasid.co.uk
```

---

## DNS Request Flow

When entering:

```text
http://abdibasid.co.uk
```

the browser needs to discover the server's IP address.

Simplified flow:

```text
Browser
   |
   | DNS lookup
   v
DNS Resolver
   |
   v
DNS infrastructure
   |
   v
Authoritative DNS
   |
   | Returns IP
   v
Browser
```

The browser can then connect to the returned IP address.

---

## Important: DNS Does Not Serve the Website

DNS tells the client where the server is.

The web server handles the HTTP request.

For my Cloudflare DNS-only configuration:

```text
Browser
   |
   | DNS lookup
   v
Cloudflare DNS
   |
   | Returns EC2 public IP
   v
Browser
   |
   | Connects to EC2 :80
   v
NGINX
   |
   v
HTTP Response
```

Cloudflare answered the DNS query, but the browser then communicated directly with my EC2 instance.

---

## TTL

TTL means:

```text
Time To Live
```

It controls how long DNS information may be cached before it should be looked up again.

This means DNS changes may not always appear everywhere immediately because previous answers may still be cached.

---

## `/etc/hosts`

The hosts file can manually associate hostnames with IP addresses on a machine.

Linux/macOS:

```text
/etc/hosts
```

Example:

```text
127.0.0.1 localhost
```

It can be useful for local testing and hostname overrides.

---

# 4. Routing

## What Is Routing?

Routing determines how packets travel between different networks.

Routers examine the destination IP address and decide where the packet should go next.

Simple mental model:

```text
IP = where does the packet need to go?

Routing = how does the packet get there?
```

---

## Routing Table

Devices use routing tables to decide where traffic should be sent.

Conceptually:

```text
Destination Network
        |
        v
Which route should I use?
        |
        v
Next Hop / Gateway
```

---

## Default Gateway

If a device does not have a more specific route for a destination, traffic can be sent to its default gateway.

For a normal home network, this is usually the router.

---

## Static vs Dynamic Routing

### Static Routing

Routes are manually configured.

### Dynamic Routing

Routers automatically exchange routing information using routing protocols.

Examples of routing protocols include:

```text
OSPF
BGP
```

BGP is particularly important for routing between large networks across the internet.

For DevOps, I mainly need to understand the purpose of routing rather than deeply configuring routing protocols.

---

# 5. Subnetting, CIDR and NAT

## Subnets

A subnet divides a larger IP network into smaller networks.

Example:

```text
Network
   |
   +--- Subnet A
   |
   +--- Subnet B
   |
   +--- Subnet C
```

Cloud environments such as AWS make heavy use of subnets.

---

## CIDR

CIDR notation represents a network and how much of the IP address identifies the network.

Example:

```text
192.168.1.0/24
```

A `/24` IPv4 network contains:

```text
256 total addresses
```

because:

```text
32 - 24 = 8 host bits

2^8 = 256
```

Another important example:

```text
0.0.0.0/0
```

means:

```text
all IPv4 addresses
```

For example, an AWS Security Group rule:

```text
HTTP
TCP
80
0.0.0.0/0
```

allows IPv4 traffic to port 80 from anywhere.

---

## Binary

IPv4 addresses contain 32 bits.

They are divided into four 8-bit sections called octets.

```text
192.168.1.10
```

Conceptually:

```text
8 bits . 8 bits . 8 bits . 8 bits
```

Understanding binary helps explain subnet masks and CIDR notation.

---

## NAT

NAT stands for:

```text
Network Address Translation
```

NAT allows addresses to be translated when traffic moves between networks.

A common example is many private devices sharing one public IP when accessing the internet.

```text
Laptop  192.168.1.10 \
Phone   192.168.1.20  → Router/NAT → Public IP → Internet
TV      192.168.1.30 /
```

This is one reason private devices do not each necessarily need their own public IPv4 address.

---

# 6. Network Troubleshooting

A useful troubleshooting approach is to test the network in stages instead of assuming everything is one problem.

Ask questions such as:

```text
Is DNS resolving?

Can I reach the machine?

Is the correct port allowed?

Is the service listening?

Is the service actually running?

Is the application responding?
```

---

## Useful Commands

### DNS Lookup

```bash
nslookup example.com
```

or:

```bash
dig example.com
```

Useful for checking whether DNS resolves a hostname correctly.

---

### Test Reachability

```bash
ping <host>
```

Useful for testing ICMP connectivity when ICMP is allowed.

A failed ping does not automatically mean the server is down because ICMP may be blocked.

---

### View Network Path

```bash
traceroute <host>
```

Shows the network hops traffic takes towards a destination.

---

### Test HTTP

```bash
curl http://example.com
```

Useful for testing a web server without relying on a browser.

---

### Check Listening Ports

On Linux:

```bash
sudo ss -tulpn
```

Useful for seeing which services are listening on which ports.

---

### Check a Service

For example:

```bash
sudo systemctl status nginx
```

This checks whether NGINX is running on the server.

---

## Service Running Does Not Mean Service Reachable

This is an important troubleshooting distinction.

Running:

```bash
sudo systemctl status nginx
```

and seeing:

```text
Active: active (running)
```

proves that NGINX is running on the server.

It does **not** prove that users on the internet can reach it.

Opening:

```text
http://<EC2-PUBLIC-IP>
```

tests additional components:

```text
Browser
   |
   v
Internet
   |
   v
EC2 Public IP
   |
   v
Security Group :80
   |
   v
NGINX :80
   |
   v
HTTP Response
```

Therefore:

```text
Service check = server-side test

Browser/curl test = network + firewall + service test
```

This is an important DevOps troubleshooting mindset.

---

# 7. Cloud / AWS Networking

## EC2 Networking

An EC2 instance is a virtual server.

It can have:

```text
Private IP
Public IP
Security Group
Network interface
```

In my assignment:

```text
Internet
   |
   v
EC2 Public IP
   |
   v
Security Group
   |
   v
Ubuntu EC2
   |
   v
NGINX
```

---

## AWS Security Groups

A Security Group controls traffic allowed to/from AWS resources such as EC2.

For my NGINX server I needed separate inbound rules:

```text
22/TCP → SSH

80/TCP → HTTP
```

These rules have different purposes.

```text
SSH :22
   ↓
Remote server administration

HTTP :80
   ↓
Web traffic
```

### Important Lesson

I accidentally changed the existing SSH rule from:

```text
22 → SSH
```

to:

```text
80 → HTTP
```

instead of adding another rule.

The correct configuration required **two separate rules**:

```text
22 → SSH

80 → HTTP
```

If port 22 is not allowed, new SSH connections cannot reach SSH on the instance.

---

## Security Groups Are Stateful

AWS Security Groups are stateful.

If traffic is allowed into an instance, the corresponding response traffic is automatically allowed back out.

This also helps explain why changing a Security Group does not necessarily immediately destroy an already-established connection in the way I might initially expect.

---

## `0.0.0.0/0`

In an inbound rule:

```text
0.0.0.0/0
```

means traffic may originate from any IPv4 address.

For a public website:

```text
80 → 0.0.0.0/0
```

can make sense because the website is supposed to be publicly reachable.

For SSH, allowing:

```text
22 → 0.0.0.0/0
```

exposes the SSH port to the entire internet.

For better security, SSH access should normally be restricted to trusted IP addresses/networks where practical.

---

## Public IPs Can Change

A normal EC2 public IPv4 address may change after stopping and starting an instance.

If DNS points to the old address:

```text
Domain
   |
   v
OLD EC2 IP
```

the website will stop reaching the correct server.

The DNS record would need to point to the new address unless a static addressing solution is being used.

---

# 8. NGINX and HTTP Networking

NGINX is software running on the server.

EC2 provides the computer.

NGINX provides the web server.

```text
EC2
 |
 +--- Ubuntu
       |
       +--- NGINX
```

For HTTP:

```text
NGINX listens on TCP port 80
```

The request flow from my assignment was:

```text
Browser
   |
   | abdibasid.co.uk
   v
DNS
   |
   | EC2 public IP
   v
EC2
   |
   | TCP :80 allowed
   v
NGINX
   |
   | HTTP response
   v
Browser
```

---

## HTTP vs HTTPS

HTTP normally uses:

```text
Port 80
```

HTTPS normally uses:

```text
Port 443
```

HTTP traffic is not encrypted.

HTTPS uses TLS to encrypt communication between the client and server.

Therefore:

```text
HTTP  → web traffic without TLS encryption

HTTPS → HTTP protected using TLS
```

This is why my HTTP-only NGINX website displayed **Not Secure** in the browser.

---

# 9. SSH

SSH stands for Secure Shell.

It allows secure remote access to another machine.

Example:

```bash
ssh -i "NetworkingTest.pem" ubuntu@<EC2-PUBLIC-DNS>
```

Conceptually:

```text
My Mac
   |
   | SSH :22
   v
EC2
   |
   v
Ubuntu shell
```

The `-i` option specifies the private key used for authentication.

Example:

```bash
chmod 400 "NetworkingTest.pem"
```

restricts access to the private key file.

The private key must remain secret.

```text
Public IP / hostname → not a credential

SSH username         → not a credential

Private SSH key      → SECRET
```

Never commit private keys to Git.

---

# 10. Key Mental Models

These are the main things I want to remember.

```text
IP address
→ Where is the machine/network interface?

Port
→ Which service on that machine?

DNS
→ What address belongs to this name?

Router
→ Where should this packet go next?

Routing
→ How does the packet reach another network?

Firewall / Security Group
→ Is this traffic allowed?

TCP
→ Reliable, connection-oriented transport.

UDP
→ Lightweight, connectionless transport.

NGINX
→ Web server handling HTTP requests.

SSH
→ Secure remote access to another machine.

HTTP
→ Protocol for web requests and responses.

HTTPS
→ HTTP protected using TLS.

NAT
→ Translates addresses between networks.

Subnet
→ Smaller network created from a larger network.

CIDR
→ Describes network address ranges.
```

---

# 11. Things I Especially Want to Remember

### DNS happens before connecting to the server

```text
Domain
  ↓
DNS lookup
  ↓
IP address
  ↓
Connect to server
```

---

### IP and port are different

```text
IP = machine/address

Port = service
```

Example:

```text
203.0.113.10:80
              ↑
              NGINX / HTTP
```

---

### A running service may still be unreachable

```text
NGINX running
      ≠
NGINX reachable from internet
```

Firewall rules, Security Groups, routing and ports can still prevent access.

---

### DNS working does not mean the web server is working

DNS could correctly return:

```text
example.com → 203.0.113.10
```

while NGINX is stopped or port 80 is blocked.

Each layer should be tested separately.

---

### Public information is different from secret information

Generally public-facing information can include:

```text
Domain name
Public IP
Public DNS hostname
```

Credentials/secrets include:

```text
Private SSH keys
Passwords
AWS access keys
API keys
Tokens
.env secrets
```

Never commit secrets to Git.

---

# Quick Troubleshooting Checklist

When something cannot be reached:

```text
1. Does DNS resolve to the correct IP?
             ↓
2. Is the destination machine reachable?
             ↓
3. Is routing correct?
             ↓
4. Is the required port allowed?
             ↓
5. Is the service listening on that port?
             ↓
6. Is the service running?
             ↓
7. Is the application responding correctly?
```

Instead of thinking:

> "The website is broken."

break the problem into layers and determine **where the request stops working**.
