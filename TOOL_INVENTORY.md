# TOOL_INVENTORY.md — verified for this host (`/home/themodernhacker`)

Real inventory of the bug-bounty tooling installed on **this** machine. Paths are
the actual ones for user `themodernhacker` — **not** the `/root/...` container
paths the old inventory assumed.

> Regenerate this file authoritatively any time with:  `bash make-inventory.sh`
> It runs `command -v` on every tool, marks FOUND (with path) / MISSING, and
> rewrites the "Verified presence" section below. Run it after installing new tools.

## Tool locations (add all to PATH)
```bash
export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.foundry/bin:/usr/local/bin:/usr/bin"
export TOOLS="$HOME/tools"          # cloned repos (run via python3/go)
export WORDLISTS="$HOME/wordlists"  # plus /usr/share/seclists, /usr/share/wordlists
export NUCLEI_TEMPLATES="$HOME/nuclei-templates"
```
- `~/go/bin` — Go binaries (ProjectDiscovery, tomnomnom, etc.)
- `~/.local/bin` — pip/pipx/uv installs (Python + Rust-py tools, frida, foundry-py)
- `~/.cargo/bin`, `~/.foundry/bin` — Rust / Foundry (web3)
- `~/tools/<repo>` — cloned tools invoked by path (e.g. `python3 ~/tools/SSTImap/sstimap.py`)
- System (`/usr/bin`) — apt packages (nmap, masscan, sqlmap wrappers, etc.)

---

## Recon — subdomains & DNS
`subfinder`, `amass`, `assetfinder`, `findomain`(sys), `chaos`, `github-subdomains`,
`gitlab-subdomains`, `github-endpoints`, `puredns`, `shuffledns`, `massdns`(~/tools),
`dnsx`, `dnsvalidator`, `dnstake`, `gotator`, `alterx`, `regulator`(~/tools),
`subwiz`, `enumerepo`, `analyticsrelationships`, `hakip2host`, `mapcidr`, `asnmap`,
`cdncheck`, `hakoriginfinder`, `smap`, `subzy`(takeover), `can-i-take-over-xyz`(~/tools),
`crt`(~/go/bin, CT client). **CT logs: use crt.name — see `crtname.sh`.**

## Recon — HTTP probing, crawl, screenshots
`httpx`, `httprobe`, `anti-burl`, `tlsx`, `wappalyzer`, `favirecon`, `csprecon`,
`katana`, `hakrawler`, `gospider`, `gau`, `urlfinder`, `waybackurls`, `waymore`,
`gowitness`(screens), `VhostFinder`, `misconfig-mapper`, `Scopify`(~/tools),
`inscope`/`dsieve`/`unfurl`(scope+parse), `mapcidr`.

## Ports & network
`naabu`, `nmap`(sys), `masscan`(sys), `smap`, `brutespray`, `interactsh-client`(OOB),
`notify`(alerts), `grpcurl`, `ultimate-nmap-parser`(~/tools).

## Content / param discovery / fuzzing
`ffuf`, `ffufPostprocessing`(~/tools), `gobuster`, `dirsearch`, `feroxbuster`(sys),
`kr`/`kiterunner`(~/tools, API routes), `arjun`, `param-miner`(~/tools),
`ParamSpider`(~/tools), `x8`(if present), `p1radup`, `sus_params`(~/tools),
`gf`+`Gf-Patterns`(~/tools/Gf-Patterns), `qsreplace`, `uro`/`urless`, `anew`, `meg`,
`fff`, `gron`, `html-tool`, `unfurl`, `cent`(nuclei templates).

## JavaScript / secrets / source
`getJS`, `subjs`, `jsluice`, `LinkFinder`/`linkfinder`(~/tools+.local),
`xnLinkFinder`, `SecretFinder`/`secretfinder`, `mantra`, `sourcemapper`,
`roboxtractor`, `JSA`(~/tools), `trufflehog`, `gitleaks`, `ghleaks`, `gitdorks_go`,
`github-dorks`(~/tools), `dorks_hunter`(~/tools), `LeakSearch`(~/tools),
`porch-pirate`/`postleaksNg`(Postman leaks), `SwaggerSpy`(~/tools).

