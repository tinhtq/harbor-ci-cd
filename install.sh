#!/bin/bash
read -p "Enter Project Name (lowercase): " PROJECT_NAME  
echo  🎃 $PROJECT_NAME 🎃

sudo tee /root/.docker/config.json << EOF
{
    "auths": {
        "registry.agileops.dev": {
            "auth": "cm9ib3Qka25hdGl2ZSt1c2VyOmZ1cFpJQ2pKVE5HN0JpVmhHYXhjRVdlME85SThlZTRj"
        }
    }
}
EOF

# Generate the UUID
uuid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)

# Extract the first part of the UUID
uuid_first_part=$(echo "$uuid" | cut -d'-' -f1)

DOCKER_IMAGE_TAG=registry.agileops.dev/knative/$PROJECT_NAME:$uuid_first_part
sudo docker build -t $DOCKER_IMAGE_TAG .
echo $DOCKER_IMAGE_TAG
sudo docker push  $DOCKER_IMAGE_TAG

#Installed Kn
wget https://github.com/knative/client/releases/download/knative-v1.11.0/kn-linux-amd64
mv kn-linux-amd64 kn
chmod +x kn
sudo mv kn /usr/local/bin
# Create a Service
mkdir -p ~/.kube
cat << EOF >> ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJlRENDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUyT1RBM056YzROamd3SGhjTk1qTXdOek14TURRek1UQTRXaGNOTXpNd056STRNRFF6TVRBNApXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUyT1RBM056YzROamd3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFSbTQydkY2eVNyd1h1WDdTeHEydGJIckFhVU03RlVqMFlFKzZFY0s0VmYKVFVsbTFIczd5eEdrQzFvVUN3U1QyN1Z3S1dUOWNMUlM0V2NXOXlFV0JmT29vMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVUY0UnQwVXdVMnhTY0N1OTBvMVdDClBaUHFCbWN3Q2dZSUtvWkl6ajBFQXdJRFNRQXdSZ0loQVAvaFJGMWlScjJvaVBlbVkyUEtCYkJZZlI5dEVvSFQKRWcyY1BRWVpJeXppQWlFQThJbWtxeGRWQWZaL296UHJGTGpsS0dLK1pxU25meFBZY2ltQWxTbVd6dk09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://10.158.13.83:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrVENDQVRlZ0F3SUJBZ0lJT0cyMUpLbysvdk13Q2dZSUtvWkl6ajBFQXdJd0l6RWhNQjhHQTFVRUF3d1kKYXpOekxXTnNhV1Z1ZEMxallVQXhOamt3TnpjM09EWTNNQjRYRFRJek1EY3pNVEEwTXpFd04xb1hEVEkwTURjegpNREEwTXpFd04xb3dNREVYTUJVR0ExVUVDaE1PYzNsemRHVnRPbTFoYzNSbGNuTXhGVEFUQmdOVkJBTVRESE41CmMzUmxiVHBoWkcxcGJqQlpNQk1HQnlxR1NNNDlBZ0VHQ0NxR1NNNDlBd0VIQTBJQUJJdHRWZ05Udm1FUXNxNHMKVXFZeXlIV3RwbTc5Vm82c2VZQ3FLVENlc0V6dG14M21EZWxxdjhxejhCSm1XWmRmQk5qZ1g5OVJ3YU00T3ZPbApWSnBYWEttalNEQkdNQTRHQTFVZER3RUIvd1FFQXdJRm9EQVRCZ05WSFNVRUREQUtCZ2dyQmdFRkJRY0RBakFmCkJnTlZIU01FR0RBV2dCUS9nbTl0cDNNeTQwY2tJUXVRaW9JdGZiN3loVEFLQmdncWhrak9QUVFEQWdOSUFEQkYKQWlCTVdqS2lXUUVuRDlSeXdoVENlZFdweEVhQ1UwL3lHNm9ST0I0Qm9KZHhrZ0loQU5WN2lVenM1UlpJSU1kSApjV2lzWi9ONEdKWEdBdzB1UFNlYkRyMU1yT29ZCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0KLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkakNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdFkyeHAKWlc1MExXTmhRREUyT1RBM056YzROamN3SGhjTk1qTXdOek14TURRek1UQTNXaGNOTXpNd056STRNRFF6TVRBMwpXakFqTVNFd0h3WURWUVFEREJock0zTXRZMnhwWlc1MExXTmhRREUyT1RBM056YzROamN3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFUWC8yTG5EbXhOdlRLYlhIbXVMQWVlTG0zeHplN1ZtRWc5cDQ0ZHJBK0MKMG94cWpOeUt0WGkxdVdmZzlISlFjYkduQk83NVdSV2VVbUdZZXJJdXZWUTRvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVVA0SnZiYWR6TXVOSEpDRUxrSXFDCkxYMis4b1V3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnRmxocWxOZlIyWVY1WTVSb3VsTjBRcWs1TjlsSFBMOWoKSjhTclFsWGh2N0VDSUgrKysrOWhmeWF6VFhqTzY5eVBXeGVtWVpiWk9sa0tRbFVMdWZKYzRCaDYKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSU9SdFYwNE1yS0t0RU5KaFg3azh4VHV5U2xjMUgyczY4MXpYZHd1bVRmSXhvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFaTIxV0ExTytZUkN5cml4U3BqTElkYTJtYnYxV2pxeDVnS29wTUo2d1RPMmJIZVlONldxLwp5clB3RW1aWmwxOEUyT0JmMzFIQm96ZzY4NlZVbWxkY3FRPT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo=
EOF
kn service create $PROJECT_NAME --image $DOCKER_IMAGE_TAG --pull-secret regcred -n apps