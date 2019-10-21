# Setup Logging to CloudWatch with `fluentd`

## Check Prerequisites
* Please follow the instructions at https://docs.aws.amazon.com/de_de/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html to
make sure that your Cluster-Node IAM role is able to forward logs to CloudWatch (i.e. attach `CloudWatchAgentServerPolicy`).

* Note your **cluster_name** and **region_name**.

## Installation of  `fluentd`
Siehe [AmazonCloudWatch-Documentation](https://docs.aws.amazon.com/de_de/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs.html) 
to get an overview. 

The _DaemonSet_ provided at the given [AWS fluent.yaml](https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/fluentd/fluentd.yaml) did not work out of the box 
with my Kubernetes cluster. If you face similar problems, have a look at the modified `aws-cloudwatch-fluentd-modified.yaml`. Amongst others i had to remove the parsing of `dmesg` due to a fluentd-issue. 

```
# create cloudwatch-namespace
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/cloudwatch-namespace.yaml

# create cluster-info
kubectl create configmap cluster-info \
--from-literal=cluster.name=maloufde-udagram \
--from-literal=logs.region=us-east-1 -n amazon-cloudwatch

# create the DaemonSet (AWS provided one did not work, maybe review and try the modified one)
# kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/fluentd/fluentd.yaml
kubectl apply -f ./logging/aws-cloudwatch-fluentd.yaml

# check fluentd is running on each node
kubectl get pods -n amazon-cloudwatch
```
## Check CloudWatch
* Go to https://console.aws.amazon.com/cloudwatch within the same AWS region (e.g. us-east-1)
* Choose Logs 
* You should see _log groups_:
  * /aws/containerinsights/maloufde-udagram/application
    * **fluentd-cloudwatch**-...**amazon-cloudwatch_fluentd-cloudwatch**-...
    * **udagram-restapi-feed**-...**udagram-development_udagram-restapi-feed**-...
    * ... and logs for all other container-logs


## Links
* https://docs.aws.amazon.com/de_de/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs.html
* https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
