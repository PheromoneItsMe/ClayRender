# EasyLife: SimClayRender (Clay & Lighting Analysis Render)

**Author:** Pheromone  
**Compatibility:** Autodesk 3ds Max 2020 – 2026  
**Required Render Engine:** Chaos V-Ray 5 or V-Ray 6  
**Compliance:** 100% Physicl.AI SIM-Ready Scenes Technical Specifications  

---

## English

### Overview
**EasyLife: SimClayRender** is a specialized, one-click Clay and Lighting Analysis rendering tool for Autodesk 3ds Max and Chaos V-Ray. It is engineered specifically to enforce 100% compliance with **Physicl.AI SIM-Ready** dataset specifications without risking scene contamination, memory bloat, or accidental lighting shifts.

In standard workflows, performing a clay render or lighting analysis requires artists to manually hide/unhide objects, configure material overrides, adjust exclude lists for window glass and backplates, calibrate VRayLightingAnalysis elements, and then carefully restore every setting before saving the scene. **SimClayRender** automates the entire pipeline into a single click while guaranteeing **Zero Contamination** upon completion or cancellation.

### Built for Low-Spec PCs & Rapid Validation (No Long Renders)
Rendering large interior scenes with hundreds of PBR models, high-res bitmaps (2K/4K/8K), and complex material networks easily consumes 16–32+ GB of RAM and VRAM. On budget workstations, laptops, or low-spec PCs (8–16 GB RAM), local beauty rendering often leads to system freezes, Out-Of-Memory (OOM) crashes, and painful multi-hour render times just to check a simple light or prop placement.

**SimClayRender is specifically built for low-spec PCs:**
- **Zero Texture Overhead:** Bypasses heavy textures entirely by rendering with an ultra-lightweight procedural clay material.
- **Fast 30–45s Previews:** Leverages an optimized progressive sampler to produce sharp, clear clay previews and calibrated lighting maps in seconds instead of hours.
- **Prevents Machine Freezes:** Lowers RAM and GPU usage to a bare minimum, keeping your PC responsive during rendering.
- **Smart Production Separation:** Artists can rapidly validate lighting, geometry, and composition locally on budget hardware, leaving final heavy beauty renders exclusively for the render farm.

### Key Features
- **1-Click Dual Channel Output:** Simultaneously renders and saves both:
  - `<Scene>_<Camera>_Clay_RGB.png` (Clean neutral gray clay geometry)
  - `<Scene>_<Camera>_Clay_LA.png` (Calibrated false-color Lighting Analysis with drawn lux scale legend)
- **Mandatory Unhide All:** Automatically executes `unhide objects` before rendering. This prevents fatal lighting errors caused by hidden ceilings (`CEILING_01`) or walls, which otherwise allow skylight and sunlight to artificially flood the interior from above.
- **Neutral PBR Clay Material:** Automatically creates and applies an in-memory neutral gray procedural `VRayMtl` (`RGB 160, 160, 160`, `Roughness 0.5`, 0 textures).
- **Intelligent Auto-Exclusion:** Automatically scans and excludes all window glasses (`*WINDOW_GLASS*`, `*glass*`) and backgrounds (`*BACKGROUND*`, `*PORTAL*`) from the material override. Exterior daylight passes cleanly into the interior, and window backplates remain clearly visible.
- **Calibrated Lighting Analysis Pass:** Ensures a calibrated `VRayLightingAnalysis` element is active, scaled to `260.0 – 5000.0 Lux`, with the legend enabled.
- **Camera & Projection Selector:**
  - **360° Spherical (Equirectangular 2:1):** Automatically switches V-Ray to Spherical projection, FOV 360°, and 2:1 aspect ratio (default 2000×1000 or 4000×2000).
  - **Native Camera Framing (Standard FOV):** Preserves native camera framing and aspect ratios (default 2048×1536 or 1920×1080).
- **Custom Output Folder Browser:** Automatically defaults to the scene's `preview\` directory, allows choosing any custom folder, and offers an option to auto-open the folder in Windows Explorer upon completion.
- **Interactive VFB & Safe Cancellation:** Opens the standard Chaos V-Ray VFB with real-time progressive feedback. You can safely abort rendering at any moment by pressing `ESC`, clicking **Cancel** in the 3ds Max progress dialog, or clicking **Stop** in the V-Ray VFB.
- **Guaranteed Zero Contamination:** Wrapped in an absolute `try ... finally` architecture. Whether the render finishes, gets cancelled by the user, or errors out, **100% of the original scene settings** (OverrideMtl, Camera Type, FOV, Resolution, Sampler, Exclusion lists, and Element paths) are immediately restored in memory. The `.max` scene is never altered or dirtied.

### System Requirements
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025, or 2026.
- Chaos V-Ray 5 (e.g. 5.10.03, Update 1/2) or Chaos V-Ray 6.

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
**EasyLife: SimClayRender** — специализированный инструмент для 3ds Max и Chaos V-Ray, запускающий безтекстурный рендер (Clay Render) и анализ освещенности (Lighting Analysis) в один клик. Разработан строго по техническому заданию **Physicl.AI SIM-Ready Scenes** для предотвращения человеческих ошибок, утечек света, перегрузки оперативной памяти текстурами и случайного загрязнения сцены.

