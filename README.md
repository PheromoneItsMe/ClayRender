# EasyLife: SimClayRender (Textured Preview & Clay + LA Studio)

**Author:** Pheromone  
**Compatibility:** Autodesk 3ds Max 2020 – 2026  
**Required Render Engine:** Chaos V-Ray 5 or V-Ray 6  
**Compliance:** 100% Physicl.AI SIM-Ready Scenes Technical Specifications  

---

## English

### Overview
**EasyLife: SimClayRender** is an intelligent, high-speed rendering studio for Autodesk 3ds Max and Chaos V-Ray. Engineered specifically to enforce 100% compliance with **Physicl.AI SIM-Ready** dataset specifications, it eliminates human error, memory bloat, accidental lighting shifts, and tedious manual setups.

The tool provides an instant toggle between two optimized rendering modes, with **Textured Preview** enabled as the default upon opening:
1. **Textured Preview (Fast Progressive) — DEFAULT:** Renders with native scene materials and textures using rapid progressive passes (~20–25 seconds). Designed to catch a clear, intelligible frame immediately without stalling or freezing low-spec machines. Automatically extracts and saves **BOTH** the textured RGB beauty image and the calibrated false-color Lighting Analysis pass.
2. **Clay & LA (Material Override):** 100% SIM-Ready compliant procedural neutral gray clay override (`RGB 160, 160, 160`, `Roughness 0.5`, 0 textures) with automated exclusion for window glass and backplates. Automatically extracts and saves **BOTH** the Clay RGB image and the calibrated false-color Lighting Analysis pass.

---

### Built for Rapid Validation & Hardware Protection
Rendering dense interior scenes with hundreds of PBR models, high-res bitmaps (2K/4K/8K), and complex material networks easily consumes 16–32+ GB of RAM and VRAM. On budget workstations, laptops, or low-spec PCs (8–16 GB RAM), local production rendering leads to system freezes, Out-Of-Memory (OOM) crashes, and painful multi-hour render times just to check a simple light or prop placement.

**SimClayRender solves this completely:**
- **Instant Intelligible Frame (Textured Preview):** Doesn't wait for endless convergence passes. It stops as soon as a clear, readable frame is formed, capturing the exact colors, finishes, and lighting mood in ~20–30 seconds.
- **RAM & VRAM Protection:** Runs memory garbage collection and bitmap cache flushes (`gc light:true`, `freeSceneBitmaps()`) before and after every render, preventing memory fragmentation.
- **Zero Texture Overhead (Clay Mode):** Bypasses heavy textures entirely when inspecting pure geometry and lighting balance.
- **Smart Separation of Roles:** Rapid local validation is completed in seconds right on your workstation, while final heavy 4K/8K beauty frames are sent cleanly to the render farm (FoxRenderfarm).

---

### Key Features
- **Dual Render Modes with One-Click Toggle:**
  - **Textured Preview (Fast Progressive) [DEFAULT]:**
    - Output: `<Scene>_<Camera>_Textured_RGB.png` & `<Scene>_<Camera>_Textured_LA.png`
    - Material Override: Strictly **OFF** (Native PBR materials, textures, roughness, and bump maps visible).
    - Recommended Time Limit: ~0.4 min (~24 seconds).
    - Recommended Noise Cutoff: ~0.03.
  - **Clay & LA (Material Override):**
    - Output: `<Scene>_<Camera>_Clay_RGB.png` & `<Scene>_<Camera>_Clay_LA.png`
    - Material Override: Strictly **ON** (Procedural neutral gray `VRayMtl` 160, roughness 0.5).
    - Auto-exclusion: All window glass (`*WINDOW_GLASS*`, `*glass*`) and backgrounds (`*BACKGROUND*`, `*PORTAL*`).
    - Recommended Time Limit: ~0.7 min (~42 seconds).
    - Recommended Noise Cutoff: ~0.02.
- **Calibrated Lighting Analysis Pass in Both Modes:** Automatically configures and verifies a calibrated `VRayLightingAnalysis` element (`260.0 – 5000.0 Lux`, legend enabled).
- **Mandatory Unhide All:** Automatically executes `unhide objects` before rendering. This guarantees that ceilings (`CEILING_01`) or walls hidden during modeling are brought back, eliminating false sunlight/skylight flooding from above.
- **Camera & Projection Selector:**
  - **360° Spherical (Equirectangular 2:1):** Automatically switches V-Ray to Spherical projection, FOV 360°, and 2:1 aspect ratio (default 2000×1000 or 4000×2000).
  - **Native Camera Framing (Standard FOV):** Preserves native camera framing and aspect ratios (default 2048×1536 or 1920×1080).
