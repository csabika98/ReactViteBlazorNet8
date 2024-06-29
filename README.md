# React + Vite + Blazor + .NET 8

## TO INSTALL IT ON MAC
```powershell
make -f installMac.mk
```

## TO INSTALL IT ON LINUX
```powershell
sudo apt-get install make
make -f install.mk
```
## TO INSTALL IT ON WINDOWS
```powershell
powershell -ExecutionPolicy ByPass -File .\install.ps1
```
## Screenshots

![](screenshots/img.png)
![](screenshots/img_1.png)
![](screenshots/img_2.png)
![](screenshots/img_3.png)

## PROXY SERVER INCLUDED
```
http://localhost:8888 -> VITE + REACT
http://localhost:8888/api -> .NET8 + Blazor Pages BACKEND
```

## Installation
## Installation script works only on Windows 

* use the installation script, install.ps1 (you will need to run as administrator)
```
powershell -ExecutionPolicy ByPass -File .\install.ps1
```


* <b>Install NodeJS dependencies</b>

```
npm install
```


## RUN
To run the app
- It will run React + Vite
- Build BLAZOR with .NET 8
```
npm run dev
```



This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh
