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
  "https://api.github.com/user/repos" \
  -d "{\"name\":\"$name\"}"

git push -u origin main
git checkout -b dev
git push -u origin dev

# Protect main branch
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/aj8gh/$name/branches/main/protection" \
  -d '{
  "required_status_checks": {
    "strict": true,
    "checks": [
      {
        "context": "build"
      }
    ]
  },
  "required_pull_request_reviews": null,
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": true,
  "enforce_admins": true
}'

# Protect dev branch
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/aj8gh/$name/branches/dev/protection" \
  -d '{
  "required_status_checks": {
    "strict": false,
    "checks": null
  },
  "required_pull_request_reviews": null,
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": true,
  "enforce_admins": false
}'

idea "$project_dir"
