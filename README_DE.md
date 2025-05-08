# COMAL80 Sound2-Paket (nachladbar)

Dieses Repository enthält ein extrahiertes und eigenständig nutzbares **Sound-Paket** für **COMAL80** (z. B. auf dem C64). Es stellt die internen Assembler-Routinen für die COMAL-Soundbefehle bereit (`SOUND`, `TONE` usw.).

## Merkmale

- Basierend auf dem originalen Sound-Modul von COMAL80.
- Kann unabhängig geladen werden, per `LINK` Befehl
- Beinhaltet einen Patch für die **IRQ-Routine**, damit eine verlagerte Sound-Routine in einer anderen Speicherpage aufgerufen werden kann.
- Die Befehle sind unter leicht veränderten Namen verfügbar (z. B. `NOTE2`, `PULSE2` usw.), um Konflikte zu vermeiden.

## Verwendung

Das Paket kann von Diskette mit dem COMAL-Befehl nachgeladen werden:

```
LINK "SOUND2"
```

Die Befehle dieses Pakets entsprechen funktional den ursprünglichen Sound-Befehlen, sind jedoch mit einer `2` am Ende versehen:

- `NOTE2`
- `PULSE2`
- `PLAYSCORE2`
- (und weitere)

Dies ermöglicht es, originale und erweiterte Versionen parallel zu testen oder zu verwenden. **Sobald jedoch die neue IRQ-Routine aktiv ist, funktionieren die Originalbefehle (z. B. `NOTE`) nicht mehr korrekt**, da deren IRQ-Handler nicht mehr verwendet wird.

### Umschalten zwischen den Sound-Systemen

Um beide Routinen in einer COMAL-Sitzung nutzen zu können:

1. Beide Pakete laden:
   ```comal
   USE SOUND
   USE SOUND2
   ```

2. Zwischen den IRQ-Routinen umschalten mit:
   - `SET'IRQ` – leitet IRQs zur neuen Sound-Routine (für `NOTE2` usw.)
   - `RESET'IRQ` – stellt die originale COMAL-IRQ-Routine wieder her (für `NOTE` usw.)

So ist es möglich, beide Systeme flexibel zu testen oder zu kombinieren.

## Zweck

Das Ziel dieses eigenständigen Pakets war es, **eigene Erweiterungen oder Änderungen** an den Sound-Routinen zu ermöglichen, ohne das ursprüngliche COMAL80-System zu verändern. Damit sind Experimente und benutzerdefinierte Logik einfacher umsetzbar.

## Lizenz

MIT License – siehe Lizenzhinweise im Quelltext.

---

*Diese Dokumentation wurde mit Unterstützung einer KI (ChatGPT von OpenAI) erstellt.*
