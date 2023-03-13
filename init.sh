#! /bin/zsh

name=$1
package=$2
project_dir="/Users/adamjonas/Projects/$name"
DIR="$(dirname "$(readlink -f "$0")")"
token=$(cat "$DIR/.token")

if [[ -d "$project_dir" ]] then
  echo "Directory $project_dir already exists"
  exit 1
fi

cp -R "/Users/adamjonas/Projects/spring-boot-skeleton" "$project_dir"
cd "$project_dir"

rm -rf .git **/*.iml .idea logs **/logs target **/target

mv "./application/src/main/java/io/github/aj8gh/skeleton" "./application/src/main/java/io/github/aj8gh/$package"
mv "./application/src/test/java/io/github/aj8gh/skeleton" "./application/src/test/java/io/github/aj8gh/$package"
mv "./component-test/src/test/java/io/github/aj8gh/skeleton" "./component-test/src/test/java/io/github/aj8gh/$package"

sed -i '' "s/spring-boot-skeleton/$name/g" ./renovate.json
sed -i '' "s/spring-boot-skeleton/$name/g" ./README.md
sed -i '' "s/Spring Boot Skeleton/$name/g" ./README.md
sed -i '' "s/Spring Boot Skeleton/$name/g" ./README.md
sed -i '' "s/spring-boot-skeleton/$name/g" ./pom.xml
sed -i '' "s/spring-boot-skeleton/$name/g" ./application/pom.xml
sed -i '' "s/spring-boot-skeleton/$name/g" ./coverage/pom.xml
sed -i '' "s/spring-boot-skeleton/$name/g" ./component-test/pom.xml
sed -i '' "s/>skeleton</>$package</g" ./pom.xml
sed -i '' "s/skeleton/$package/g" "$project_dir/application/src/main/java/io/github/aj8gh/$package/Application.java"
sed -i '' "s/skeleton/$package/g" "$project_dir/application/src/test/java/io/github/aj8gh/$package/ApplicationTest.java"
sed -i '' "s/skeleton/$package/g" "$project_dir/component-test/src/test/java/io/github/aj8gh/$package/componenttest/TestConfigCucumber.java"

git init
git add .
git commit -m 'Initial commit'
git remote add origin "git@github.com:AJ8GH/$name.git"

# Create repo
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$name\"}"

git push -u origin main

idea "$project_dir"
