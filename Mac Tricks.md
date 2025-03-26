* Use Touch ID to authenticate sudo in Terminal
  * `sudo nano /etc/pam.d/sudo`
  * Add this line to the end of the file:
    ```
    auth sufficient pam_tid.so
    ```
  * Reference: https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal

### John the Ripper Password Cracker
https://github.com/openwall/john?tab=readme-ov-file
* Install
  ```
  cd john/src
  ./configure
  make -s clean && make -sj4
  ```
* Usage:
  * For iWork: the jumbo-version of JtR provides a tool to convert an iWork (pages) file into a problem JtR can tackle.
    ```
    ./run/iwork2john.py encrypted.pages > encryped.hash
    ```
  * For digits only password
    ```
    ./run/john --fork=12 --incremental=digits encryped.hash
    ```
    * `--fork` to use multiple CPU cores
    * Modify `run/john.conf` `[Incremental:Digits]` to set the number of digits
  * Show the cracked password
    ```
    ./run/john --show encryped.hash
    ```