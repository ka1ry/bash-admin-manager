# Bash Admin Manager

![bash-admin-manager](https://img.shields.io/badge/version-1.0-green)

This is a simple project called **bash-admin-manager**, which I created to learn more about Bash scripting. The project allows you to store and read keys, hash and decrypt values, and manage containers.

## Features
* Store and read keys
* Hash and decrypt values
* Manage containers

## Usage
The main file of this project is `main.sh`, which can be executed by running the following command in your terminal:

./main.sh


When you run the `main.sh` file, if there are containers created, you will be presented with an option to select your container. If there are no containers, you can run `main.sh` with the argument "i" to create a new container.

All containers are stored in the `containers` folder.

When you select a container, you will be taken to the Container Manager, which is a shell-based interface that allows you to execute different commands.

### Credentials command
The `credentials` command, which can also be accessed using the aliases `c` or `creds`, allows you to use the following commands:

* `w` or `write` - Allows you to write credentials to a file.
* `r` or `read` - Allows you to read credentials from a file.
* `d` or `delete` - Allows you to delete credentials from a file.

### Hasher command
The `hasher` command, which can also be accessed using the aliases `h` or `hash`, allows you to hash and decrypt values using the following commands:

* `e` or `encrypt` - Allows you to encrypt a value.
* `d` or `decrypt` - Allows you to decrypt a value.

## Future Plans
I created this project with the hope that someone will find it useful. I plan to build something bigger from this later, so stay tuned for future updates!

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Conclusion
Thank you for checking out **bash-admin-manager**. If you have any suggestions or ideas for improvements, please feel free to let me know. I hope you find this project useful!
