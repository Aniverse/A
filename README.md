
## A, I/O bench and system info

```
bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/a)"
bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a)
bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/a)
wget -q https://github.com/Aniverse/A/raw/i/a && bash a
```

```
No IP               bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a) -a
No IPIP             bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a) -b
No IOtest           bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a) -c
No IPIP & IOtest    bash <(wget -qO- https://github.com/Aniverse/A/raw/i/a) -bc
```

![Seedbox-USB](https://github.com/Aniverse/A/raw/i/pictures/Seedbox-USB.png)
![Seedbox-SH-HDD](https://github.com/Aniverse/A/raw/i/pictures/Seedbox-SH-HDD.png)
![Seedbox-FH-HDD](https://github.com/Aniverse/A/raw/i/pictures/Seedbox-FH-HDD.png)
![Seedbox-FH-SSD](https://github.com/Aniverse/A/raw/i/pictures/Seedbox-FH-SSD.png)
![Seedbox-PM](https://github.com/Aniverse/A/raw/i/pictures/Seedbox-PM.png)



### A Troubleshooting

如果碰到 `-sh: syntax error near unexpected token `('` 的提示，先输入 `bash`，再执行脚本  
已知未解决的问题：某些软／硬 RAID 硬盘检测不到  
如果还有什么别的问题，请开 issue  


## B, sysctl info

```
bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/b)
wget -q https://github.com/Aniverse/A/raw/i/b && bash b
```

