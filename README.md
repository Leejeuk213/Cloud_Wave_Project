# Terraform으로 EKS 구성 

Cloud wave 3기 프로젝트로 2주동안 개발한 내용을 정리하였다.  

Terraform을 사용하여 EKS 환경 구성하는 작업을 맡았다.  
스케일링을 위해 Karpenter를 사용해야했고 또 외부 접근 엔드포인트를 제공하기 위해 ALB Controller 구성해야했는데 
두 요소 모두 Terraform을 통해 구축하는 것에 성공하였다.  

또 Velero와 Global Accelerator를 이용한 Multi Region DR을 시도하였다.  

## 테라폼 생성 아키텍처  

서울(ap-northeast2)에 가용영역 3개(a,b,c) 각각 Public subnet, Private subnet 생성   
가용영역 a에만 Bastion server용 EIP 생성 또 Nat gateway 생성  
가용영역 a에 RDS 생성할 예정으로 DB전용 Private subnet 생성

EKS, Karpenter, ALB Controller 생성  

EKS는 V 1.29 사용  
Karpenter는 v0.31.3 사용  
ALB Controller는 AWS ALB Controller 사용하여 Ingress 설정하였음  
완성된 ALB Controller는 여러 서비스들(ISTIO Dashboard, grafana dashboard, kubecost dashboard)을 접근할 떄 사용되었다.  

기본적으로 EKS Endpoint는 Private IP로 지정 개발 시에는 0.0.0.0으로 올 Ingress 허용하고  
실제로 테스트할 때는 VPN IP 사용하여 접근하였음

![](./terraform.png)  

## Kube ops view 사용 Karpenter 작동 확인

![](./kubeopsview.gif)


## 전체 프로젝트 아키텍처

![](./archi.png)

