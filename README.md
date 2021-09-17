# 101Assessment

## 1. Implement Infrastructure

### Prerequisites

Terrafrom version >= 0.13.x

### Implementation steps

To Implement infrastructure in AWS we use Terraform steps are as below.

Run terraform init

```
terrafrom init
```

Run terrafrom plan to view what will deploy.

```
terrafrom plan
```

Apply and provision infrastructure on AWS

```
terrafrom apply
```

To delete infrastructure

```
terrafrom destroy
```

## 2. Deploy Application 

### Prerequisites

hem version >= 3.x

To deploy Appliation we use helm, kuberenetes package manager.

Deployment and upgrade step as below.

Update nginx-controller helm chart as dependency chart.

```
helm dependency update ./101applicatio
```

Install Application

export env variables

```
ex:-
export project=101bank
export env=PROD
export RELEASEVERSION='1.0.0'  ## Application docker image new release version

```

install application

```
helm upgrade --install "$PROJECT"-"$ENV" ./101application --set image.tag="$RELEASEVERSION" --create-namespace -n 101ap
```



