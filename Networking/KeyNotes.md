# Networking — Key Notes

These notes contain the main networking concepts I want to remember for DevOps.

They are not intended to cover networking in depth. They are a quick reference for the concepts, commands and mental models that are most important to understand.

---

## Table of Contents

1. [Networking Fundamentals](#1-networking-fundamentals)
2. [OSI Model](#2-osi-model)
3. [DNS](#3-dns)
4. [Routing](#4-routing)
5. [Subnetting, CIDR and NAT](#5-subnetting-cidr-and-nat)
6. [Network Troubleshooting](#6-network-troubleshooting)
7. [Cloud / AWS Networking](#7-cloud--aws-networking)
8. [NGINX and HTTP Networking](#8-nginx-and-http-networking)
9. [SSH](#9-ssh)
10. [Key Mental Models](#10-key-mental-models)
11. [Things I Especially Want to Remember](#11-things-i-especially-want-to-remember)
12. [Quick Troubleshooting Checklist](#quick-troubleshooting-checklist)

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

Network troubleshooting should be done **step-by-step**.

Instead of randomly changing settings, break the communication path into smaller parts and test them individually.

A useful general process is:

```text
1. Understand what I am trying to reach
                ↓
2. Check the service/application
                ↓
3. Check listening ports
                ↓
4. Check local IP/interface configuration
                ↓
5. Test network reachability
                ↓
6. Check routing / network path
                ↓
7. Check firewalls / network rules
                ↓
8. Check DNS
                ↓
9. Test the actual application/protocol
```

The exact environment could be anything:

```text
Linux sandbox
Virtual machine
AWS EC2
Physical server
Container
Local computer
```

The underlying troubleshooting concepts remain the same.

Cloud environments such as AWS may add extra networking layers, but the Linux and networking fundamentals still apply.

---

## Step 1 — Understand What I Am Testing

Before running commands, identify what should actually be happening.

For example:

> A web server should be reachable at `example.com` over HTTP.

That gives me several things that could independently fail:

```text
example.com
     ↓
DNS resolves hostname
     ↓
IP address
     ↓
Network route exists
     ↓
Traffic is allowed
     ↓
TCP port 80 reachable
     ↓
Web server listening
     ↓
HTTP response
```

Troubleshooting means finding **which part of this chain is failing**.

Instead of thinking:

> "The network is broken."

I should ask specific questions such as:

```text
Is the application running?

Is it listening on the correct port?

Does the machine have the expected IP address?

Can the machine reach the destination?

Is routing working?

Is a firewall blocking the traffic?

Does DNS resolve correctly?

Does the actual application respond?
```

---

## Step 2 — Check Whether the Service Is Running

If I have access to the Linux machine, I can start close to the application.

For example, if NGINX should be running:

```bash
sudo systemctl status nginx
```

`systemctl` is used to control and inspect services managed by `systemd`.

The important part of the output would be something such as:

```text
Active: active (running)
```

This tells me:

```text
NGINX process
     ↓
is running on this machine
```

If the service is not running, it could be started with:

```bash
sudo systemctl start nginx
```

or restarted with:

```bash
sudo systemctl restart nginx
```

### Important

A running service does **not** mean it is reachable over the network.

```text
Service running
      ≠
Service reachable
```

The service could still be:

```text
Listening on the wrong port

Listening only on localhost

Blocked by a firewall

Affected by incorrect routing

Being accessed through incorrect DNS
```

So I should continue testing rather than assuming the problem is solved.

---

## Step 3 — Check Listening Ports

Next, check whether the machine is actually listening for network connections.

### `ss`

On modern Linux:

```bash
sudo ss -tulpn
```

`ss` stands for **socket statistics** and displays information about network sockets.

The options mean:

```text
-t → TCP sockets

-u → UDP sockets

-l → listening sockets

-p → process using the socket

-n → show numerical addresses and ports
```

For a normal NGINX HTTP server, I would expect something listening on:

```text
:80
```

For SSH:

```text
:22
```

Conceptually:

```text
NGINX process
      ↓
Listening socket
      ↓
TCP port 80
```

This helps answer:

> Is the application actually waiting for network connections on the port I expect?

### `netstat`

I may also see:

```bash
netstat -tulpn
```

`netstat` is an older networking command that can display things such as:

```text
Network connections
Listening ports
Routing information
Interface statistics
```

It appears frequently in older tutorials and systems.

For many tasks, modern Linux prefers:

```text
netstat → older

ss      → modern replacement
```

Some Linux systems may not have `netstat` installed by default.

For checking listening ports, I should generally prefer:

```bash
ss -tulpn
```

but I should still recognise `netstat`.

---

## Step 4 — Test the Application Locally

Before blaming the wider network, test whether the application works **on the machine itself**.

For an HTTP server:

```bash
curl http://localhost
```

`curl` is a command-line tool used to communicate with network services.

Here:

```text
http://
   ↓
Use HTTP

localhost
   ↓
This machine
```

So:

```bash
curl http://localhost
```

essentially asks:

> Can this machine make an HTTP request to its own web server?

Conceptually:

```text
curl
 ↓
localhost
 ↓
TCP :80
 ↓
NGINX
 ↓
HTTP response
```

If this works but another computer cannot access the website, that gives me useful information:

```text
Application works locally
          ↓
Problem may be outside the application
          ↓
Firewall / routing / external networking
```

This is an important troubleshooting technique because it helps separate an **application problem** from a **network problem**.

---

## Step 5 — Inspect Network Interfaces and IP Addresses

Next, understand how the Linux machine itself is configured on the network.

### `ip addr`

Use:

```bash
ip addr
```

This displays the machine's network interfaces and configured IP addresses.

I may see interfaces such as:

```text
lo
eth0
ens33
enp0s3
```

The exact interface names depend on the environment.

This command helps answer:

> What network interfaces and IP addresses does this machine have?

### `lo` — Loopback Interface

`lo` is the **loopback interface**.

It normally contains:

```text
127.0.0.1
```

which is associated with:

```text
localhost
```

The loopback interface allows the machine to communicate with itself.

For example:

```bash
curl http://localhost
```

can communicate with a local web server through the loopback interface.

### `ifconfig`

I will also commonly see:

```bash
ifconfig
```

`ifconfig` is an older command used to inspect and configure network interfaces.

It can display information such as:

```text
Network interfaces
IP addresses
Network masks
Interface state
```

Modern Linux generally prefers the `ip` command.

A useful mental model is:

```text
Older:

ifconfig


Modern:

ip addr
```

Some modern Linux systems do not install `ifconfig` by default.

Therefore, I should know both commands but generally prefer:

```bash
ip addr
```

---

## Step 6 — Test Network Reachability with `ping`

One of the most common networking commands is:

```bash
ping <destination>
```

For example:

```bash
ping google.com
```

or:

```bash
ping 8.8.8.8
```

`ping` is commonly used as a basic network connectivity test.

However, to understand `ping`, I need to understand **ICMP**.

### What Is ICMP?

ICMP stands for:

```text
Internet Control Message Protocol
```

ICMP is used by networked devices for control, diagnostic and error-reporting messages.

It is different from application protocols such as:

```text
HTTP → web communication

SSH  → remote access

DNS  → name resolution

ICMP → network control / diagnostic messages
```

`ping` commonly sends an:

```text
ICMP Echo Request
```

to the destination.

The destination may respond with an:

```text
ICMP Echo Reply
```

Conceptually:

```text
My Machine
    |
    | ICMP Echo Request
    v
Destination
    |
    | ICMP Echo Reply
    v
My Machine
```

If replies return, I know there is at least some working IP connectivity between the machines.

### Why Do People Use `ping google.com`?

Networking examples often use:

```bash
ping google.com
```

because Google is a well-known external hostname that is normally reachable from internet-connected systems.

It provides a convenient test.

If:

```bash
ping google.com
```

works, several things were involved:

```text
google.com
     ↓
DNS resolves the hostname
     ↓
Destination IP obtained
     ↓
Routing towards destination works
     ↓
ICMP Echo Request sent
     ↓
ICMP Echo Reply received
```

However:

```text
ping google.com works
```

does **not** prove that every network service works.

It does not prove that:

```text
HTTP works

SSH works

Port 443 is reachable

My own application works
```

It specifically gives me information about ICMP connectivity.

### Ping an IP vs Ping a Domain

Using an IP address and using a hostname can help isolate DNS problems.

First:

```bash
ping 8.8.8.8
```

This uses an IP address directly, so DNS does not need to translate a hostname first.

Then:

```bash
ping google.com
```

This requires DNS to resolve `google.com` before `ping` can send traffic to the resulting IP.

Imagine:

```text
ping 8.8.8.8
      ↓
WORKS

ping google.com
      ↓
FAILS because the hostname cannot be resolved
```

This suggests:

```text
Basic IP connectivity may work
           ↓
DNS may be the problem
```

It does not automatically prove DNS is the problem, but it gives me a strong clue about what to investigate next.

### Important Limitation of `ping`

`ping` does **not** test TCP or UDP ports.

ICMP does not use ports in the same way TCP and UDP do.

Therefore:

```bash
ping example.com
```

does not test:

```text
TCP :22

TCP :80

TCP :443
```

Also:

```text
ping fails
```

does **not** automatically mean:

```text
Server is down
```

ICMP may simply be blocked by a firewall or network policy.

For example:

```text
ICMP blocked
     ↓
ping fails

BUT

TCP :443 allowed
     ↓
HTTPS website still works
```

---

## Step 7 — Check Routing

Once I understand the machine's IP configuration, I can inspect where it will send network traffic.

Use:

```bash
ip route
```

This displays the Linux routing table.

I may see something such as:

```text
default via 192.168.1.1
```

The default route is used when there is no more specific route for a destination.

Conceptually:

```text
Need to send packet
        ↓
Look at destination IP
        ↓
Check routing table
        ↓
Find matching route
        ↓
Send towards next hop / gateway
```

This helps answer:

> Does this machine know where to send traffic for the destination?

If the machine has no appropriate route, the application may work perfectly but traffic may still be unable to reach another network.

---

## Step 8 — Inspect the Network Path with `traceroute`

Use:

```bash
traceroute <destination>
```

For example:

```bash
traceroute google.com
```

`traceroute` helps show the network hops traffic passes through on the way towards a destination.

Conceptually:

```text
My Machine
    ↓
Gateway
    ↓
Router
    ↓
Router
    ↓
Destination
```

This can help investigate:

```text
What path is traffic taking?

How far does traffic appear to get?

Is traffic taking an unexpected path?
```

Not every router responds to traceroute probes.

Therefore, missing hops do **not** automatically mean that the connection is broken.

---

## Step 9 — Check Firewalls and Network Controls

If the application works locally but cannot be reached remotely, something may be blocking the traffic.

The exact thing I check depends on the environment.

### Generic Linux Environment

A Linux machine may have a host firewall.

Depending on the Linux distribution, firewall tools may include:

```text
ufw
firewalld
iptables
nftables
```

For example, Ubuntu commonly provides:

```bash
sudo ufw status
```

This shows whether UFW is active and its configured rules.

The important question is:

```text
Service is listening
        ↓
Does the firewall allow traffic to that service?
```

For example:

```text
NGINX listening on TCP :80
           ↓
Firewall blocks TCP :80
           ↓
Remote users cannot reach NGINX
```

The application itself could be completely healthy.

### AWS EC2 Environment

If the Linux machine happens to be an AWS EC2 instance, there are additional AWS networking components to consider.

For example:

```text
Internet
   ↓
AWS networking
   ↓
Security Group
   ↓
EC2
   ↓
Linux firewall
   ↓
Application
```

For my NGINX assignment, HTTP required:

```text
TCP :80 → allowed
```

in the AWS Security Group.

SSH required:

```text
TCP :22 → allowed from an appropriate source
```

An AWS Security Group is therefore **not a universal Linux troubleshooting step**.

It is an additional environment-specific network control because the Linux server happens to be running inside AWS.

Other environments may have different network controls.

For example:

```text
Generic Linux server
        ↓
Linux firewall

AWS EC2
        ↓
Security Group + Linux firewall

Other cloud provider
        ↓
Provider firewall + Linux firewall

Company network
        ↓
Network firewall + Linux firewall
```

The general troubleshooting principle remains the same:

> Identify every point where traffic could be allowed, blocked or incorrectly routed.

---

## Step 10 — Check DNS

If IP connectivity appears to work, investigate name resolution.

### `nslookup`

A basic DNS lookup can be performed with:

```bash
nslookup google.com
```

This asks DNS for information about `google.com`.

The result can include the IP addresses associated with the hostname.

This is why tutorials commonly use:

```bash
nslookup google.com
```

Google is simply being used as a well-known real domain to demonstrate DNS resolution.

I could instead use:

```bash
nslookup example.com
```

or my own domain:

```bash
nslookup abdibasid.co.uk
```

The important concept is:

```text
Hostname
   ↓
DNS lookup
   ↓
IP address
```

### `dig`

Another common DNS command is:

```bash
dig google.com
```

`dig` provides more detailed DNS information.

It can show information such as:

```text
DNS answer
Record type
Returned IP
DNS server
Query timing
```

For basic troubleshooting, I can think:

```text
nslookup
    ↓
Simple DNS lookup


dig
    ↓
More detailed DNS investigation
```

### DNS vs Network Connectivity

A useful comparison is:

```bash
ping 8.8.8.8
```

and:

```bash
nslookup google.com
```

They answer different questions.

```text
ping 8.8.8.8
      ↓
Can I communicate with an external IP using ICMP?


nslookup google.com
      ↓
Can DNS resolve this hostname?
```

This helps me avoid thinking of "the internet" as one single component.

---

## Step 11 — Test the Actual Protocol

After checking the lower-level networking pieces, test the actual service I care about.

For HTTP:

```bash
curl http://example.com
```

For HTTPS:

```bash
curl https://example.com
```

A useful option is:

```bash
curl -I https://example.com
```

`-I` requests the HTTP response headers rather than the normal response body.

This can quickly show an HTTP response such as:

```text
HTTP/2 200
```

The important distinction is:

```bash
ping example.com
```

asks roughly:

> Can I get an ICMP response from this destination?

Whereas:

```bash
curl https://example.com
```

asks:

> Can I actually communicate with the web service using HTTPS?

That makes `curl` a more application-specific test.

For a successful web request, several components may need to work:

```text
DNS
 ↓
IP address
 ↓
Routing
 ↓
Firewall / network rules
 ↓
TCP connection
 ↓
Web server
 ↓
HTTP/HTTPS
 ↓
Response
```

---

## Other Useful Linux Networking Commands

These are useful networking commands to recognise even if I do not use all of them every day.

### `hostname`

```bash
hostname
```

Displays the machine's hostname.

To quickly display IP addresses associated with the host:

```bash
hostname -I
```

---

### `ip`

The `ip` command is one of the main modern Linux networking tools.

```bash
ip addr
```

Shows network interfaces and IP addresses.

```bash
ip route
```

Shows the routing table.

```bash
ip link
```

Shows network interfaces and their state.

Mental model:

```text
ip addr
   ↓
Addresses

ip route
   ↓
Routes

ip link
   ↓
Interfaces
```

---

### `ss`

Used to inspect sockets and network connections.

```bash
ss -tulpn
```

Shows listening TCP/UDP sockets and associated processes.

---

### `netstat`

Older networking utility.

```bash
netstat -tulpn
```

Can inspect listening ports and connections.

For many modern Linux tasks:

```text
netstat → older

ss      → preferred modern command
```

---

### `ifconfig`

Older command for inspecting/configuring network interfaces.

```bash
ifconfig
```

Modern equivalent for viewing interfaces and addresses:

```bash
ip addr
```

---

### `ping`

```bash
ping google.com
```

Tests ICMP reachability.

---

### `traceroute`

```bash
traceroute google.com
```

Investigates the network path towards a destination.

---

### `nslookup`

```bash
nslookup google.com
```

Performs a DNS lookup.

---

### `dig`

```bash
dig google.com
```

Performs a more detailed DNS query.

---

### `curl`

```bash
curl https://google.com
```

Tests communication with an HTTP/HTTPS service.

---

## Putting It All Together — Generic Linux Example

Imagine I am placed into an arbitrary Linux sandbox and told:

> "This Linux machine cannot reach `example.com`. Troubleshoot it."

I should **not** immediately think about AWS.

I should start gathering evidence.

### 1. What interfaces and IP addresses do I have?

```bash
ip addr
```

This tells me how the machine itself is configured.

### 2. What routes do I have?

```bash
ip route
```

This tells me where the machine will send traffic.

### 3. Can I reach an external IP?

```bash
ping 8.8.8.8
```

Because I am using an IP address directly, this test does not require DNS to translate a hostname first.

If this fails, I may need to investigate:

```text
Network interface
IP configuration
Routing
Firewall
External connectivity
```

### 4. Can I use a hostname?

```bash
ping google.com
```

If:

```text
ping 8.8.8.8
      ↓
WORKS

ping google.com
      ↓
FAILS because hostname cannot be resolved
```

then basic IP connectivity may be working while DNS may have a problem.

### 5. Can DNS resolve names?

```bash
nslookup example.com
```

or:

```bash
dig example.com
```

This tests DNS more directly.

### 6. What path is traffic taking?

If necessary:

```bash
traceroute example.com
```

This helps investigate the network path.

### 7. Can I reach the actual web service?

```bash
curl https://example.com
```

Now I am testing the actual application protocol rather than only ICMP.

At each step I am collecting evidence and narrowing down the possible cause.

---

## Putting It All Together — Web Server Example

Now imagine the problem is:

> "Users cannot reach the web server running on this Linux machine."

I can approach the problem from the server outward.

### 1. Is the application running?

```bash
sudo systemctl status nginx
```

If NGINX is not running, I have found an application-level problem.

### 2. Is it listening on the expected port?

```bash
sudo ss -tulpn
```

For HTTP I would expect something listening on:

```text
:80
```

For HTTPS:

```text
:443
```

### 3. Does the application work locally?

```bash
curl http://localhost
```

If this works, NGINX is responding locally.

### 4. What network configuration does the server have?

```bash
ip addr
```

Then:

```bash
ip route
```

This checks the server's IP/interface configuration and routing.

### 5. Is a Linux firewall blocking traffic?

For example, on a system using UFW:

```bash
sudo ufw status
```

### 6. Are there environment-specific network controls?

This depends on where the server is running.

```text
AWS
 ↓
Security Groups / VPC routing

Cloud VM
 ↓
Provider firewall / network rules

Company network
 ↓
Network firewall

Container
 ↓
Container networking / port mapping
```

### 7. Does DNS point to the correct server?

```bash
nslookup example.com
```

or:

```bash
dig example.com
```

### 8. Test the service remotely

From another machine:

```bash
curl http://example.com
```

At each stage I am narrowing down where the communication stops.

---

## Quick Command Reference

| Command | Main Question |
|---|---|
| `ip addr` | What interfaces and IP addresses do I have? |
| `ip link` | What network interfaces exist and are they up? |
| `ip route` | Where will my packets be sent? |
| `ifconfig` | Older way of viewing/configuring interfaces |
| `ss -tulpn` | What TCP/UDP ports are listening? |
| `netstat -tulpn` | Older way of inspecting sockets/ports |
| `ping <host>` | Can I get an ICMP response? |
| `traceroute <host>` | What network path is being taken? |
| `nslookup <domain>` | Does DNS resolve this name? |
| `dig <domain>` | What detailed DNS information can I see? |
| `curl <URL>` | Can I communicate with this HTTP/HTTPS service? |
| `hostname` | What is this machine's hostname? |
| `hostname -I` | What IP addresses are associated with this host? |
| `systemctl status <service>` | Is this service running? |
| `ufw status` | What is the status of the UFW firewall? |

---

## Troubleshooting Mental Model

The most important thing is **not memorising a list of commands**.

Each command should answer a question.

```text
What interfaces/IPs do I have?
        ↓
      ip addr

Where will traffic go?
        ↓
      ip route

Can I reach another machine using ICMP?
        ↓
       ping

What path is traffic taking?
        ↓
    traceroute

Can DNS resolve the hostname?
        ↓
  nslookup / dig

What ports are listening?
        ↓
        ss

Is my service running?
        ↓
    systemctl

Can the actual web application respond?
        ↓
       curl
```

The environment can then add extra layers.

For example:

```text
Generic Linux
────────────────────────
Application
Ports
Linux firewall
IP configuration
Routing
DNS
```

Compared with an AWS environment:

```text
AWS EC2
────────────────────────
Application
Ports
Linux firewall
EC2 networking
Security Group
Subnet / Route Table
Internet Gateway
DNS
```

The overall troubleshooting principle is:

> **Start with what I know, test each layer, and find the first point where the expected behaviour stops.**

Do not assume:

```text
Failed website
      =
DNS problem
```

Do not assume:

```text
Failed ping
      =
Server is down
```

And do not assume:

```text
Service running
      =
Service reachable
```

Instead, use each command to collect evidence and narrow the problem down.

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
