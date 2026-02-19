# After Clean Up - Optimise

```PowerShell
wsl --shutdown
diskpart

# Inside diskpart
select vdisk file="D:\WSL\Ubuntu-24.04\ext4.vhdx"
attach vdisk readonly

# From another terminal
Optimize-VHD -Path "D:\WSL\Ubuntu-24.04\ext4.vhdx" -Mode Full

# Back to diskpart
detach vdisk
exit
```
