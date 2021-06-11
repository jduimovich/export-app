REPO=export-gitops
REPO_URL=https://github.com/$MY_GITHUB_USER/$REPO.git
REPO_ORIGIN=https://$MY_GITHUB_USER:$MY_GITHUB_TOKEN@github.com/$MY_GITHUB_USER/$REPO.git


echo $MY_GITHUB_TOKEN | gh auth login --with-token
rm -rf $REPO  
git clone $REPO_URL
cd $REPO
git remote remove origin
git remote add origin $REPO_ORIGIN

git config --global user.email "jduimovich@gmail.com"
git config --global user.name "John Duimovich"

export BR="gitops-"$(date "+%d%m%y-%s")
git checkout -b  $BR 
rm -rf export
cp -r ../export export 
git add .
git commit -m "new gitops" 
git push origin $BR
gh pr create -t "Gitops Exporter" -B main  -b "auto submit"