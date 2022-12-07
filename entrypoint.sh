#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# configure git
echo "Run a command required by GitHub Actions"
git config --global --add safe.directory /github/workspace

# if arguments aren't set, the environment variables are expected to be set
if [ -z "${GITHUB_ACTOR}" ];
then
GITHUB_ACTOR=$env_github_actor
fi

if [ -z "${GITHUB_TOKEN}" ];
then
GITHUB_TOKEN=$env_github_token
fi

if [ -z "${USER_SITE_REPOSITORY}" ];
then
USER_SITE_REPOSITORY=$env_user_site_repository
fi

USER_NAME="${GITHUB_ACTOR}"
MAIL="${GITHUB_ACTOR}@users.noreply.github.com"

echo "${USER_NAME} - ${MAIL}"

gem install bundler

git submodule init
git submodule update

echo "#################################################"
echo "Make some files executable"
SCRIPTS_DIR="share-card-creator"
SHELL_FILE="shell.sh"
# SHELL_FILE_NO_PLAY="shell-no-play.sh"

echo "#################################################"
echo "Install imagemagick"

sh -c "apk add --no-cache --virtual .build-deps libxml2-dev shadow autoconf g++ make && apk add --no-cache imagemagick-dev imagemagick"

echo "#################################################"
echo "workspace_directory: $env_workspace_directory"

sh -c "chmod 777 $env_workspace_directory/*"
sh -c "chmod 777 $env_workspace_directory/.*"

echo "#################################################"
echo "Experimental Ruby 3.1 YJIT feature to improve liquid template rendering"

export RUBYOPT="--enable=yjit"

echo "#################################################"
echo "Starting the Jekyll Action"

sh -c "bundle install"
sh -c "bundle update"
sh -c "jekyll build --future"

cp -f $env_workspace_directory/_site/share-card-creator/shell.sh $SCRIPTS_DIR
sh -c "chmod +x $SCRIPTS_DIR/$SHELL_FILE"
sh -c "chmod +x $SCRIPTS_DIR/script.py"
# cp -f _site/share-card-creator/shell-no-play.sh $SCRIPTS_DIR
# sh -c "chmod +x $SCRIPTS_DIR/$SHELL_FILE_NO_PLAY"
sh -c "chmod +x $SCRIPTS_DIR/script-no-play.py"


echo "#################################################"
cd $SCRIPTS_DIR
sh -c "pwd"
sh -c "ls -lta"
cat $SHELL_FILE
echo "Execute $SHELL_FILE"
sh -c "./$SHELL_FILE"
# cat $SHELL_FILE_NO_PLAY
# echo "Execute $SHELL_FILE_NO_PLAY"
# sh -c "./$SHELL_FILE_NO_PLAY"

cd ..

echo "#################################################"
echo "Publishing all images"
git add uploads/\*
git status

echo "Set user data."
git config --global user.name "${USER_NAME}"
git config --global user.email "${MAIL}"

git diff-index --quiet HEAD || echo "Commit changes." && git commit -m 'Jekyll build from Action - add images' && echo "Push." && git push origin

git reset --hard

rm -rf $SCRIPTS_DIR
rm -rf $env_workspace_directory/_site

echo "#################################################"
echo "Add $env_workspace_directory/_site as submodule"
echo "git submodule add -f https://${GITHUB_TOKEN}@github.com/${USER_SITE_REPOSITORY}.git ./_site"
git submodule add -f https://${GITHUB_TOKEN}@github.com/${USER_SITE_REPOSITORY}.git ./_site
cd $env_workspace_directory/_site
git checkout main
git pull

echo "#################################################"
echo "Added submodule"

cd ..
echo "sh -c "chmod 777 $env_workspace_directory/*""
sh -c "chmod 777 $env_workspace_directory/*"
echo "sh -c "chmod 777 $env_workspace_directory/.*""
sh -c "chmod 777 $env_workspace_directory/.*"

echo "#################################################"
echo "Starting the Jekyll Action a second time"
sh -c "jekyll build --future"

echo "#################################################"
echo "Second Jekyll build done"

echo "#################################################"
echo "Now publishing"

ls -ltar
cd $env_workspace_directory/_site
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
