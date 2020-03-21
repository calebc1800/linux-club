#!/bin/bash

####NEEDS TO BE TESTED####

check_arguments() {
    #Checks to make sure that there are arguments are there
    if [ -z "$1" ]; then 
    echo "[-] Please run this script with the new password for root user as an argument."
    fi
}
root_check() {
    # Check for root
    if [[ $EUID -ne 0 ]]; then
        echo "User must be run as root"
        exit 1
    fi  
}
working_dir() {
    #Changes directory to script's directory in order to access array list
    work_dir=$(dirname $0)
    cd $work_dir
}
add_repositories() {
    #adds additional repositories from file
    readarray add_rep < $1 #$1 = location of repository list
    for i in ${add_rep[@]}; do
        add-apt-repository $i -y >/dev/null
        [ $? -eq 0 ] && echo "[+] $1 has been successfully added" || echo "[-] ERROR: Could not add $1 to repository list" #Custom Error
    done
    apt update
}
system_upgrade() {
    #simple update and upgrade
    apt update 
    apt upgrade -y
}
package_install() {
    #installs new packages
    readarray add_pkg < $1 #$1 = location of package list
    for i in ${add_pkg[@]}; do
        apt install $i -y >/dev/null
        [ $? -eq 0 ] && echo "[+] $1 has been successfully installed" || echo "[-] ERROR: Could not install $1" #Custom Error
    done
}
package_purge() {
    #remove unnecessary/security risk packages
    readarray purge_pkg < $1 #$1 = location of package list
    for i in ${purge_pkg[@]}; do
        apt purge $i -y >/dev/null
        [ $? -eq 0 ] && echo "[+] $1 has been successfully purged" || echo "[-] ERROR: Could not purge $1" #Custom Error
    done
}
root_pass_change() {
    # change root password
    sh -c "echo root:$1 | chpasswd"
    echo "Password has been changed to $1"
}
new_users(){
    # add user for standard
    readarray new_users < $1 #$1 = location of new_users list
    for i in ${new_users[@]}; do
        egrep "^$i" /etc/passwd > /dev/null
        if [ $? -eq 0 ]; then
            echo "$i exists!"
        else
            # sets the password to username change this later maybe
            pass=$(perl -e 'print crypt($ARGV[0], "password")' $i) #password is same as username
            useradd -m -p $pass $i
            [ $? -eq 0 ] && echo "[+] User has been added to the system!" || echo "[-] Failed to add user!"
        fi
    done
}

###Operation Start###
check_arguments
root_check
working_dir
add_repositories ./add_repositories.txt
system_upgrade
package_install ./package_install.txt
package_purge ./package_purge.txt
root_pass_change
new_users ./new_users.txt
echo "All done!"
exit 0