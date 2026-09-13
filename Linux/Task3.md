# Task 3: Scripts, Permissions and Ownership

In this task, I learned how to create and execute a shell script and how Linux file permissions and ownership work.

### Creating a Shell Script

I created a simple shell script called `hello.sh`:

```bash id="kg2fqk"
echo '#!/bin/bash
echo "Hello DevOps"' > hello.sh
```

The first line, `#!/bin/bash`, is called a **shebang**. It tells the system which interpreter should be used to execute the script.

A different shell can also be specified if required, for example:

```bash id="dvh5nm"
#!/bin/zsh
```

However, for Linux exercises I used Bash because it is commonly used in Linux environments.

### Making the Script Executable

```bash id="b8xfug"
chmod +x hello.sh
```

`chmod` changes file permissions. The `+x` adds **execute permission**, allowing the script to be run as a program.

I could then execute it using:

```bash id="sm1tn3"
./hello.sh
```

The `./` tells the shell to run `hello.sh` from the current directory.

### Changing File Ownership

```bash id="bd0gbq"
sudo chown root:root hello.sh
```

`chown` changes the ownership of a file.

In this command:

* The first `root` is the **owner**.
* The second `root` is the **group**.
* `sudo` runs the command with elevated privileges.

### Understanding Permissions

I inspected the file using:

```bash id="b7ovpv"
ls -l hello.sh
```

Example output:

```text id="tw8qmt"
-rwxr-xr-x 1 root root 32 Nov 29 10:00 hello.sh
```

The permission section:

```text id="2rdl91"
-rwxr-xr-x
```

is split into three permission groups:

* **Owner:** `rwx` – read, write, and execute
* **Group:** `r-x` – read and execute
* **Others:** `r-x` – read and execute

The letters represent:

* `r` – read
* `w` – write
* `x` – execute
* `-` – permission not granted

### Key Takeaways

This task helped me understand how shell scripts are created and executed and how Linux controls access to files through permissions and ownership.

The main commands and concepts I learned were:

* `#!` – specifies the interpreter used by a script.
* `chmod` – changes file permissions.
* `+x` – adds execute permission.
* `./` – runs a file from the current directory.
* `chown` – changes the owner and group of a file.
* `ls -l` – displays detailed file permissions and ownership.
* `r`, `w`, and `x` represent read, write, and execute permissions.

I also learned that Linux and macOS can behave differently even though they share many Unix commands. For Linux-specific exercises, using a Linux environment such as KillerCoda provides results that better match Linux commands and conventions.