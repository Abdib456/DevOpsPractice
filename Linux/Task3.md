# Create a script
echo '#!/bin/bash\necho "Hello DevOps"' > hello.sh

or

echo '#!/bin/zsh\necho "Hello DevOps"' > hello.sh

# Make it executable
chmod +x hello.sh

# Run it
./hello.sh

# Change ownership
sudo chown root:root hello.sh

# Understanding permissions
ls -l hello.sh

Output: -rwxr-xr-x 1 root root 32 Nov 29 10:00 hello.sh 

Breakdown: owner(rwx) group(r-x) others(r-x)

### What I Learned

In this task, I learned how to create and run a basic Bash script and how Linux file permissions and ownership work.

I created `hello.sh` with a Bash shebang (`#!/bin/bash`), then used `chmod +x` to give the file executable permission so it could be run with `./hello.sh`.

I also used `chown` to change the file's owner and group to `root`, and `ls -l` to inspect its permissions and ownership.

The permission string `-rwxr-xr-x` showed me that permissions are split into three groups:

* **Owner:** `rwx` — read, write, and execute
* **Group:** `r-x` — read and execute
* **Others:** `r-x` — read and execute

I also realised that Linux and macOS are not exactly the same. Some Linux commands or filesystem conventions may behave differently on macOS, even though both provide similar Unix command-line tools. For Linux-specific exercises, using a Linux environment with Bash gives results that better match the exercises.
