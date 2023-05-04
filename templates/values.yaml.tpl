
controller:
  serviceAccount:
    create: false # A service account will be created for you if set to true. Set to false if you want to use your own.
    name: ebs-csi-controller-sa # Name of the service-account to be used/created.
    annotations: {}

node:
  tolerations:
  - key: "monitoring-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  resources: {}
  serviceAccount:
    create: true
    name: ebs-csi-node-sa
