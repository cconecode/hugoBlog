hugo

cd public

git add .

git commit -m "$1"

git push origin master

cd ..

git add .

git commit -m "update"

git push origin master
