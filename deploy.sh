set -ex
cd App
npm install @angular/cli
./node_modules/@angular/cli/bin/ng  build --prod --build-optimizer
npm run test-headless
cd ..
export AMI=$(packer build -machine-readable packer-ami-app.json | grep AMIs | tail -1 | cut -d ':' -f4 | cut -c2- | rev | cut -c3- | rev)

echo "AMI = $AMI"

sed -ie "s,ami-.*,${AMI}\",g" aws_image.tf

terraform apply -refresh=true -auto-approve