- **Custom Output Folder Browser:** Automatically defaults to the scene's `preview\` directory, allows choosing any custom folder, and offers an option to auto-open the folder in Windows Explorer upon completion.
- **Interactive VFB & Safe Cancellation:** Opens the standard Chaos V-Ray VFB with real-time progressive feedback. You can safely abort rendering at any moment by pressing `ESC`, clicking **Cancel** in the 3ds Max progress dialog, or clicking **Stop** in the V-Ray VFB.
- **Guaranteed Zero Contamination:** Whether the render finishes, gets cancelled by the user, or encounters an issue, **100% of the original scene settings** (OverrideMtl, Camera Type, FOV, Resolution, Sampler, Exclusion lists, and Element paths) are immediately restored in memory. The `.max` scene is never altered or dirtied.

---

### System Requirements
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025, or 2026.
- Chaos V-Ray 5 (e.g. 5.10.03, Update 1/2) or Chaos V-Ray 6.

---

### Installation

#### Method 1: Drag & Drop (Recommended)
1. Simply drag and drop `EasyLife_SimClayRender_Installer.ms` into any active 3ds Max viewport.
2. The installer will automatically register the tool permanently under user macros and open the dialog window.

#### Method 2: Manual Installation
1. Copy `EasyLife_SimClayRender.mcr` into your 3ds Max user macros folder:
   `%LOCALAPPDATA%\Autodesk\3dsMax\<Version>\ENU\usermacros\`
2. Restart 3ds Max or run `fileIn @"...\EasyLife_SimClayRender.mcr"` in the MAXScript Listener.

#### Adding to Toolbar
1. Go to **Customize** $\rightarrow$ **Customize User Interface** $\rightarrow$ **Toolbars**.
2. Under **Category**, select **EasyLife**.
3. Locate **ClayRender** and drag it onto any toolbar (e.g., right next to `PhysicDrop`).

---

## Русский

### Описание
**EasyLife: SimClayRender** — специализированная студия быстрого рендеринга для 3ds Max и Chaos V-Ray. Разработана строго по официальному техническому заданию **Physicl.AI SIM-Ready Scenes** для предотвращения человеческих ошибок, паразитных засветов, перегрузки оперативной памяти текстурами и случайного загрязнения сцены.

Инструмент позволяет в один клик переключаться между двумя режимами, при этом **Текстурное превью (Textured Preview)** выбрано **по умолчанию** при открытии окна:
1. **Textured Preview (Fast Progressive) — ПО УМОЛЧАНИЮ:** Рендерит сцену с оригинальными материалами и текстурами в быстром прогрессивном режиме (~20–25 секунд). Цель режима — быстро поймать четкий, отчетливый кадр без необходимости ждать полного многочасового рендера и без риска зависания ПК. Автоматически сохраняет **И** текстурную бьюти-картинку, **И** карту освещенности Lighting Analysis.
2. **Clay & LA (Material Override):** 100% соответствующий регламенту SIM-Ready процедурный нейтральный серый клей (`RGB 160, 160, 160`, `Roughness 0.5`, 0 текстур) с автоматическим исключением оконных стекол и фонов. Автоматически сохраняет **И** клей RGB-картинку, **И** карту освещенности Lighting Analysis.

---

### Создан специально для слабых ПК: отчетливый кадр без долгих рендеров
Полнотекстурный тестовый рендер интерьерных сцен с сотнями PBR-моделей, тяжелыми текстурами 2K/4K/8K и сложными шейдерами перегружает оперативную (RAM) и видеопамять (VRAM), потребляя 16–32+ ГБ. На слабых рабочих станциях, домашних ПК и ноутбуках (8–16 ГБ RAM) это неизбежно приводит к зависанию 3ds Max, вылетам из-за нехватки памяти (Out Of Memory / OOM) и многочасовому ожиданию кадров ради простой проверки расстановки света или пропов.

**SimClayRender полностью решает эту задачу:**
- **Быстрый отчетливый кадр (Textured Preview):** Скрипт не ждет бесконечного завершения сэмплов — он останавливается, как только кадр сформировался и стал четким и понятным (~20–30 секунд). Сохраняется и текстурный кадр, и световая карта.
- **Защита оперативной памяти:** Перед каждым рендером и после него выполняется принудительная очистка кэша растровых карт и сборка мусора (`gc light:true`, `freeSceneBitmaps()`).
- **Нулевая нагрузка по текстурам (Clay Mode):** При проверке геометрии и баланса света текстуры полностью отключаются, память не забивается.
- **Грамотный пайплайн:** Экспресс-проверка выполняется за считанные секунды прямо на рабочей машине, а финальный тяжелый рендер со всеми текстурами отправляется на рендер-ферму (FoxRenderfarm).

---

### Основные возможности
- **Два режима рендера с переключением в 1 клик:**
  - **Textured Preview (Fast Progressive) [ПО УМОЛЧАНИЮ]:**
    - Файлы: `<Scene>_<Camera>_Textured_RGB.png` и `<Scene>_<Camera>_Textured_LA.png`
    - Оверрайд материалов: строго **ВЫКЛЮЧЕН** (видны все реальные текстуры, металлы, дерево, ткани).
    - Рекомендуемый лимит времени: ~0.4 мин (~24 сек).
    - Рекомендуемый порог шума (Noise Cutoff): ~0.03.
  - **Clay & LA (Material Override):**
    - Файлы: `<Scene>_<Camera>_Clay_RGB.png` и `<Scene>_<Camera>_Clay_LA.png`
    - Оверрайд материалов: строго **ВКЛЮЧЕН** (процедурный нейтральный серый `VRayMtl` 160, roughness 0.5).
    - Авто-исключение: стекла окон (`*WINDOW_GLASS*`, `*glass*`) и фоны (`*BACKGROUND*`, `*PORTAL*`).
    - Рекомендуемый лимит времени: ~0.7 мин (~42 сек).
    - Рекомендуемый порог шума: ~0.02.
- **Обязательный Unhide All (Защита от паразитного света):** Перед каждым рендером скрипт выполняет `unhide objects`. Если потолок (`CEILING_01`) или стены были скрыты художником во время работы, инструмент автоматически делает их видимыми, исключая проникновение дневного света сверху.
- **Авто-калибровка Lighting Analysis в обоих режимах:** Проверяет наличие пасса `VRayLightingAnalysis`, калибрует диапазон на `260.0 – 5000.0 Lux` и активирует шкалу-легенду.
- **Выбор камеры и проекции:**
  - **360° Spherical (Equirectangular 2:1):** включает сферическую 360-градусную панораму, FOV 360°, пропорции 2:1 (пресеты 2000×1000 или 4000×2000).
  - **Native Camera Framing (Standard FOV):** рендерит ракурс выбранной камеры с ее оригинальным углом обзора и пропорцией кадра (пресеты 2048×1536 или 1920×1080).
- **Выбор папки сохранения:** По умолчанию подставляет папку `preview\` текущей сцены, поддерживает выбор любой пользовательской папки и опцию автоматического открытия в проводнике Windows.
- **Интерактивный VFB и отмена в любой момент:** Просчет идет в стандартном окне V-Ray VFB с прогрессивным сэмплером. Рендер можно прервать в любую секунду клавишей `ESC`, кнопкой *Cancel* в окне прогресса 3ds Max или кнопкой *Stop* в VFB.
- **Гарантированное Zero Contamination восстановление:** Конструкция `try ... catch` и блок гарантированного отката возвращают 100% исходных параметров V-Ray (OverrideMtl, тип камеры, FOV, разрешение, сэмплер, пути элементов) в исходное состояние прямо в памяти. Сцена `.max` остается абсолютно чистой.

---

### Системные требования
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025 или 2026.
- Chaos V-Ray 5 (5.10.03, Update 1/2) или Chaos V-Ray 6.

---

### Установка

#### Способ 1: Drag & Drop (Рекомендуется)
1. Просто перетащите файл `EasyLife_SimClayRender_Installer.ms` мышкой прямо в любой активный вьюпорт 3ds Max.
2. Установщик автоматически скопирует макрос в папку `usermacros` и сразу откроет окно инструмента.

#### Способ 2: Ручная установка
1. Скопируйте `EasyLife_SimClayRender.mcr` в папку пользовательских макросов 3ds Max:
   `%LOCALAPPDATA%\Autodesk\3dsMax\<Version>\ENU\usermacros\`
2. Перезапустите 3ds Max или выполните `fileIn @"...\EasyLife_SimClayRender.mcr"` в окне MAXScript Listener.

#### Размещение кнопки на панели инструментов
1. Откройте **Customize** $\rightarrow$ **Customize User Interface** $\rightarrow$ **Toolbars**.
2. В выпадающем списке **Category** выберите **EasyLife**.
3. Найдите команду **ClayRender** и перетащите ее на любую удобную панель инструментов (например, рядом с `PhysicDrop`).
