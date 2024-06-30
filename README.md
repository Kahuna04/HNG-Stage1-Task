# Linux User Creation Bash Script

Hello everyone, I am Kahuna, and I’m excited to share my latest technical article. As a DevOps engineer, I was asked to manage user accounts and groups. Today, I’ll walk you through a script I wrote to automate this process. This script reads a text file containing usernames and their respective groups, creates users and groups as specified.

## Prerequisites
I ensured I have the necessary permissions to create users and groups, and write to the /var/log/ and /var/secure/ directories.

## The Script
Here’s a breakdown of the create_users.sh script:

### Log and Password Files: 
The script uses /var/log/user_management.log for logging actions and /var/secure/user_passwords.csv to securely store generated passwords. The /var/secure/ directory is set with restrictive permissions to ensure password security.

### Input Validation: 
The script checks if an input file is provided and exits with usage instructions if not.

### Logging Function: 
A simple function logs messages with timestamps to the log file.

### Password Generation: 
A function generates random 12-character passwords using /dev/urandom.

### Processing the Input File: 
The script reads each line of the input file, extracts the username and groups, and processes them:

- User Existence Check: If the user already exists, it logs the information and skips to the next line.
- User Creation: It creates the user with the specified personal group and a home directory.
- Additional Groups: If additional groups are specified, the script creates them if they don’t exist and adds the user to these groups.
- Password Setting: It generates and sets a random password for the user and logs this action.


## Running the Script
To run the script, I have saved it as create_users.sh, and I have provided the input file as an argument:


```
chmod +x create_users.sh
sudo ./create_users.sh employee_file
```

#### Input File
Here’s the input file (employee_file) looks like:

```
Kahuna; Backend,DevOps,HR
Dami; DevOps,HR
Sola; Backend
```

### Conclusion
This script automates the process of creating and managing users and groups, ensuring consistency and security. I am currently on a DevOps journey with HNG Internship. To learn more, check [HNG Internship](https://hng.tech/internship) and [HNG Premium](https://hng.tech/premium).
