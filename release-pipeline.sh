#####################################
## Step-01: Create Namespaces ##
#####################################
kubectl create ns dev
kubectl create ns staging
kubectl create ns prod

##########################################
## Step-02: Create Service Connections ##
##########################################
23-dev-ns-aks-svc
23-qa-ns-aks-svc
23-prod-ns-aks-svc

##########################################
## Step-03: Create  Release Pipelines ##
##########################################
Empty jpb
Add Artifact 
Enabe continious deployment 

Agent Job
     - 

Add Tasks
    - Deploy to Kubernetes
        - Name = Create Secrete to allow image pull from ACR
        - Action = create secret
        - Kubernetes Service connection = 23-dev-ns-aks-svc
        - Namespace = dev
        - type of secret - dockerRegistry
        - Docker registry service connection = manual-aksdevops-acradedemo2 # one create for build pipeline

    - Deploy to Kubernetes
        - Name = Deploy to AKS
        - Action = deploy
        - Kubernetes Service connection = 23-dev-ns-aks-svc
        - Namespace = dev
        - Manifests = manifest location 
        - Containers = acradedemo2.azurecr.io/custom2aksnginxapp2:$(Build.BuildId) TAG included # container created during Docker build and push to ACR
        - Image Pull Secrets = dev-acradedemo2-secret # created during create secret task

    - Change pipeline name to = 01-app1-release-pipeline

#############################################################
## Step-04: Deploy Release Pipelines and check deployment ##
#############################################################
# Get Public IP
kubectl get svc -n dev

# Access Application
http://<Public-IP-from-Get-Service-Output>


########################################################################################
## Step-05: Update Deploy to AKS Task with Build.SourceVersion in Release Pipelines ##
########################################################################################
 #Before
Containers: aksdevopsacr.azurecr.io/custom2aksnginxapp1:$(Build.BuildId)

# After
Containers: aksdevopsacr.azurecr.io/custom2aksnginxapp1:$(Build.SourceVersion)   


#############################################################
## Step-06: Create QA, Staging and Prod Release Pipelines ##
#############################################################
Clone stages
    - qa
    - prod
Update to following:
    - create secret
        - service connection 
        - namespace
        - secret name
    - Deploy to AKS
        - service connection 
        - namespace
        - ImagePullSecret 