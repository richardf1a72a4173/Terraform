- Generated by: [Infracost](https://infracost.io)
- Time generated: 2025-06-22 15:34:46 BST

Project: main

Name Monthly Qty Unit Monthly Cost module.avm-res-containerservice-managedcluster.azurerm\_kubernetes\_cluster.this ↳ Uptime SLA 730 hours $73.00 ↳ default\_node\_pool      ↳ Instance usage (Linux, pay as you go, Standard\_DS2\_v2) 730 hours $83.22      ↳ os\_disk          ↳ Storage (P10, LRS) 1 months $17.92 module.avm-res-containerservice-managedcluster.module.nodepools\["unp1"].azurerm\_kubernetes\_cluster\_node\_pool.this\[0] ↳ Instance usage (Linux, pay as you go, Standard\_DS2\_v2) 730 hours $83.22 ↳ os\_disk      ↳ Storage (P10, LRS) 1 months $17.92 azurerm\_linux\_virtual\_machine.mgmt ↳ Instance usage (Linux, pay as you go, Standard\_DS2\_v2) 730 hours $83.22 ↳ os\_disk      ↳ Storage (P4, LRS) 1 months $4.80 azurerm\_container\_registry.myacr ↳ Registry usage (Standard) 30 days $20.00 ↳ Storage (over 100GB) Cost depends on usage: $0.10 per GB ↳ Build vCPU Cost depends on usage: $0.0001 per seconds azurerm\_private\_dns\_zone.zone ↳ Hosted zone 1 months $0.50 Project total $383.80

Overall total $383.80

31 cloud resources were detected:  
∙ 5 were estimated  
∙ 26 were free