## Vuln scanners / classes
`nuclei`(+`~/nuclei-templates`), `vulnx`, `dalfox`(XSS), `kxss`/`Gxss`(XSS refl),
`XSStrike`/`xsstrike`, `crlfuzz`(CRLF), `sqlmap`, `ghauri`(SQLi), `commix`(cmd inj),
`SSTImap`(~/tools)/`TInjA`(template inj), `Corsy`/`corsy`(CORS), `OpenRedireX`/`openredirex`,
`toxicache`/`Web-Cache-Vulnerability-Scanner`(cache), `nomore403`(~/tools, 403 bypass),
`Gopherus`/`gopherus`(SSRF gopher), `blind-ssrf-chains`(~/tools ref),
`second-order`, `shortscan`(IIS), `CMSeeK`(~/tools), `nikto`/`wpscan`(sys).

## API / GraphQL
`kiterunner`/`kr`, `openapi`/`redocly`(spec tooling), `graphqlmap`/`GraphQLmap`,
`gqlspection`, `graphql-path-enum`, `sj`(swagger), `SwaggerSpy`.
**OpenAPI → MCP tools: see `skills/openapi-to-mcp/`.**

## Auth / crypto / tokens
`jwt_tool`/`jwt-tool-python`, `jws`, `julius`.

## Cloud / infra
`cloudlist`, `cloud_enum`, `s3scanner`/`S3Scanner`, `msftrecon`(~/tools, Azure),
`misconfig-mapper`, `google-cloud-sdk`(~/tools), `aws`/`az`(sys), `docker`(sys),
`Spoofy`(~/tools, SPF/DMARC), `EmailHarvester`(~/tools).

## Mobile / binary
`jadx`/`jadx-gui`, `apktool`(sys), `objection`, `frida`(+full suite: `frida-trace`,
`frida-ps`, `frida-ls-devices`, …), `exifray`/`exiftool`(sys).

## Web3 / smart contracts
`slither`(+suite), `solc`/`solc-select`, Foundry: `forge`/`cast`/`anvil`/`fray`
(`~/.foundry/bin`), `gato`(~/tools, GitHub Actions).

## Frameworks / orchestration (already installed)
`reconftw` + `reconftw_ai`(~/tools) — full recon pipelines. `bbot`(~/.local/bin +
`~/.bbot`) — modular OSINT/recon. `nerva`, `titus`, `brutus` (~/go/bin). `interlace`
(threaded runner). `nuclei-templates`(~), `wordlists`(~ + /usr/share).

## Utilities
`jq`, `httpie`/`http`/`https`, `js-beautify`/`css-beautify`/`html-beautify`,
`prettier`, `esparse`/`esvalidate`, `uv`/`uvx`, `notify`, `testssl.sh`(~/tools),
`wafw00f`, `cewler`(wordlists), `csprecon`.

## Wordlists & resolvers
- `/usr/share/seclists`, `/usr/share/wordlists` (rockyou etc.)
- `~/wordlists`, `~/tools/wordlists`
- `~/tools/resolvers.txt`, `~/tools/resolvers_trusted.txt`,
  `~/tools/subdomains_n0kovo_big.txt`
- gf patterns: `~/.gf` (+ `~/tools/Gf-Patterns`)

---

## Verified presence
_Generated 2026-09-29 20:18 UTC by make-inventory.sh_