В обычном процессе для получения корректного клей-рендера художнику приходится вручную открывать скрытые потолки, настраивать оверрайд материалов, вручную исключать стекла и фоны, добавлять и калибровать пасс `VRayLightingAnalysis`, а затем не забыть вернуть все исходные параметры перед сохранением. **SimClayRender** берет всю эту рутину на себя, гарантируя мгновенное и **100% восстановление исходного состояния сцены (Zero Contamination)**.

### Специально для слабых ПК: быстрая проверка сцен без долгих рендеров
Полнотекстурный тестовый рендер интерьерных сцен с сотнями PBR-моделей, тяжелыми текстурами 2K/4K/8K и сложными шейдерами перегружает оперативную (RAM) и видеопамять (VRAM), потребляя 16–32+ ГБ. На слабых рабочих станциях, домашних ПК и ноутбуках (8–16 ГБ RAM) это неизбежно приводит к зависанию 3ds Max, вылетам из-за нехватки памяти (Out Of Memory / OOM) и многочасовому ожиданию кадров ради простой проверки расстановки света или пропов.

**SimClayRender создан специально для решения этой проблемы на слабых ПК:**
- **Нулевая нагрузка по текстурам:** Полностью отключает загрузку тяжелых растровых карт, заменяя их сверхлегким процедурным серым материалом прямо в оперативной памяти.
- **Молниеносный результат (30–45 секунд):** Благодаря оптимизированному прогрессивному сэмплеру позволяет получить четкое превью геометрии и точную карту освещенности всего за полминуты вместо долгих часов ожидания.
- **Никаких зависаний и вылетов:** Нагрузка на оперативную память и процессор снижена до минимума, система не уходит в своп и не зависает.
- **Грамотный пайплайн:** Локальная экспресс-проверка выполняется быстро и легко прямо на слабой рабочей машине, а финальный тяжелый рендер со всеми текстурами отправляется на рендер-ферму.

### Основные возможности
- **Двойной результат в один клик (Dual Channel):** Автоматически извлекает из буфера VFB и сохраняет:
  - `<Scene>_<Camera>_Clay_RGB.png` (чистая серая геометрия без текстур)
  - `<Scene>_<Camera>_Clay_LA.png` (карта распределения люксов с легендой)
- **Обязательный Unhide All (Защита от паразитного света):** Перед каждым рендером скрипт выполняет `unhide objects`. Если потолок (`CEILING_01`) или стены были скрыты художником во время моделирования, инструмент автоматически делает их видимыми, исключая проникновение дневного света сверху.
- **Нейтральный серый процедурный Clay:** Создает процедурный серый `VRayMtl` (`RGB 160, 160, 160`, `roughness 0.5`, 0 текстур) без нагрузки на видеопамять.
- **Умное авто-исключение стекол и фонов:** Автоматически находит и исключает из оверрайда стекла окон (`*WINDOW_GLASS*`, `*glass*`) и плоскости бэкплейнов (`*BACKGROUND*`, `*PORTAL*`). Свет беспрепятственно проникает в интерьер, а вид за окном остается естественным.
- **Авто-калибровка Lighting Analysis:** Проверяет наличие пасса `VRayLightingAnalysis`, калибрует диапазон на `260.0 – 5000.0 Lux` и активирует шкалу-легенду.
- **Выбор камеры и проекции:**
  - **360° Spherical (Equirectangular 2:1):** включает сферическую 360-градусную панораму, FOV 360°, пропорции 2:1 (пресеты 2000×1000 или 4000×2000).
  - **Native Camera Framing (Standard FOV):** рендерит ракурс выбранной камеры с ее оригинальным углом обзора и пропорцией кадра (пресеты 2048×1536 или 1920×1080).
- **Выбор папки сохранения:** По умолчанию подставляет папку `preview\` текущей сцены, поддерживает выбор любой пользовательской папки и опцию автоматического открытия в проводнике Windows.
- **Интерактивный VFB и отмена в любой момент:** Просчет идет в стандартном окне V-Ray VFB с прогрессивным сэмплером. Рендер можно прервать в любую секунду клавишей `ESC`, кнопкой *Cancel* в окне прогресса 3ds Max или кнопкой *Stop* в VFB.
- **Гарантированное Zero Contamination восстановление:** Конструкция `try ... finally` гарантирует: при любом исходе (успех, ручная отмена, ошибка) все исходные параметры V-Ray (OverrideMtl, тип камеры, FOV, разрешение, сэмплер, пути элементов) мгновенно возвращаются в исходное состояние прямо в памяти. Сцена `.max` остается абсолютно чистой.

### Системные требования
- Autodesk 3ds Max 2020, 2021, 2022, 2023, 2024, 2025 или 2026.
- Chaos V-Ray 5 (5.10.03, Update 1/2) или Chaos V-Ray 6.

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
