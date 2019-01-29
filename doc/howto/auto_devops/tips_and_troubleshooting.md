# Auto DevOps - Tips and Troubleshooting

- [Tips](#tips)
- [Troubleshooting](#troubleshooting)

## Tips

### Useful Commands

- Besides this list of tips and troubleshooting, be sure to check out our list of [Useful Commands](./useful_commands.md)

### QA

- Consider adding `require 'pry'; binding.pry` breakpoint before [the last
assertion about
builds](https://gitlab.com/gitlab-org/gitlab-ce/blob/eb146e9abe08c3991b5a54237c24d15312c70ee8/qa/qa/specs/features/browser_ui/7_configure/auto_devops/create_project_with_auto_devops_spec.rb#L61)
to save yourself from setting up a full working Auto DevOps project.

### Helm/Tiller Communication

- One can run manual Helm commands from your local machine and communicate to our remote Tiller running on GKE. Check our [Useful Commands - Talking to Tiller](./useful_commands.md#talking-to-tiller) to know how to achieve it.

## Troubleshooting

### The Ingress is never assigned an IP address

If your Ingress is never assigned an IP address and you've waited for the IP address to appear on the cluster page for several minutes, it's quite possible that your GCP project has hit a limit of static IP addresses. See [how to clean up unused load balancers above](../auto_devops.md#unused-load-balancers).

### Error due to `Insufficient regional quota` for `DISKS_TOTAL_GB`

When [creating a new GKE cluster](https://docs.gitlab.com/ee/user/project/clusters/#creating-the-cluster), GKE will create persistent disks for you. If you are
running into the following error:

```
ResponseError: code=403, message=Insufficient regional quota to satisfy request: resource "DISKS_TOTAL_GB"
```

this would indicate you have reached your limit of persistent disks. See [how
to clean up unused persistent disks above](../auto_devops.md#unused-persistent-disks).