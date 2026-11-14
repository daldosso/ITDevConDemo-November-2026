# ITDevConDemo

API REST in Delphi usata per demo e talk. All'avvio espone gli endpoint su `http://localhost:8080/api`.

## GitHub Actions

- **CI** (`.github/workflows/ci.yml`) parte su push, pull request e avvio manuale. Verifica struttura, rotte principali e assenza del vecchio path assoluto; pubblica poi i sorgenti della demo come artifact.
- **Delphi build** (`.github/workflows/delphi-build.yml`) è manuale e usa un runner Windows self-hosted con label `delphi`. Scarica le dipendenze, compila Win64 e pubblica l'eseguibile come artifact.
- **Deploy demo** (`.github/workflows/deploy-demo.yml`) parte con ogni push su `main` (o manualmente), compila `Release` e simula il Continuous Deployment sul runner. Crea una release immutabile in `C:\ITDevCon-demo\releases\<run>-<commit>` e promuove la copia attiva in `C:\ITDevCon-demo\current`, insieme a `release.json` con commit e data di deploy.
- **Backup demo deployment** (`.github/workflows/backup-demo.yml`) crea manualmente un archivio della cartella `current` in `C:\ITDevCon-demo\backups` e lo conserva anche come artifact del run.
- **Rollback demo deployment** (`.github/workflows/rollback-demo.yml`) riceve l'identificativo di una release già presente in `releases`, salva prima la versione attiva e poi la promuove nuovamente a `current`.
- **Triage deployment failure** (`.github/workflows/triage-demo.yml`) parte automaticamente quando fallisce **Deploy demo** (oppure manualmente) e pubblica un report con inventario e metadata del deploy.
- **Deploy demo via FTP** (`.github/workflows/deploy-ftp.yml`) è l'esempio per la parte FTP delle slide: è solo manuale, protetto dall'Environment `ftp-demo` e richiede la variabile `FTP_URL` e i secret `FTP_USERNAME` / `FTP_PASSWORD` configurati nell'Environment.

Il runner self-hosted deve avere Delphi 13 Professional o Enterprise installato e autorizzato per la compilazione da riga di comando. Delphi Community non supporta quel tipo di build in CI.

Per registrare il runner usa anche le label `windows` e `delphi`; poi da GitHub apri **Actions → Delphi build → Run workflow** e scegli la configurazione.

Per la demo di CD, esegui **Actions → Deploy demo → Run workflow**: sul computer del runner troverai l'eseguibile pubblicato in `C:\ITDevCon-demo\current\ITDevConDemo.exe`.

Per un rollback, copia il nome di una cartella in `C:\ITDevCon-demo\releases` e inseriscilo in **Actions → Rollback demo deployment → Run workflow**. Gli Environment GitHub sono il punto giusto per mettere approvazioni e credenziali: la pipeline FTP non contiene né stampa segreti.
