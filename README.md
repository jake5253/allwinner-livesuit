# allwinner-livesuit

Download livesuit_installer.run
`chmod +x livesuit_installer.run`
`sudo ./livesuit_installer.run`

make sure you have DKMS installed first
`sudo apt install dkms`

if you want to play with the files before install:
(+79 in the command below is the first line of the embedded tar file. If you alter the run-file, you'll have to update that number in the script)
`tail -n +79 ./livesuit_installer.run > ./livesuit.tar.xz`

recompile the .run file:
`cat install.sh livesuit.tar.xz > installer.run`
