# OverTheWire Bandit: Levels 1–15

These notes document the main Linux, networking, and security concepts I learned while working through the OverTheWire Bandit challenges from levels 1–15.

---

## Bandit 1: Special Filenames and Relative Paths

In this level, I learned how file paths work and why some filenames can have a special meaning to Linux commands.

The file was named `-`. Normally, running:

```bash id="ksc9e1"
cat -
```

does not tell `cat` to read a file called `-`. Instead, `-` represents **standard input (stdin)**, so `cat` waits for input from the terminal.

To explicitly reference the file in the current directory, I used:

```bash id="swlgz8"
cat ./-
```

Here, `.` represents the **current directory**, so `./-` means "the file named `-` in my current directory."

### Key Takeaways

* `.` represents the current directory.
* `./filename` explicitly references a file in the current directory.
* Some filenames can be interpreted specially by commands.
* `-` commonly represents standard input or standard output in Unix/Linux commands.
* Using a path such as `./-` removes the ambiguity.

---

## Bandit 4: Files Beginning with `-`

In this level, I learned that filenames beginning with `-` can cause problems because Linux commands commonly use `-` to identify command-line options.

The files had names such as:

```text id="r89jdn"
-file00
-file01
-file02
```

Using these filenames directly could cause a command to interpret them as options rather than filenames.

I used:

```bash id="wjj5l4"
file ./-file*
```

Adding `./` makes each match a path beginning with the current directory rather than simply a name beginning with `-`.

The `*` is a **wildcard**, which allows multiple matching filenames to be selected.

### Useful Commands and Concepts

* `file` – identifies the type of data contained in a file.
* `*` – wildcard that matches multiple filenames.
* `./` – represents the current directory.
* `file ./-file*` – checks the file type of the matching `-file` files safely.

### Key Takeaway

A filename beginning with `-` can be mistaken for a command option. Using an explicit path such as `./filename` helps avoid this problem.

---

## Bandit 5: Finding Files Using Conditions

In this level, I learned how `find` can locate files based on specific properties.

I was able to find the required file using its exact size because only one file matched that condition.

However, I learned that `find` can combine several conditions when a single condition is not enough.

For example, searches can be narrowed using properties such as:

* File type
* File size
* Ownership
* Group
* Permissions

If several files match one condition, `find` returns all matching paths. Additional conditions can then be added to narrow the search.

### Key Takeaway

`find` becomes much more powerful when multiple conditions are combined. Instead of searching only by filename, I can search based on properties of the file itself.

---

## Bandit 6: Searching the Filesystem with `find`

In this level, I learned how to use `find` with multiple conditions and how absolute and relative paths affect a search.

Starting a search with:

```bash id="t78hsj"
find /
```

tells `find` to search from the **root of the filesystem**.

Some useful search conditions included:

```text id="y96opw"
-size 33c
-user
-group
```

`-size 33c` searches for a file that is exactly 33 bytes, where `c` represents bytes.

`-user` and `-group` allow searches based on the owner and group of a file.

### Absolute vs Relative Paths

I also gained a better understanding of paths.

```text id="q1bvd8"
/path
```

is an **absolute path**. It starts from the filesystem root `/` and refers to the same location regardless of my current directory.

```text id="rd7r2x"
./path
```

is a **relative path**. It starts from my current directory.

One mistake I made was using something like:

```text id="j6e42k"
./var/...
```

after changing directories.

This searches for a directory called `var` inside my **current directory**. In comparison:

```text id="s7cxvs"
/var/...
```

always refers to `/var` from the root of the filesystem.

While searching, I also encountered:

```text id="y8twy3"
Permission denied
```

This means my user does not have permission to access that particular location. It does not necessarily stop `find` from continuing to search other accessible locations.

### `find` vs `grep`

An important distinction I learned was:

* `find` – searches for **files and directories**.
* `grep` – searches for **text/patterns**, usually inside files or command output.

### Key Takeaway

This level helped me understand how to search a large filesystem efficiently and reinforced the difference between **absolute paths** and **relative paths**.

---

## Bandit 8: `sort`, `uniq`, and Pipes

In this level, I learned how to combine commands to find a line of text that appeared only once in a file.

I used:

```bash id="kxkpq1"
sort data.txt | uniq -u
```

`sort` first arranges the lines so identical values are placed next to each other.

The pipe:

```text id="6gkb53"
|
```

takes the output from `sort` and passes it to `uniq`.

`uniq -u` then displays only lines that occur once.

### Useful Commands and Concepts

* `sort file` – sorts lines of text.
* `uniq` – filters adjacent duplicate lines.
* `uniq -u` – displays only unique lines.
* `|` – passes the output of one command into another.

I also learned that commands have **default behaviour** even when no options are provided. Options such as `-u` modify that default behaviour.

### Key Takeaway

This level showed me why pipes are powerful in Linux. Instead of needing one command that does everything, I can combine smaller commands:

**sort data → pass output through pipe → filter unique result**

---

## Bandit 12: Compression, Archives, and Hex Dumps

This level taught me how to work through multiple layers of compressed and archived data.

The most important strategy was:

**identify the data → remove one layer → identify again → repeat**

I first created a temporary working directory using:

```bash id="w8e7ri"
mktemp -d
```

This provided a safe temporary location to work with the files.

I used:

```bash id="1a1ht6"
xxd -r
```

to reverse a hex dump and convert it back into its original binary representation.

I also used output redirection:

```text id="o3r9po"
>
```

which saves the output of a command into a file rather than displaying it in the terminal.

### Identifying Data

