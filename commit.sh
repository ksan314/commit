#!/bin/bash

# make sure current working directory is the desired git repo
#############################################################

while true
do
read -rp $'\n'"Is your current working directory the git repo you want to modify? [Y/n] " repoCheck
	repoCheck=${repoCheck:-Y}
	if [ "$repoCheck" == Y ] || [ "$repoCheck" == y ] || [ "$repoCheck" == yes ] || [ "$repoCheck" == YES ] || [ "$repoCheck" == Yes ]
	then
		read -rp $'\n'"Are you sure your current working directory is the git repo you want to modify? [Y/n] " repocheckConfirm
			repocheckConfirm=${repocheckConfirm:-Y}
			case $repocheckConfirm in
				[yY][eE][sS]|[yY]) break;;
				[nN][oO]|[nN]);;
				*);;
			esac
			REPLY=
	else
		exit
	fi
done










# set git branch to main
########################

git config --global init.defaultbranch main










# get git credentials if needed
###############################

while true
do
git config --global --list
read -rp $'\n'"Is the git username and email correct? [Y/n] " gitCredentials
    gitCredentials=${gitCredentials:-Y}
    if [ "$gitCredentials" == Y ] || [ "$gitCredentials" == y ] || [ "$gitCredentials" == yes ] || [ "$gitCredentials" == YES ] || [ "$gitCredentials" == Yes ]
    then
        gitCredentials=true
        read -rp $'\n'"Are you sure the git username and email are correct? [Y/n] " gitcredentialsConfirm
        gitcredentialsConfirm=${gitcredentialsConfirm:-Y}
        case $gitcredentialsConfirm in
            [yY][eE][sS]|[yY]) break;;
            [nN][oO]|[nN]);;
            *);;
        esac
        REPLY=
    else
        gitCredentials=false
        read -rp $'\n'"Are you sure the git username and email are NOT correct? [Y/n] " gitcredentialsConfirm
        gitcredentialsConfirm=${gitcredentialsConfirm:-Y}
        case $gitcredentialsConfirm in
            [yY][eE][sS]|[yY]) break;;
            [nN][oO]|[nN]);;
            *);;
        esac
        REPLY=
    fi
done










# set git credentials if needed
###############################

if [ "$gitCredentials" == false ]
then

    # get username
    while true
    do
    read -rp $'\n'"Enter git username: " userName
        if [ -z "$userName" ]
        then
            echo -e "\nYou must enter a username\n"
        else
            read -rp $'\n'"Are you sure \"$userName\" is your git username? [Y/n] " usernameConfirm
            usernameConfirm=${usernameConfirm:-Y}
            case $usernameConfirm in
                [yY][eE][sS]|[yY]) break;;
                [nN][oO]|[nN]);;
                *);;
            esac
            REPLY=
        fi
    done


    # get user email
    while true
    do
    read -rp $'\n'"Enter git email for username \"$userName\": " gitEmail
        if [ -z "$gitEmail" ]
        then
            echo -e "\nYou must enter an email\n"
        else
            read -rp $'\n'"Are you sure \"$gitEmail\" is your git email? [Y/n] " gitemailConfirm
            gitemailConfirm=${gitemailConfirm:-Y}
            case $gitemailConfirm in
                [yY][eE][sS]|[yY]) break;;
                [nN][oO]|[nN]);;
                *);;
            esac
            REPLY=
        fi
    done
    
    
    # set git credentials
    git config --global user.name "$userName"
    git config --global user.email "$gitEmail"
    
fi










# automatically get git repo info
#################################

# get repo name
repoName=$(pwd | grep -Eo '[^/]*$')


# get repo url
repoURL=$(grep -i 'url' ~/"$repoName"/.git/config | grep -Eo '[[:graph:]]*$')










# delete commit history and push to online git repo
###################################################

# delete the .git folder
rm -rf .git


# re-initialize the repo
git init
git remote add origin "$repoURL"
git remote -v


# add all files to github and commit changes
git add --all
git commit -am "Initial commit"


# force update to master branch of GitHub repo
printf "\e[1;32m\nEnter PAT instead of password\n\e[0m"
git push -f origin main