### On PATH
- [x] `alterx` → /home/themodernhacker/go/bin/alterx
- [x] `amass` → /home/themodernhacker/go/bin/amass
- [x] `analyticsrelationships` → /home/themodernhacker/go/bin/analyticsrelationships
- [x] `anew` → /home/themodernhacker/go/bin/anew
- [x] `anti-burl` → /home/themodernhacker/go/bin/anti-burl
- [x] `anvil` → /home/themodernhacker/.local/bin/anvil
- [x] `apktool` → /usr/bin/apktool
- [x] `arjun` → /home/themodernhacker/.local/bin/arjun
- [x] `asnmap` → /home/themodernhacker/go/bin/asnmap
- [x] `assetfinder` → /home/themodernhacker/go/bin/assetfinder
- [x] `aws` → /usr/bin/aws
- [x] `az` → /usr/bin/az
- [x] `bbot` → /home/themodernhacker/.local/bin/bbot
- [x] `brutespray` → /home/themodernhacker/go/bin/brutespray
- [x] `cargo` → /home/themodernhacker/.cargo/bin/cargo
- [x] `cast` → /home/themodernhacker/.local/bin/cast
- [x] `cdncheck` → /home/themodernhacker/go/bin/cdncheck
- [x] `cent` → /home/themodernhacker/go/bin/cent
- [x] `chaos` → /home/themodernhacker/go/bin/chaos
- [x] `cloud_enum` → /home/themodernhacker/.local/bin/cloud_enum
- [x] `cloudlist` → /home/themodernhacker/go/bin/cloudlist
- [x] `commix` → /home/themodernhacker/.local/bin/commix
- [x] `corsy` → /home/themodernhacker/.local/bin/corsy
- [x] `crlfuzz` → /home/themodernhacker/go/bin/crlfuzz
- [x] `crt` → /home/themodernhacker/go/bin/crt
- [x] `csprecon` → /home/themodernhacker/go/bin/csprecon
- [x] `curl` → /usr/bin/curl
- [x] `dalfox` → /home/themodernhacker/go/bin/dalfox
- [x] `dirsearch` → /home/themodernhacker/.local/bin/dirsearch
- [x] `dnstake` → /home/themodernhacker/go/bin/dnstake
- [x] `dnsvalidator` → /home/themodernhacker/.local/bin/dnsvalidator
- [x] `dnsx` → /home/themodernhacker/go/bin/dnsx
- [x] `docker` → /usr/bin/docker
- [x] `dsieve` → /home/themodernhacker/go/bin/dsieve
- [x] `enumerepo` → /home/themodernhacker/go/bin/enumerepo
- [x] `exiftool` → /usr/bin/exiftool
- [x] `favirecon` → /home/themodernhacker/go/bin/favirecon
- [x] `feroxbuster` → /usr/bin/feroxbuster
- [x] `fff` → /home/themodernhacker/go/bin/fff
- [x] `ffuf` → /home/themodernhacker/go/bin/ffuf
- [x] `findomain` → /usr/local/bin/findomain
- [x] `forge` → /home/themodernhacker/.local/bin/forge
- [x] `frida` → /home/themodernhacker/.local/bin/frida
- [x] `frida-ps` → /home/themodernhacker/.local/bin/frida-ps
- [x] `frida-trace` → /home/themodernhacker/.local/bin/frida-trace
- [x] `gau` → /home/themodernhacker/go/bin/gau
- [x] `getJS` → /home/themodernhacker/go/bin/getJS
- [x] `gf` → /home/themodernhacker/go/bin/gf
- [x] `ghauri` → /home/themodernhacker/.local/bin/ghauri
- [x] `ghleaks` → /home/themodernhacker/go/bin/ghleaks
- [x] `git` → /usr/bin/git
- [x] `gitdorks_go` → /home/themodernhacker/go/bin/gitdorks_go
- [x] `github-endpoints` → /home/themodernhacker/go/bin/github-endpoints
- [x] `github-subdomains` → /home/themodernhacker/go/bin/github-subdomains
- [x] `gitlab-subdomains` → /home/themodernhacker/go/bin/gitlab-subdomains
- [x] `gitleaks` → /home/themodernhacker/go/bin/gitleaks
- [x] `go` → /usr/bin/go
- [x] `gobuster` → /home/themodernhacker/go/bin/gobuster
- [x] `gopherus` → /home/themodernhacker/.local/bin/gopherus
- [x] `gospider` → /home/themodernhacker/go/bin/gospider
- [x] `gotator` → /home/themodernhacker/go/bin/gotator
- [x] `gowitness` → /home/themodernhacker/go/bin/gowitness
- [x] `gqlspection` → /home/themodernhacker/.local/bin/gqlspection
- [x] `graphqlmap` → /home/themodernhacker/.local/bin/graphqlmap
- [x] `graphql-path-enum` → /home/themodernhacker/.local/bin/graphql-path-enum
- [x] `gron` → /home/themodernhacker/go/bin/gron
- [x] `grpcurl` → /home/themodernhacker/go/bin/grpcurl
- [x] `Gxss` → /home/themodernhacker/go/bin/Gxss
- [x] `hakip2host` → /home/themodernhacker/go/bin/hakip2host
- [x] `hakoriginfinder` → /home/themodernhacker/go/bin/hakoriginfinder
- [x] `hakrawler` → /home/themodernhacker/go/bin/hakrawler
- [x] `html-tool` → /home/themodernhacker/go/bin/html-tool
- [x] `httpie` → /home/themodernhacker/.local/bin/httpie
- [x] `httprobe` → /home/themodernhacker/go/bin/httprobe
- [x] `httpx` → /home/themodernhacker/go/bin/httpx
- [x] `inscope` → /home/themodernhacker/go/bin/inscope
- [x] `interactsh-client` → /home/themodernhacker/go/bin/interactsh-client
- [x] `interlace` → /home/themodernhacker/.local/bin/interlace
- [ ] `jadx` — MISSING
- [x] `jq` → /usr/bin/jq
- [x] `js-beautify` → /home/themodernhacker/.local/bin/js-beautify
- [x] `jsluice` → /home/themodernhacker/go/bin/jsluice
- [x] `jws` → /home/themodernhacker/.local/bin/jws
- [x] `jwt_tool` → /home/themodernhacker/.local/bin/jwt_tool
- [x] `katana` → /home/themodernhacker/go/bin/katana
- [ ] `kiterunner` — MISSING
- [x] `kr` → /home/themodernhacker/.local/bin/kr
- [x] `kxss` → /home/themodernhacker/go/bin/kxss
- [x] `linkfinder` → /home/themodernhacker/.local/bin/linkfinder
- [x] `mantra` → /home/themodernhacker/go/bin/mantra
- [x] `mapcidr` → /home/themodernhacker/go/bin/mapcidr
- [x] `masscan` → /usr/bin/masscan
- [x] `massdns` → /usr/local/bin/massdns
- [x] `meg` → /home/themodernhacker/go/bin/meg
- [x] `misconfig-mapper` → /home/themodernhacker/go/bin/misconfig-mapper
- [x] `naabu` → /home/themodernhacker/go/bin/naabu
- [x] `nikto` → /usr/bin/nikto
- [x] `nmap` → /usr/bin/nmap
- [x] `node` → /usr/bin/node
- [ ] `nomore403` — MISSING
- [x] `notify` → /home/themodernhacker/go/bin/notify
- [x] `npm` → /usr/bin/npm
- [x] `npx` → /usr/bin/npx
- [x] `nuclei` → /home/themodernhacker/go/bin/nuclei
- [x] `objection` → /home/themodernhacker/.local/bin/objection
- [x] `openapi` → /home/themodernhacker/.local/bin/openapi
- [x] `openredirex` → /home/themodernhacker/.local/bin/openredirex
- [x] `p1radup` → /home/themodernhacker/.local/bin/p1radup
- [x] `pip3` → /usr/bin/pip3
- [x] `pipx` → /usr/bin/pipx
- [x] `porch-pirate` → /home/themodernhacker/.local/bin/porch-pirate
- [x] `postleaksNg` → /home/themodernhacker/.local/bin/postleaksNg
- [x] `prettier` → /home/themodernhacker/.local/bin/prettier
- [x] `puredns` → /home/themodernhacker/go/bin/puredns
- [x] `python3` → /usr/bin/python3
- [x] `qsreplace` → /home/themodernhacker/go/bin/qsreplace
- [x] `redocly` → /home/themodernhacker/.local/bin/redocly
- [x] `roboxtractor` → /home/themodernhacker/go/bin/roboxtractor
- [x] `ruby` → /usr/bin/ruby
- [x] `rustc` → /home/themodernhacker/.cargo/bin/rustc
- [x] `s3scanner` → /home/themodernhacker/go/bin/s3scanner
- [x] `second-order` → /home/themodernhacker/go/bin/second-order
- [x] `secretfinder` → /home/themodernhacker/.local/bin/secretfinder
- [x] `shortscan` → /home/themodernhacker/go/bin/shortscan
- [x] `shuffledns` → /home/themodernhacker/go/bin/shuffledns
- [x] `sj` → /home/themodernhacker/go/bin/sj
- [x] `slither` → /home/themodernhacker/.local/bin/slither
- [x] `smap` → /home/themodernhacker/go/bin/smap
- [x] `solc` → /home/themodernhacker/.local/bin/solc
- [x] `solc-select` → /home/themodernhacker/.local/bin/solc-select
- [x] `sourcemapper` → /home/themodernhacker/go/bin/sourcemapper
- [x] `sqlmap` → /home/themodernhacker/.local/bin/sqlmap
- [x] `subfinder` → /home/themodernhacker/go/bin/subfinder
- [x] `subjs` → /home/themodernhacker/go/bin/subjs
- [x] `subwiz` → /home/themodernhacker/.local/bin/subwiz
- [x] `subzy` → /home/themodernhacker/go/bin/subzy
- [ ] `testssl.sh` — MISSING
- [x] `TInjA` → /home/themodernhacker/go/bin/TInjA
- [x] `tlsx` → /home/themodernhacker/go/bin/tlsx
- [x] `toxicache` → /home/themodernhacker/go/bin/toxicache
- [x] `trufflehog` → /home/themodernhacker/go/bin/trufflehog
- [x] `unfurl` → /home/themodernhacker/go/bin/unfurl
- [x] `urless` → /home/themodernhacker/.local/bin/urless
- [x] `urlfinder` → /home/themodernhacker/go/bin/urlfinder
- [x] `uro` → /home/themodernhacker/.local/bin/uro
- [x] `uv` → /home/themodernhacker/.local/bin/uv
- [x] `uvx` → /home/themodernhacker/.local/bin/uvx
- [x] `VhostFinder` → /home/themodernhacker/go/bin/VhostFinder
- [x] `vulnx` → /home/themodernhacker/go/bin/vulnx
- [x] `wafw00f` → /home/themodernhacker/.local/bin/wafw00f
- [x] `wappalyzer` → /home/themodernhacker/go/bin/wappalyzer
- [x] `waybackurls` → /home/themodernhacker/go/bin/waybackurls
- [x] `waymore` → /home/themodernhacker/.local/bin/waymore
- [x] `wget` → /usr/bin/wget
- [x] `wpscan` → /usr/bin/wpscan
- [x] `xnLinkFinder` → /home/themodernhacker/.local/bin/xnLinkFinder
- [x] `xsstrike` → /home/themodernhacker/.local/bin/xsstrike