One of the most useful commands in this level was:

```bash id="xkg0s3"
file filename
```

I used `file` after each layer to determine what type of data I was dealing with next.

This taught me an important lesson: **a filename or extension does not guarantee what type of data a file actually contains.**

The `file` command examines the contents to identify the data type.

### Decompression and Extraction

Depending on what `file` reported, I used different tools:

```bash id="yq0j8e"
gzip -d file.gz
```

Decompresses gzip-compressed data.

```bash id="96c9a6"
bzip2 -d file.bz2
```

Decompresses bzip2-compressed data.

```bash id="k1jbr0"
tar -x -f file
```

Extracts files from a tar archive.

I also used:

```bash id="j3vp1k"
mv oldname newname
```

to rename files when useful, including giving compressed files appropriate suffixes.

Once `file` finally identified the data as readable text, I could use:

```bash id="m90j8a"
cat filename
```

to display it.

### Key Takeaway

The main lesson from this level was not memorising which decompression command to use first. Instead, I learned to repeatedly inspect the data and choose the correct tool based on what `file` reported:

**`file` → decompress/extract → `file` → decompress/extract → repeat**

---

## Bandit 13: SSH Private-Key Authentication

In this level, I learned how SSH can authenticate using a **private key** instead of a password.

The basic command is:

```bash id="xf51lw"
ssh -i keyfile user@host
```

The `-i` option tells SSH which private identity/key file should be used for authentication.

I learned that a private key is stored as a **file**. I do not copy and paste the contents of the key into the SSH command.

### Securely Copying Files

I also learned about `scp`, which securely copies files between systems using SSH.

For example:

```bash id="rxj45u"
scp -P 2220 user@host:path .
```

This copies a remote file into my current local directory.

One important detail is that `scp` uses an uppercase:

```text id="2q4eqc"
-P
```

when specifying the SSH port.

### Private-Key Permissions

I used:

```bash id="w6o9hj"
ls -l
```

to inspect the permissions of the private key.

SSH expects private keys to be protected so that other users cannot read them.

I used:

```bash id="8kv8gl"
chmod g-r file
```

where:

* `g` means **group**.
* `-` means **remove permission**.
* `r` means **read permission**.

In my case, this changed permissions from:

```text id="s5u77c"
-rw-r-----
```

to:

```text id="l2ezgo"
-rw-------
```

meaning only the owner had read/write access.

I also reinforced my understanding of paths:

* `/path` – starts from the filesystem root.
* `./path` – starts from the current directory.
* `~` – represents my home directory.

Because of the restrictions in the Bandit environment, I copied the private key to my Mac, secured its permissions, and then used it to connect directly.

### Key Takeaway

The main workflow I learned was:

**obtain private key → securely copy it → restrict its permissions → authenticate using `ssh -i`**

This helped me understand how SSH key-based authentication differs from password authentication.

---

## Bandit 14: Ports and Telnet

In this level, I started learning more about network communication, particularly the relationship between hosts and ports.

A simple way I understood it was:

* **Host** – identifies the computer I want to communicate with.
* **Port** – identifies a particular network service on that computer.

For example:

```text id="i7h85n"
bandit14@bandit
```

contains:

* `bandit14` – the **user**.
* `bandit` – the **host**.

I also learned about:

```text id="2jzrm9"
localhost
```

which refers to the computer I am currently using. The IPv4 loopback address commonly associated with localhost is:

```text id="a4e57g"
127.0.0.1
```

### Using Telnet

I learned the basic structure:

```bash id="6uqpfh"
telnet HOST PORT
```

This creates a basic connection to a service listening on a particular port.

Once connected, I can send data to that service and receive its response.

### Key Takeaway

This level helped me understand that connecting to a machine is not always enough. I often need to specify **which service on that machine** I want to communicate with:

**host + port → connect to a specific network service**

---

## Bandit 15: TLS and OpenSSL

In this level, I built on what I learned about hosts and ports by connecting to a service that uses **TLS encryption**.

TLS protects communication between a client and server while data travels across a network.

I used OpenSSL, which is a toolkit for cryptography and secure communication.

The command:

```bash id="y7bvn9"
openssl s_client
```

allows OpenSSL to behave as a client and establish a TLS connection.

A connection can be made using:

```bash id="b3f5c9"
openssl s_client -connect HOST:PORT
```

This connects to a TLS-enabled service running on the specified host and port.

### TLS Handshake

I learned that `s_client` does not simply use one fixed encryption algorithm.

When the connection begins, the client and server perform a **TLS handshake**. During this process, they establish the parameters needed for the secure connection, including agreeing on supported cryptographic algorithms.

I learned the distinction between:

* **TLS protocol** – the rules used to establish and maintain the secure connection.
* **Cipher suite** – the set of cryptographic algorithms selected for protecting the connection.
* **Certificate** – helps establish the identity of the server.

I also learned that receiving a warning about a **self-signed certificate** does not automatically mean that the connection itself is unencrypted. Encryption and certificate trust/verification are related but separate concepts.

### Telnet vs TLS

Bandit 14 and Bandit 15 helped make the difference clearer to me.

With Telnet, I connected directly to a service and communicated without TLS protection.

With:

```bash id="yrmjta"
openssl s_client -connect HOST:PORT
```

I connected to a service using TLS, meaning the communication could be protected using encryption.

### Key Takeaway

The main concept I learned was:

**host + port identifies the service → TLS establishes a secure connection → cryptographic algorithms protect the communication**

This built directly on the networking concepts from Bandit 14 while introducing secure network communication.
