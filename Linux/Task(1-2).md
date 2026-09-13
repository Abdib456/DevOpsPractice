# Task 1:
Simple task, used 'whoami', 'pwd', 'uname -a'

# Task 2:
Done these tasks in the terminal:

## Navigation
cd /var/log

ls -lah

pwd

## File operations
touch test.txt - new empty test file

mkdir -p projects/demo - makes new projects and demo directories 

cp test.txt projects/demo/ - copies file into new directory

mv projects/demo/test.txt projects/demo/backup.txt - rename test file

rm projects/demo/backup.txt - removes backup file

# Viewing files
cat /etc/passwd - Views file

less /var/log/syslog: Opens the system log in an interactive viewer. You can scroll with arrow/Page Up/Page Down, search with /text, and press q to quit. Unlike cat, it’s convenient for large files.

head -n 20 /etc/services: Displays first 20 lines of the services, head meaning show the beginning and '-n 20' specifies how many lines

tail -f /var/log/auth.log: This command displays the end of the authentication log and keeps following it live '-f'