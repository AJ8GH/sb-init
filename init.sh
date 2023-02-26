#! /bin/zsh

name=$1
package=$2
project_dir="/Users/adamjonas/Projects/$name"

cp -R "/Users/adamjonas/Projects/spring-boot-skeleton" "$project_dir"
cd "$project_dir"

rm -rf .git **/*.iml .idea logs **/logs target **/target

git init

mv "./application/src/main/java/io/github/aj8gh/skeleton" "./application/src/main/java/io/github/aj8gh/$package"
mv "./application/src/test/java/io/github/aj8gh/skeleton" "./application/src/test/java/io/github/aj8gh/$package"

sed -i '' "s/spring-boot-skeleton/$name/g" ./renovate.json
sed -i '' "s/spring-boot-skeleton/$name/g" ./README.md
sed -i '' "s/Spring Boot Skeleton/$name/g" ./README.md
sed -i '' "s/Spring Boot Skeleton/$name/g" ./README.md
sed -i '' "s/spring-boot-skeleton/$name/g" ./pom.xml
sed -i '' "s/spring-boot-skeleton/$name/g" ./application/pom.xml
sed -i '' "s/spring-boot-skeleton/$name/g" ./coverage/pom.xml
sed -i '' "s/>skeleton</>$package</g" ./pom.xml
sed -i '' "s/skeleton/$package/g" "$project_dir/application/src/main/java/io/github/aj8gh/$package/Application.java"
sed -i '' "s/skeleton/$package/g" "$project_dir/application/src/test/java/io/github/aj8gh/$package/ApplicationTest.java"

idea "$project_dir"
