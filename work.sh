#!/bin/bash

file="/home/ubuntu/rep.txt"
sudo su
while read -r line;
  do
      current_line=$(echo "$line")
			
      # get the user from user part
      user=$(echo "$current_line" | cut -d: -f1)
      password=$(echo "$current_line" | cut -d: -f2)
	  ## get id from user part
      user_id=$(echo "$current_line" | cut -d: -f3)
      ## get the group from part
      group=$(echo "$current_line" | cut -d: -f4)
      mkdir "/home/$user"
			
      useradd -m -d "/home/$user" -s "/bin/bash" -u "$user_id" "$user"
      groupadd "$group"
      ## Add the user to the specified group
    usermod -aG "$group" "$user"
      echo "$user:$password" | chpasswd
  done < "$file"

# file="/home/ubuntu/rep.txt"
# sudo su

# while IFS=: read -r line; do
#     user=$(echo "$line" | cut -d: -f1)
#     password=$(echo "$line" | cut -d: -f2)
#     uid=$(echo "$line" | cut -d: -f3)
#     group=$(echo "$line" | cut -d: -f4)

#     # Create the user's home directory
#     mkdir "/home/$user"

#     # Add the user with the specified UID and home directory
#     useradd -m -d "/home/$user" -s "/bin/bash" -u "$uid" "$user"

#     # create group
#     grep -q "^$group:" /etc/group || groupadd "$group"

#     # Add the user to the specified group
#     usermod -aG "$group" "$user"

#     # Set the user's password
#     echo "$user:$password" | chpasswd
# done < "$file"


declare -a users

sudo su
users=("James:password1:2001:others" 
       "Jerry:password2:2002:others" 
       "Mary:password3:2003:support"
       "John:password4:2004:support")

       #create group
    sudo groupadd others
    sudo groupadd support
    
    #add users to groups
    sudo gpasswd --m james,jerry others
    sudo gpasswd --m mary,john support

## Loop through an array
sudo su

for item in ${users[@]}
    do
        current_item=$(echo $item)
        user=$(echo $current_item | cut -d: -f1)
        password=$(echo $current_item | cut -d: -f2)
        user_id=$(echo $current_item | cut -d: -f3)
        group=$(echo $current_item | cut -d: -f4)

        user_home="/home/$user"

        mkdir $dir

        useradd -d $user_home -b "/bin/bash" $user

        echo "$user:$password" | chpasswd
        
        # Add the user to the specified group
        usermod -aG "$group" "$user"
    done 

exit

