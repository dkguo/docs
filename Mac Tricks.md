* Use Touch ID to authenticate sudo in Terminal
  * `sudo nano /etc/pam.d/sudo`
  * Add this line to the end of the file:
    ```
    auth sufficient pam_tid.so
    ```
  * Reference: https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal