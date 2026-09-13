# Tasks 1–2: Linux Basics, Navigation and File Management

In these tasks, I learned some of the fundamental Linux commands used to identify the current environment, navigate the filesystem, create and manage files and directories, and view file contents.

### System Information

I started with some basic commands for understanding the Linux environment:

```bash id="efzz7j"
whoami
```

`whoami` displays the username of the currently logged-in user.

```bash id="ykgcc6"
pwd
```

`pwd` stands for **print working directory** and displays my current location in the filesystem.

```bash id="qvyc49"
uname -a
```

`uname -a` displays information about the operating system and kernel.

### Navigating the Filesystem

I used:

```bash id="ynhjjf"
cd /var/log
```

`cd` changes the current directory. In this example, I moved into `/var/log`, which is commonly used to store system logs.

```bash id="dwlnd8"
ls -lah
```

`ls` lists files and directories.

The options provide additional information:

* `-l` – displays a detailed list.
* `-a` – includes hidden files.
* `-h` – displays file sizes in a human-readable format.

I also used:

```bash id="8v3fj6"
pwd
```

to confirm which directory I was currently working in.

### Creating Files and Directories

I created an empty file using:

```bash id="29r0xd"
touch test.txt
```

I then created nested directories:

```bash id="24qihs"
mkdir -p projects/demo
```

`mkdir` creates directories, while `-p` allows parent directories to be created when necessary.

### Copying, Moving and Removing Files

I copied `test.txt` into the new directory:

```bash id="ix9y8w"
cp test.txt projects/demo/
```

I then renamed the file:

```bash id="i3fze5"
mv projects/demo/test.txt projects/demo/backup.txt
```

`mv` can be used to either **move or rename** files and directories.

Finally, I removed the file:

```bash id="7w4k5d"
rm projects/demo/backup.txt
```

`rm` removes files from the filesystem.

### Viewing Files

I used several different commands for viewing file contents.

```bash id="9x4sri"
cat /etc/passwd
```

`cat` outputs the contents of a file directly to the terminal.

For larger files, I used:

```bash id="nmt86w"
less /var/log/syslog
```

`less` opens a file in an interactive viewer. It allows me to scroll through the file, search using `/text`, and press `q` to exit. This is more convenient than `cat` when working with large files.

I used:

```bash id="m82m2r"
head -n 20 /etc/services
```

`head` displays the beginning of a file. The `-n 20` option tells it to display the first 20 lines.

I also used:

```bash id="aqhv09"
tail -f /var/log/auth.log
```

`tail` displays the end of a file. The `-f` option means **follow**, so the command continues running and displays new log entries as they are added. This is useful when monitoring log files in real time.

### Key Takeaways

These tasks introduced me to the basic structure and commands of a Linux system.

The main commands I learned were:

* `whoami` – shows the current user.
* `pwd` – shows the current working directory.
* `uname -a` – displays system and kernel information.
* `cd` – changes directory.
* `ls` – lists files and directories.
* `touch` – creates an empty file.
* `mkdir` – creates directories.
* `cp` – copies files.
* `mv` – moves or renames files.
* `rm` – removes files.
* `cat` – displays the contents of a file.
* `less` – interactively views larger files.
* `head` – displays the beginning of a file.
* `tail` – displays the end of a file.
* `tail -f` – follows a file and displays new content as it is added.

Overall, these tasks helped me become more comfortable navigating Linux from the terminal and performing basic file and directory operations.