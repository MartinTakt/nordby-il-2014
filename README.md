# Nordby IL 2014 GitHub Pages

Dette er en separat GitHub Pages-pakke for Nordby IL 2014, uten kobling til Takt-nettsiden.

## Innhold

- `index.html` sender videre til hovedsiden
- `nordby-il-2014.html` er selve siden
- `nordby-il-2014.css` er stilen
- `nordby-il-2014-config.js` brukes hvis dere vil koble til Supabase senere
- `nordby-il-2014-supabase.sql` er klart hvis dere vil ha delt database

## Anbefalt publisering

1. Opprett en ny GitHub-repo, for eksempel `nordby-il-2014`.
2. Legg inn alt innholdet i denne mappen i repo-roten.
3. Gå til `Settings` → `Pages`.
4. Velg `Deploy from a branch`.
5. Velg `main` og `/ (root)`.
6. Etter publisering får dere en lenke som ligner:
   `https://brukernavn.github.io/nordby-il-2014/`

## Viktig

- GitHub Pages-lenken er offentlig hvis noen kjenner URL-en.
- `robots.txt` og `noindex` er lagt inn for å gjøre siden mindre synlig i søk, men dette er ikke ekte tilgangskontroll.
- Hvis dere senere vil ha delt aktivitet mellom spillere og foreldre, fylles `nordby-il-2014-config.js` med Supabase-verdier.
