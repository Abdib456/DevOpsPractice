### What I Learned

In this task, I learned how to start, view, manage, and terminate processes in Linux.

I used:

```bash
sleep 100 &
```

The `sleep 100` command creates a process that runs for 100 seconds. Adding `&` runs the process in the **background**, allowing me to continue using the terminal.

### Viewing Processes

```bash
ps
```

`ps` displays processes associated with the current terminal. I used it to find the **PID (Process ID)** of my `sleep` process.

```bash
ps aux
```

`ps aux` provides a more detailed list of processes running on the system, including processes belonging to other users.

Some useful columns include:

* `USER` – user running the process
* `PID` – unique Process ID
* `%CPU` – CPU usage
* `%MEM` – memory usage
* `COMMAND` – command that started the process

I can also search the process list using `grep`:

```bash
ps aux | grep nginx
```

The `|` pipe sends the output of `ps aux` into `grep`. `grep nginx` then filters the output to show lines containing `nginx`. This is useful for checking whether a particular service or process is running.

### Monitoring Processes

```bash
top
```

`top` provides a live view of running processes and system resource usage, including CPU and memory.

```bash
htop
```

`htop` is a more interactive and user-friendly process viewer. It provides an easier way to navigate and inspect running processes. It may need to be installed separately on some systems.

### Managing Background Jobs

```bash
jobs
```

`jobs` displays background or suspended jobs belonging to the current shell.

For example, a job might appear as:

```text
[1]+ Running    sleep 100 &
```

Here, `[1]` is the **job number**. This is different from the process's PID.

```bash
fg %1
```

`fg` brings job number 1 into the **foreground**, meaning it takes control of the terminal again.

```bash
bg %1
```

`bg` resumes a stopped job and allows it to continue running in the **background**.

### Terminating Processes

After finding a process's PID, I can terminate it with:

```bash
kill <PID>
```

For example:

```bash
kill 2229
```

I can run `ps` again afterwards to confirm that the process has stopped.

Another command is:

```bash
killall sleep
```

Instead of specifying a PID, `killall` terminates processes by their **name**. In this example, it attempts to terminate all processes named `sleep`.

### Key Takeaways

This task helped me understand that Linux processes have unique **PIDs**, while Bash also assigns **job numbers** to jobs managed by the current shell.

I also learned the basic process-management workflow:

**start process → inspect processes → find PID → manage/terminate process → verify it stopped**

Useful commands covered were `ps`, `ps aux`, `grep`, `top`, `htop`, `jobs`, `fg`, `bg`, `kill`, and `killall`.