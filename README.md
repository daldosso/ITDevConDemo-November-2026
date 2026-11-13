# ITDevConDemo

API REST in Delphi usata per demo e talk. All'avvio espone gli endpoint su `http://localhost:8080/api`.

## GitHub Actions

- **CI** (`.github/workflows/ci.yml`) parte su push, pull request e avvio manuale. Verifica struttura, rotte principali e assenza del vecchio path assoluto; pubblica poi i sorgenti della demo come artifact.
- **Delphi build** (`.github/workflows/delphi-build.yml`) è manuale e usa un runner Windows self-hosted con label `delphi`. Scarica le dipendenze, compila Win64 e pubblica l'eseguibile come artifact.

Il runner self-hosted deve avere Delphi 13 Professional o Enterprise installato e autorizzato per la compilazione da riga di comando. Delphi Community non supporta quel tipo di build in CI.

Per registrare il runner usa anche le label `windows` e `delphi`; poi da GitHub apri **Actions → Delphi build → Run workflow** e scegli la configurazione.
