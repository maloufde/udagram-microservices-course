# Übersicht zu Kubernetes

## Kurzanleitung zum Installieren einer Minikube-Lernumgebung auf Win10Pro

Für eine K8s Lernumgebung eignet sich **minikube** auf dem PC bzw. Notebook. Wie auch _Docker Desktop_ wird _minikube_ 
in **Windows 10 Pro** als VM in **Hyper-V** installiert. Anders als bei Docker Desktop wird die VM nicht jedesmal
beim Stoppen entfernt, sondern bleibt bestehen.

* Download **Minikube Installer** von https://github.com/kubernetes/minikube/releases/latest/download/minikube-installer.exe
* Download **kubectl** von https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/windows/amd64/kubectl.exe
* Installiere Minikube und kopiere kubectl in das gleiche Verzeichnis
* Nimm das Verzeichnis in den System-**PATH** auf und zwar so, dass es vor den Dockerverzeichnissen liegt 
  (Docker liefert ebenfalls ein kubectl mit)

Links:
* https://kubernetes.io/docs/tasks/tools/install-minikube/
* https://kubernetes.io/docs/tasks/tools/install-kubectl/

### Minikube-Setup
Der Setup erstellt eine minikube-VM in Hyper-V, verbindet sich dann mit der VM und 
führt dort eine Installation von Kubernetes durch. kubectl wird ebenfalls vorkonfiguriert, so dass
die neue Umgebung per default eingestellt ist.

Vorher sollte im Hyper-V-Manager ein neuer virtueller Switch angelegt werden, z.B.:
* Öffnen des Hyper-V-Manager als Administrator
* Manager f. virtuelle Switches > Externen virtuellen Switch mit dem Namen "MyMinikube" o.ä. erstellen
* Anwenden / Speichern
* Schließen des Hyper-V-Manager

**Wichtig:** Setup, Starten und Stoppen von Minikube muss man "als Administrator ausführen".

Setup in Powershell:
* `minikube start --vm-driver="hyperv" --hyperv-virtual-switch="MyMinikube" --v=7 --alsologtostderr`  
   Das dauert jetzt eine Weile, ggf. 10 Minuten ...
* `minikube stop`

Nach dem Setup liegen im User- bzw. Admin-Homeverzeichnis die Konfigurationen `.minikube` und `.kube`

Links: 
* https://kubernetes.io/docs/setup/learning-environment/minikube/
* https://blogs.msdn.microsoft.com/wasimbloch/2017/01/23/setting-up-kubernetes-on-windows10-laptop-with-minikube/

### Minikube Starten und Stoppen 
Beim Wiederholten Starten und Stoppen reicht dann `minikube start` bzw. `minikube stop` - natürlich immer als Administrator.

Für kubectl ist der Kontext _minikube_ nach der Installation voreingestellt. 
Wenn man zwischenzeitlich mit anderen arbeitet, kann man mit `kubectl config use-context minikube` 
wieder zurückkehren.

## Kubectl 

Die Konfiguration des Clusters erfolgt mit **kubectl**. Zentrale Objekte sind:
* Namespace
* Pod
* Deployment
* Service
* ConfigMap
* Secret

Diese lassen sich jeweils mit `kubectl get pod`, `kubectl get deployment`, `kubectl get all` usw. auflisten.

Das Erstellen von Resourcen erfolgt i.d.R. über yaml-Dateien, die dann mit dem Befehl `kubectl apply -f <file.yml>` 
den Cluster konfigurieren.
 
Hat man den Namen einer Resource ermittelt, dann sind folgende Befehle nützlich:
* `kubectl logs pod/udagram-restapi-feed-6675fffff-lgmjj -f`
* `kubectl exec -it pod/udagram-restapi-feed-6675fffff-lgmjj -- /bin/bash`

Um z.B. per Browser vom lokalen System in den Cluster zu gelangen, ist ein Port-Forwarding möglich:
* `kubectl port-forward pod/udagram-restapi-feed-67c8db84dd-jn6rw 8080:8080` ermöglicht     
  http://localhost:8080/api/v0/feed im Browser

## Konzepte

### Namespaces
* Docs: https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/

### Pods
* Docs: https://kubernetes.io/docs/concepts/workloads/pods/

### Services  
* Docs: https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/

## Leitfaden zur Konfiguration des Udagram-Clusters
* Umgebungsvariablen in `ConfigMap` erstellen
* Sensitive Informationen in `Secret` als base64-encodiert ablegen, z.B:
  * `echo -n "geheim" | base 64 -w0`
  * `cat ~\.aws\credentials | base 64 -w0`
* Deployments mit Pod-Templates erstellen:
  ** 
* Services erstellen (aufpassen! Die richtigen Pod-Selektoren verwenden)
* Der Reverse-Proxy referenziert die Servicenamen (nicht die Pods)
## Setup Namespace and preset it for kubectl
* `kubectl apply -d udagram-prod-ns.yml`
* `kubectl config set-context --current --namespace=udagram-prod`

## Setup Environment
* kubectl apply -f envs\udagram-configmap.yml
* kubectl apply -f envs\udagram-env-secret.yml
* kubectl apply -f envs\udagram-aws-secret.yml

## Create Services
* kubectl apply -f services\udagram-feed-service.yml
* kubectl apply -f services\udagram-user-service.yml
* kubectl apply -f services\udagram-proxy-service.yml
* kubectl apply -f services\udagram-frontend-service.yml

## Deploy Applications
* kubectl apply -f deployments\restapi-feed-deployment.yml
* kubectl apply -f deployments\restapi-user-deployment.yml
* kubectl apply -f deployments\reverseproxy-deployment.yml
* kubectl apply -f deployments\frontend-deployment.yml

## Verify on localhost
* `kubectl port-forward service/udagram-reverseproxy 8080:8080` (API)
* `kubectl port-forward service/udagram-frontend 8100:8100` (Frontend)

## Scale Up / Down
Scale up/down the feed deployment: `kubectl scale deployment/udagram-restapi-feed --replicas=3`



