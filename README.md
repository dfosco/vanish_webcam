# Webcam con effetti di sparizione

Il video viene elaborato sul computer e non viene registrato né inviato a un
server. La finestra di anteprima e la webcam virtuale contengono solo il video
e l'effetto, senza menu, istruzioni o altre scritte sovrapposte.

## ☕ Buy me a coffee

Se ti piace il progetto e vuoi supportarlo, puoi offrirmi un caffè tramite [PayPal](https://paypal.me/nicovic17) oppure [Revolut](https://revolut.me/nicoauriemma).


## Download per Windows

[Scarica VanishCam.exe](https://firebasestorage.googleapis.com/v0/b/graficammece-9b254.firebasestorage.app/o/vanish_cam%2FVanishCam.exe?alt=media&token=82017e0a-52b9-420d-88ba-a4640d5e2ffc) e avvialo con un doppio clic. Non serve installare Python.

## macOS (Apple Silicon): with or without OBS

### Install and run without OBS

Use **macOS 13 or later**, native **arm64 Python 3.12**, and a webcam.
No Rosetta, OBS, microphone, or virtual-camera driver is needed for the local
preview. For example, install Python with `brew install python@3.12`, then,
from the repository directory:

```sh
bash ./AVVIA_MAC.command
bash ./AVVIA_MAC.command --mode normal
bash ./AVVIA_MAC.command --mode naruto
```

The launcher creates `.venv-local` beside the source and installs the existing
`requirements.txt` if imports are missing. It works from any working directory,
including paths containing spaces. You can also double-click
`AVVIA_MAC.command` in Finder; if the executable permission was lost, run
`chmod +x ./AVVIA_MAC.command` first. To select a Python installation, use
`PYTHON=/absolute/path/to/python3.12 bash ./AVVIA_MAC.command`.
An existing Intel or different-Python `.venv-local` must be removed and recreated.

At first launch, allow camera access for Terminal (or the application hosting
Python) in **System Settings → Privacy & Security → Camera**, then restart the
app if necessary. Exit the frame for four seconds to capture the background.
Use `1`/`2` to choose an effect, `V` to trigger it, `R` to reappear, and `Q`/`Esc`
to quit. Use the keyboard to exit the menu on macOS: OpenCV's Cocoa backend does
not support the window-visibility query used on other platforms.
Naruto audio plays through the speakers, not through a virtual microphone.

The first run downloads the segmentation model and, for Normal mode, the gesture
model from Google; subsequent runs reuse `models/`. Video is processed locally.
If Python from python.org reports `CERTIFICATE_VERIFY_FAILED`, run its
**Install Certificates.command** from the Python 3.12 Applications folder;
do not disable TLS verification.

### Send directly to OBS Virtual Camera

Install the **Apple Silicon version of OBS Studio 30 or later**. One-time setup:
open OBS, click **Start Virtual Camera**, approve its camera extension in System
Settings if prompted, then **Stop Virtual Camera** and quit OBS.
The location of the extension approval depends on the macOS version.

```sh
bash ./AVVIA_MAC.command --virtual-camera --virtual-backend obs --mode normal
```

Select **OBS Virtual Camera** in the receiving meeting/video app. OBS need not
remain running: its installed camera extension is used by `pyvirtualcam`.
Keep OBS's own virtual-camera producer stopped while VanishCam is producing.
If explicitly requested output cannot open, the app reports an error rather
than silently falling back. Running `python vanish_cam.py` directly retains the
original auto-detect/fallback behavior; the Mac launcher defaults to local-only.

### Use VanishCam in an OBS scene

Run `bash ./AVVIA_MAC.command --mode naruto` (local preview only).
In OBS, add **macOS Screen Capture** and select the **Webcam - Anteprima**
window; grant OBS **Screen Recording** permission in System Settings if needed.
On OBS versions offering the older **Window Capture** source, that also works.
Crop window decorations if required, keep the preview visible, then start the
virtual camera **from OBS**. This lets OBS mix the effect with other sources.

**Without OBS, the supported output is the local preview, not a system-wide
virtual webcam.** macOS needs an installed camera extension for other apps to
receive virtual-camera video. This project does not ship its own signed camera
extension; Unity Capture is Windows-only and v4l2loopback is Linux-only.
Do not capture OBS Virtual Camera back into OBS while also using it as output.
See [pyvirtualcam's supported cameras and macOS setup](https://github.com/letmaik/pyvirtualcam#supported-virtual-cameras).

### Code map and portability assessment

| Component | Responsibility / assessment |
| --- | --- |
| `vanish_cam.py` | Main supported entry point: CLI/menu → model download → capture → background calibration → gesture/hand recognition → effects → clean preview and optional virtual output. macOS explicitly uses AVFoundation, falling back to OpenCV auto-selection; Windows keeps DirectShow and Linux auto-selection. |
| `naruto_effect.py` | NumPy/OpenCV hand geometry, procedural smoke, and transparent log compositing; no platform-specific APIs. |
| `vanish_sound.py` | Nonblocking preloaded pygame MP3 playback, with optional ffplay fallback; portable without Windows-only audio APIs. |
| `assets/`, `hand_landmarker.task`, `models/` | Shared image/audio and MediaPipe model resources. `models/` is populated at first run. |
| `test_vanish_cam.py`, `test_naruto_effect.py`, `test_video_output.py` | Gesture, compositing, resource cleanup, clean-output, and platform-selection regression tests; run from the repository root. |
| `run3.py`, `face_landmarker.task` | Separate legacy face/hand meme prototype. It references a missing `memes/` directory and Windows capture backends; it is not the VanishCam entry point or part of the macOS port. |
| `*.bat`, `VanishCam.spec`, `dist/VanishCam.exe` | Existing Windows launch/build artifacts, not macOS executables. The Mac port runs from source; no signed/notarized `.app` or `.dmg` is supplied. |
| `AVVIA_MAC.command` | Native Python/architecture checks, local environment setup, and argument forwarding; no new Python dependencies. |

The existing requirements resolve to binary wheels for macOS 13 arm64 / Python
3.12, including MediaPipe, OpenCV, NumPy, pygame, and pyvirtualcam. The effects use
the default MediaPipe CPU delegate and CPU image compositing; this is a native
Apple Silicon port, not a Metal/GPU rewrite or a guaranteed frame rate.
Try `--width 640 --height 480 --fps 30` if processing is slow. `--fps` limits
virtual output; it is not a frame-rate guarantee for local preview.

Validation from the repository root, using the launcher's environment:

```sh
.venv-local/bin/python -m unittest discover -v
```

Platform branches are covered using mocks, and Apple Silicon wheel availability
is checked separately. Real macOS camera permissions, Cocoa display, speaker
playback, and OBS extension interoperability still require an on-device smoke
test: run both modes locally, trigger with gestures and `V`, reset with `R` and
Space, quit with `Q`, then verify each OBS workflow above in a receiving app.

## Avvio Windows

1. Fai doppio clic su `AVVIA_LOCALE.bat`.
2. Nel menu iniziale scegli **Normal Vanish** o **Naruto Vanish** con il mouse
   oppure con i tasti `1` e `2`.
3. Esci dall'inquadratura per 4 secondi, mentre viene acquisito lo sfondo.
   Il terminale segnala quando puoi rientrare.


**Normal Vanish:** alza indice e medio a V. La dissolvenza parte al primo
riconoscimento e dura circa 3,6 secondi.

**Naruto Vanish:** unisci i palmi davanti alla webcam, con le dita affiancate e
senza intrecciarle. Tieni visibili entrambe le mani. L'effetto parte al primo
riconoscimento: il corpo svanisce in una nube di fumo, compare un tronco che
cade verso il basso e resta visibile fino a `R`. Non serve un microfono.
La modalità Naruto usa `hand_landmarker.task` per seguire entrambe le mani.
Quando parte la scomparsa, riproduce `assets/vanish.MP3` dagli altoparlanti del
computer. L'audio parte anche usando `V` e può ripartire dopo `R`.

Puoi avviare una modalità senza menu:

```powershell
local_app\AVVIA_LOCALE.bat --mode naruto
local_app\AVVIA_LOCALE.bat --mode normal
```

## Webcam virtuale e OBS

Se è installato [OBS Studio](https://obsproject.com/), l'app prova ad aprire
automaticamente **OBS Virtual Camera**. Il terminale indica il nome del
dispositivo. Per richiedere esplicitamente la webcam virtuale usa
`AVVIA_VIRTUAL.bat`. Nell'app destinataria scegli **OBS Virtual Camera**.
La fotocamera virtuale di OBS deve essere ferma mentre questa app la produce.

Per usare l'effetto in una scena OBS, avvia `AVVIA_OBS.bat`, aggiungi una sorgente
**Cattura finestra** scegliendo **Webcam - Anteprima**, poi avvia la fotocamera
virtuale da OBS. In alternativa puoi usare
[Unity Capture](https://github.com/schellingb/UnityCapture) come sorgente video
virtuale distinta:

```powershell
local_app\AVVIA_VIRTUAL.bat --virtual-backend unitycapture
```

OBS ha una sola webcam virtuale; non usarla simultaneamente come ingresso e
uscita di OBS. Vedi la [documentazione di pyvirtualcam](https://github.com/letmaik/pyvirtualcam#supported-virtual-cameras).

## Comandi

- `SPAZIO`: acquisisce nuovamente lo sfondo.
- `R`: fa riapparire la persona.
- `V`: avvia manualmente l'effetto della modalità scelta.
- `F`: attiva o disattiva lo schermo intero.
- `Q` oppure `ESC`: chiude il programma e libera le webcam.

Puoi cambiare webcam, risoluzione e FPS massimi dell'uscita virtuale:

```powershell
local_app\AVVIA_LOCALE.bat --camera 1 --width 1280 --height 720 --fps 30
```

Per diagnosticare il riconoscimento senza scritte nel video, aggiungi
`--gesture-debug`: le informazioni appaiono solo nel terminale.

## Asset visivi

Il [tronco](assets/substitution_log.png) è un'illustrazione originale generata
con ImageGen usando la foto fornita come riferimento visivo. Il fumo è disegnato
in tempo reale da `naruto_effect.py` affinché segua la posizione della persona e
si ridimensioni con il video. Abbiamo esaminato anche uno
[sprite di fumo CC0](https://opengameart.org/content/smoke-sprite-sheet), ma
l'animazione procedurale si adatta meglio al posizionamento dinamico senza un
asset aggiuntivo. Nessun fotogramma o asset dell'anime è incluso nel progetto.
