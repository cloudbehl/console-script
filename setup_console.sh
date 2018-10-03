ipaddr=$(hostname -i);

yum install -y atomic-openshift-clients docker

service docker start
service firewalld stop

oc cluster up --public-hostname=$ipaddr --skip-registry-check=true

git clone https://github.com/openshift/console.git

curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs

curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum install -y yarn

wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.11.1.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin"

go get github.com/Masterminds/glide
go get github.com/sgotti/glide-vc

wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x ./jq
cp jq /usr/bin

mkdir -p /usr/local/go/src/github.com/openshift
cp -r console/ /usr/local/go/src/github.com/openshift/

cd console/ && ./build.sh

oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin
oc login -u admin
login
source ./contrib/oc-environment.sh
nohup ./bin/bridge > /dev/null 2>&1 &
