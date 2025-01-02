# EKS Application Deployment with Docker, Kubernetes, Helm, and Terraform

This repository demonstrates a complete workflow for deploying a containerized application to AWS Elastic Kubernetes Service (EKS). It covers tasks like containerization, infrastructure provisioning, application deployment, and automation through CI/CD.

---

## Tasks Completed

### Task 1: Containerize the Application
- **Application**: A Python web application located in the `app/` folder.
- **Dockerfile**: The application is containerized using the `Dockerfile` in the same folder.
- **Steps**:
  1. Build the Docker image:
     ```bash
     docker build -t my-app:latest ./app
     ```
  2. Test locally:
     ```bash
     docker run -p 5000:5000 my-app:latest
     ```
  3. Push to your container registry:
     ```bash
     docker tag my-app:latest <your-registry>/my-app:latest
     docker push <your-registry>/my-app:latest
     ```

---

### Task 2: Create AWS EKS Infrastructure Using Terraform
- **Terraform Configuration**: Files are located in the `infra/` folder.
- **Steps**:
  1. Initialize Terraform:
     ```bash
     terraform init
     ```
  2. Apply the configuration:
     ```bash
     terraform apply
     ```
  3. Outputs:
     - Kubeconfig for accessing the cluster.

---

### Task 3: Deploy the Application to Kubernetes
- **Kubernetes Manifests**: Available in the `manifests/` folder.
- **Steps**:
  1. Deploy the application:
     ```bash
     kubectl apply -f manifests/deployment.yaml
     kubectl apply -f manifests/service.yaml
     ```
  2. Access the application using the service endpoint.

---

### Task 4: Package and Deploy with Helm
- **Helm Chart**: Located in the `helm-chart/my-app/` folder.
- **Steps**:
  1. Package and deploy the Helm chart:
     ```bash
     helm install my-app helm-chart/my-app
     ```
  2. Customize deployment by editing `values.yaml`.

---

### Automate CI/CD
- **GitHub Actions Workflow**: Located at `.github/workflows/cicd.yml`.
- **Automation Includes**:
  - Build and push the Docker image.
  - Apply Terraform scripts to provision the EKS cluster.
  - Deploy the application using the Helm chart.

---

## Prerequisites
- Docker installed locally.
- Terraform installed locally.
- AWS CLI configured with sufficient permissions.
- Kubernetes CLI (`kubectl`) installed locally.
- Helm installed locally.

---