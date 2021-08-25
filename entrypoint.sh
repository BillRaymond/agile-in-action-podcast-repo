#!/bin/bash
set -e

gem install bundler

echo "Set user data."
git config --global user.name "${USER_NAME}"
git config --global user.email "${MAIL}"

git submodule init
git submodule update

echo "#################################################"
echo "Remove some files"
sh -c "rm Dockerfile"
sh -c "rm README.md"
sh -c "rm entrypoint.sh"
sh -c "rm .gitignore"

echo "#################################################"
echo "Make some files executable"
SCRIPTS_DIR="share-card-creator"
SHELL_FILE="shell.sh"

echo "#################################################"
echo "Install imagemagick"

sh -c "apk add --no-cache --virtual .build-deps libxml2-dev shadow autoconf g++ make && apk add --no-cache imagemagick-dev imagemagick"

echo "#################################################"
echo "Add ./_site as submodule"

git submodule add -f https://${GITHUB_TOKEN}@github.com/${USER_SITE_REPOSITORY}.git ./_site
cd ./_site
git checkout main
git pull

cd ..

sh -c "chmod 777 /github/workspace/*"
sh -c "chmod 777 /github/workspace/.*"

echo "#################################################"
echo "Added submodule"

echo "#################################################"
echo "Starting the Jekyll Action"

sh -c "bundle install"
sh -c "jekyll build"

cp -f _site/share-card-creator/shell.sh $SCRIPTS_DIR
sh -c "chmod +x $SCRIPTS_DIR/$SHELL_FILE"
sh -c "chmod +x $SCRIPTS_DIR/script.py"

echo "#################################################"
cd $SCRIPTS_DIR
sh -c "pwd"
sh -c "ls -lta"
cat $SHELL_FILE
echo "Execute $SHELL_FILE"
sh -c "./$SHELL_FILE"

cd ..
rm -rf $SCRIPTS_DIR

echo "#################################################"
echo "Publishing all images"
git add uploads/\*
git status

git diff-index --quiet HEAD || echo "Commit changes." && git commit -m 'Jekyll build from Action' && echo "Push." && git push origin

echo "#################################################"
echo "Starting the Jekyll Action a second time"
sh -c "jekyll build"

echo "#################################################"
echo "Jekyll build done"

echo "#################################################"
echo "Now publishing"
SOME_TOKEN=${GITHUB_TOKEN}

USER_NAME="${GITHUB_ACTOR}"
MAIL="${GITHUB_ACTOR}@users.noreply.github.com"

ls -ltar
cd ./_site
ls -ltar
git log -2
git remote -v

# Create CNAME file for redirect to this repository
if [[ "${CNAME}" ]]; then
  echo ${CNAME} > CNAME
fi

touch .nojekyll
echo "Add all files."
git add -f -A -v
git status

git diff-index --quiet HEAD || echo "Commit changes." && git commit -m 'Jekyll build from Action' && echo "Push." && git push origin

echo "#################################################"
echo "Published"
