# Roblox TypeScript Template
[![.github/workflows/deploy.yaml](https://github.com/Roblox-Duck-Studios/Roblox-TS-Template-Base/actions/workflows/deploy.yaml/badge.svg)](https://github.com/Roblox-Duck-Studios/Roblox-TS-Template-Base/actions/workflows/deploy.yaml) [![.github/workflows/ci.yaml](https://github.com/Roblox-Duck-Studios/Roblox-TS-Template-Base/actions/workflows/ci.yaml/badge.svg)](https://github.com/Roblox-Duck-Studios/Roblox-TS-Template-Base/actions/workflows/ci.yaml)

This isn't the usual template you would expect, its a mixture of multiplace but also singleplace. The "multiplace" idea behind this project is there is a common git submodule where you can share across projects, but you can skip the hassle of having multiple places in one project and eventually making your code create an hierarchical mess.

Do keep in mind that this is a barebones template, only minimal react, flamework and jest is included. Only the toolings are opinioned, the structure and code is up to you to decide. This is a fully managed rojo template but you can ignore it if you want to use it as a base for your own setup.

## Setup
Before installing, make sure you have `nodejs`, `pnpm`, `git` installed.
1. Clone the repository
2. Install pacakges with `pnpm install`
The postinstall script will also check your envionrment and checks if you have .env

### Api Keys
In your environment variables, you need to set up the following keys:
* PUBLISH_API_KEY: Permissions with `universe-places:write`
* LUAU_API_KEY: Permissions with `universe.place.luau-execution-session:read` and `universe.place.luau-execution-session:write`
* ASPHALT_API_KEY: Permissions with `asset:read` and `asset:write`
**There is a tiny issue where you must put quotation marks around the value of the .env file**. Please follow the following convention
```
API_KEY="your_api_key_here"
```

### Submodules
This template uses git submodules to manage shared code. To initialize and update the submodules, please run the following commands:
```
git submodule init
git submodule update
```
Also update the .gitmodules command

### Renovate
This project also prefers using [Renovate](https://docs.renovatebot.com/getting-started/installing-onboarding/) for updating dependencies. Please setup a account and read this documentation to get started with it.

### Repository Secrets
In your base repository setup `PUBLISH_API_KEY`, `LUAU_API_KEY`, `PAT`, and your common repository setup `PUBLISH_API_KEY`, `LUAU_API_KEY` as action secrets.
