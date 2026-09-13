### What I Learned

In this task, I learned how to process, search, filter, and manipulate text in Linux using commands such as `grep`, `awk`, `sed`, and pipes (`|`).

### Searching with `grep`

`grep` is used to search for text that matches a particular word or pattern.

```bash
grep "error" /var/log/syslog
```

This searches `/var/log/syslog` for lines containing `error`.

```bash
grep -r "TODO" ~/projects/
```

The `-r` option searches recursively, meaning `grep` looks through files inside the directory and its subdirectories.

```bash
grep -i "failed" /var/log/auth.log | wc -l
```

Here, `-i` makes the search case-insensitive. The results are passed to `wc -l`, which counts the number of matching lines.

### Using Pipes

The pipe symbol (`|`) takes the **output of one command and uses it as the input of another command**.

For example:

```bash
ps aux | grep nginx
```

`ps aux` lists processes, and instead of displaying everything, its output is passed to `grep`, which filters for lines containing `nginx`.

Commands can also be chained together:

```bash
cat /var/log/syslog | grep "error" | awk '{print $1, $2, $3}' | sort | uniq
```

Each command processes the output of the command before it:

**read file → find errors → select fields → sort → remove duplicates**

### Using `awk`

`awk` is useful for processing structured text and selecting particular fields.

```bash
ps aux | awk '{print $1, $11}'
```

This takes the output of `ps aux` and prints selected fields such as the user and command.

I also learned that `awk` normally separates fields using whitespace, but a different separator can be specified using `-F`.

For example:

```bash
cat /etc/passwd | awk -F: '{print $1, $6}'
```

The `/etc/passwd` file uses `:` to separate its fields, so `-F:` tells `awk` to treat `:` as the field separator. `$1` represents the first field and `$6` represents the sixth.

### Using `sed`

`sed` can be used to manipulate and select text.

```bash
sed 's/old/new/g' file.txt
```

This substitutes occurrences of `old` with `new`. The `g` means replace all matching occurrences on each line rather than only the first.

```bash
sed -n '10,20p' file.txt
```

This displays only lines 10 through 20 of the file.

### Challenge – Finding Bash Users

For the challenge, I needed to parse `/etc/passwd` and find users whose shell is `/bin/bash`.

I used:

```bash
cat /etc/passwd | grep "/bin/bash" | awk -F: '{print $1}'
```

This works by:

1. `cat /etc/passwd` – outputs the contents of the passwd file.
2. `grep "/bin/bash"` – keeps only users whose entries contain `/bin/bash`.
3. `awk -F:` – tells `awk` that fields are separated by `:`.
4. `{print $1}` – prints the first field, which is the username.

The output in my KillerCoda environment was:

```text
root
ubuntu
```

I also learned that `cat` is not always necessary because commands such as `grep` can read files directly.

### Key Takeaways

This task helped me understand how small Linux commands can be combined to perform more powerful text-processing operations.

The most important concepts I learned were:

* `grep` searches and filters text.
* `awk` processes fields and structured text.
* `sed` selects or modifies text.
* `wc -l` counts lines.
* `sort` sorts output.
* `uniq` removes adjacent duplicate lines.
* `|` passes one command's output into another command.

The biggest takeaway was understanding **piping**, because it allows multiple simple Linux commands to work together as one processing chain.