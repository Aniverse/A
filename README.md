
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


## B, sysctl info

```
bash -c "$(wget -qO- https://github.com/Aniverse/A/raw/i/b)"
bash <(curl -s https://raw.githubusercontent.com/Aniverse/A/i/b)
wget -q https://github.com/Aniverse/A/raw/i/b && bash b
```

