# epico.group — hub

Landing page statica del gruppo epico: rimanda a **epico.ch** (selleria), **epicoyachts.swiss** (Epico Yachts Swiss) ed **epico.care** (manutenzione in abbonamento). Tre lingue (IT/DE/EN), tema chiaro/scuro automatico, loghi in SVG inline: un solo file `index.html`, nessuna dipendenza oltre ai font Google.

## Struttura

```
index.html   ← tutta la pagina (HTML, CSS, JS, loghi SVG)
Dockerfile   ← container Caddy per Coolify
Caddyfile    ← configurazione del server statico
```

## Modificare i testi

I testi italiani sono nell'HTML (`data-i18n="..."`); le traduzioni DE/EN sono nel dizionario `T` nello `<script>` in fondo al file, stessa chiave. Commit su `main` → Coolify ricostruisce il container.

## Deploy su Coolify (via tunnel Cloudflare)

1. Coolify → *New Resource* → *Public Repository* → `https://github.com/curzio-ops/epico-group`, branch `main`, **Build Pack: Dockerfile**.
2. Porta esposta: `80`. Nessuna variabile d'ambiente.
3. Non assegnare un dominio in Coolify (Traefik non è attivo sul server): serve solo la porta interna.
4. Cloudflare Zero Trust → Tunnel `epico-server` → *Public Hostname*: `epico.group` → `http://<nome-container>:80`. Aggiungere anche `www.epico.group` con lo stesso servizio.
5. Attivare *Auto Deploy* con il webhook GitHub: ogni push su `main` ricostruisce il container.

Test locale:

```bash
docker build -t epico-group . && docker run --rm -p 8080:80 epico-group
# http://localhost:8080
```
