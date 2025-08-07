#!/bin/bash

#Clean up
rm -r -f ./public/*
find . -name '.DS_Store' -type f -delete

# Build the project, if using a theme, replace with `hugo -t <YOURTHEME>
hugo -t hugo-theme-cleanwhite --quiet --cleanDestinationDir --minify --gc

# add CNAME back
echo "blog.gainskills.top" > public/CNAME
# for google AD sense
echo "google.com, pub-2131169764685829, DIRECT, f08c47fec0942fa0" > public/ads.txt
echo "google.com, pub-2131169764685829, DIRECT, f08c47fec0942fa0" > docs/ads.txt
echo "algolia.json" > public/.gitignore

# cp site maps, will remove this later
cp public/robots.txt docs/robots.txt
cp public/sitemap.xml docs/sitemap.xml

# add README/License
cp LICENSE public/LICENSE
cp README.md public/README.md

# function for git, "amend" for the minior fix (gramma, spelling)
changetogit () {
    if [ "$1" == "amend" ]
    then
        git add .
        git commit --amend --no-edit
        git push -f
    else
        git add .
        git commit -m "$1"
        git push
    fi
}

# main
if [ "$1" != "testing" ]
then
    echo -e "\033[0;32mDeploying updates to Algolia...\033[0m"
    npm run algolia

    if [ "$1" != "amend" ]
    then
        git push --recurse-submodules=on-demand
    fi

    echo -e "\033[0;32mpush changes on submoudle: theme...\033[0m"
    cd themes/hugo-theme-cleanwhite
    changetogit "$1"


    echo -e "\033[0;32mpush changes on submoudle: public...\033[0m"
    cd ../../public
    changetogit "$1"

    echo -e "\033[0;32mAdd changes to current repo....\033[0m"
    cd ..
    changetogit "$1"
fi
