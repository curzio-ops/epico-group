# Stage 1: rasterize favicon / icons / OG image from the SVG sources
FROM alpine:3.20 AS gen
RUN apk add --no-cache librsvg ttf-dejavu
WORKDIR /gen
COPY favicon.svg og.svg ./
RUN rsvg-convert -w 32  -h 32  favicon.svg -o favicon-32.png \
 && rsvg-convert -w 180 -h 180 favicon.svg -o apple-touch-icon.png \
 && rsvg-convert -w 192 -h 192 favicon.svg -o icon-192.png \
 && rsvg-convert -w 512 -h 512 favicon.svg -o icon-512.png \
 && rsvg-convert og.svg -o og.png

# Stage 2: static server
FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html favicon.svg robots.txt sitemap.xml llms.txt site.webmanifest /srv/
COPY --from=gen /gen/*.png /srv/
EXPOSE 80