### Cloned repos (run by path)
- [ ] `ParamSpider` — MISSING (/home/themodernhacker/tools/ParamSpider/paramspider.py)
- [x] `Corsy` → /home/themodernhacker/tools/Corsy/corsy.py
- [x] `dorks_hunter` → /home/themodernhacker/tools/dorks_hunter
- [x] `Gf-Patterns` → /home/themodernhacker/tools/Gf-Patterns
- [x] `Gopherus` → /home/themodernhacker/tools/Gopherus/gopherus.py
- [x] `kiterunner_repo` → /home/themodernhacker/tools/kiterunner
- [x] `LinkFinder` → /home/themodernhacker/tools/LinkFinder/linkfinder.py
- [x] `msftrecon` → /home/themodernhacker/tools/msftrecon
- [x] `param-miner` → /home/themodernhacker/tools/param-miner
- [x] `Photon` → /home/themodernhacker/tools/Photon/photon.py
- [x] `reconftw_ai` → /home/themodernhacker/tools/reconftw_ai
- [x] `reconftw` → /home/themodernhacker/tools/reconftw/reconftw.sh
- [x] `SecretFinder` → /home/themodernhacker/tools/SecretFinder/SecretFinder.py
- [x] `SSTImap` → /home/themodernhacker/tools/SSTImap/sstimap.py
- [x] `XSStrike` → /home/themodernhacker/tools/XSStrike/xsstrike.py

_Summary: 153 on-PATH tools found, 4 missing._
