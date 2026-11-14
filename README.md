# ITDevConDemo

API REST in Delphi usata per demo e talk. All'avvio espone gli endpoint su `http://localhost:8080/api`.

## GitHub Actions

- **CI** (`.github/workflows/ci.yml`) parte su push, pull request e avvio manuale. Verifica struttura, rotte principali e assenza del vecchio path assoluto; pubblica poi i sorgenti della demo come artifact.
- **Package IDE build** (`.github/workflows/delphi-build.yml`) è manuale e prepara l'eseguibile compilato dall'IDE Delphi Community. Lo copia in `C:\ITDevCon-demo\build-input` e lo pubblica come artifact, con hash SHA-256.
- **Deploy demo** (`.github/workflows/deploy-demo.yml`) parte con ogni push su `main` (o manualmente). Prima avvia l'eseguibile in staging e testa `/api/hello`, `/api/users` e `/api/activities/301`; soltanto se gli smoke test passano crea una release immutabile e promuove la copia attiva sotto `C:\ITDevCon-demo\environments\<environment>`, insieme a `release.json` con commit e data di deploy.
- **Backup demo deployment** (`.github/workflows/backup-demo.yml`) crea manualmente un archivio della cartella `current` in `C:\ITDevCon-demo\backups` e lo conserva anche come artifact del run.
- **Rollback demo deployment** (`.github/workflows/rollback-demo.yml`) riceve l'identificativo di una release già presente in `releases`, salva prima la versione attiva e poi la promuove nuovamente a `current`.
- **Triage deployment failure** (`.github/workflows/triage-demo.yml`) parte automaticamente quando fallisce **Deploy demo** (oppure manualmente) e pubblica un report con inventario e metadata del deploy.
- **Deploy demo via FTP** (`.github/workflows/deploy-ftp.yml`) è l'esempio per la parte FTP delle slide: è solo manuale, protetto dall'Environment `ftp-demo` e richiede la variabile `FTP_URL` e i secret `FTP_USERNAME` / `FTP_PASSWORD` configurati nell'Environment.

Delphi Community non supporta la compilazione da riga di comando. Per questa demo compila quindi dall'IDE e avvia **Package IDE build** per preparare l'input del deploy. Con Delphi Professional o Enterprise puoi invece sostituire questo passaggio con una compilazione `msbuild` in CI.

La porta è configurabile con la variabile d'ambiente `ITDEVCON_PORT` (predefinita `8081`). Gli smoke test usano `18080`, evitando conflitti con l'app in esecuzione durante la demo.

## Environments

**Deploy demo** consente di scegliere `development`, `staging` o `production`. Per ogni ambiente il runner mantiene cartelle separate in `C:\ITDevCon-demo\environments\<environment>`. In GitHub apri **Settings → Environments** per vedere i deployment e, per `production`, aggiungi un required reviewer: il job resterà in attesa di approvazione prima di distribuire.

## Secrets

In ciascun Environment crea il secret `DEMO_API_TOKEN` da **Settings → Environments → _environment_ → Environment secrets**. Il job di smoke test lo passa come header `Authorization: Bearer ...` a `/api/users-auth/1`; il valore non viene mai scritto nei log. Usa valori diversi per `development`, `staging` e `production` per mostrare che ogni ambiente mantiene credenziali separate. La pipeline FTP usa nello stesso modo `FTP_USERNAME` e `FTP_PASSWORD` nell'Environment `ftp-demo`.

Per registrare il runner usa anche la label `delphi`; poi da GitHub apri **Actions → Package IDE build → Run workflow** e conferma il percorso dell'eseguibile Debug prodotto dall'IDE.

Per la demo di CD, esegui **Actions → Deploy demo → Run workflow**: sul computer del runner troverai l'eseguibile pubblicato in `C:\ITDevCon-demo\current\ITDevConDemo.exe`.

Per un rollback, copia il nome di una cartella in `C:\ITDevCon-demo\releases` e inseriscilo in **Actions → Rollback demo deployment → Run workflow**. Gli Environment GitHub sono il punto giusto per mettere approvazioni e credenziali: la pipeline FTP non contiene né stampa segreti.
