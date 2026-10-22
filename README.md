<br />
<div align="center">
  <a href="https://github.com/CuboBuilder/commacord">
    <img src="resources/commacord.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Commacord</h3>

  <p align="center">
    An Open-Source Discord Client
    <br/>
    <br/>
    <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/CuboBuilder/commacord"> 
    <img alt="Total Downloads" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fsanghai.org%2Fcommacord-downloads%2F"> 
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/CuboBuilder/commacord/build.yml?branch=master"> 
    <img alt="GitHub" src="https://img.shields.io/github/license/CuboBuilder/commacord"> 
  </p>
</div>

# About Commacord
  Commacord is an Open-Source Discord client that respects your privacy. Commacord is based on [Datcord](https://github.com/gamingdoom/datcord), an Open-Source Discord client that respects your privacy, and thus on [Neutron](https://github.com/gamingdoom/neutron), which means that it uses Firefox/Gecko under the hood instead of Chromium. Commacord is also a sample application of Neutron, which combats the monopoly of Chromium-based browsers through the use of Firefox/Gecko to create Progressive Web Applications (PWAs).

# Install
- # Linux
  - ## Flatpak
    ``flatpak install io.github.CuboBuilder.Commacord``
  - ## Arch Linux
    - If you use Arch or an Arch-based distro, Commacord is available on the AUR:
	
      ``aura -A commacord-bin``
  - ## Debian, Ubuntu, Mint, etc.
    - Commacord is available as a `.deb` file from [releases](https://github.com/CuboBuilder/commacord/releases/).
  - ## Appimage
    - Grab the AppImage from [releases](https://github.com/CuboBuilder/commacord/releases/) and run it. If you choose to integrate it, run
    
       ``~/Applications/Commacord-* --appimage-portable-home``
  - ## Tarball
    - Grab the appropriate tarball from the [releases](https://github.com/CuboBuilder/commacord/releases/). Then:
	    ```bash
	    tar -xvf commacord-linux-x86_64.tar
	    cd commacord
	    ./launch-app
	    ```
- # Windows
  - Installers for Windows are available from [releases](https://github.com/CuboBuilder/commacord/releases/).
- # MacOS
  - Highly experimental MacOS versions of Commacord are available from [releases](https://github.com/CuboBuilder/commacord/releases/).
  - I don't have any way to test these builds, so they might not work.

# Building from source
```
git clone https://github.com/CuboBuilder/commacord.git --recurse-submodules -j8 && cd commacord
./build.sh
```

`./build.sh` bundles [Equicord](https://github.com/equicord/equicord) into the
build automatically (`scripts/integrate-equicord.sh`). The pre-built Firefox
extension lives in `extensions/equicord/`; rebuild it from source with
`tools/build-equicord.sh` (needs Node.js >= 22 and pnpm).

## Links
Commacord opens links in your default browser. Discord's own URLs
(`discord.com`) are kept inside the app so navigation, login and calls keep
working; every other link is handed off to your system browser
(see `openInDefaultBrowser` / `openInDefaultBrowserRegex` in
`resources/config.json`).
# Credits
- [@TheRedXD](https://github.com/TheRedXD), who designed Commacord's logo.
- Everyone who created issues.
