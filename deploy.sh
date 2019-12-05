hugo

echo 'Hugo done!'

cd public

git add .

git commit -m "update"

git push origin master

git push --force git@git.dev.tencent.com:superchun/superchun.coding.me.git master:master

echo 'deploy done!'

cd ..

git add .

git commit -m "update"

git push origin master


