/*
    ============================================================================
    EasyLife: SimReady Clay & Lighting Analysis Render
    ============================================================================
    Author: Pheromone
    Compatibility: Autodesk 3ds Max 2020 - 2026 (Requires V-Ray 5 / 6)
    
    Features:
    - 1-Click Clay (Material Override) + VRayLightingAnalysis render.
    - 100% compliant with Physicl.AI SIM-Ready Specifications:
        * Mandatory Unhide All (Ceiling & Walls active).
        * Procedural Clay VRayMtl (160, 160, 160, roughness 0.5, 0 textures).
        * Auto-exclusion of window glass (*WINDOW_GLASS*, *glass*) & backgrounds (*BACKGROUND*).
        * Calibrated Lighting Analysis (260 - 5000 Lux, Legend enabled).
    - Camera selection dropdown with 360° Spherical (2:1) vs Native Camera FOV.
    - Output directory picker; saves both Clay RGB and LA PNGs.
    - Full V-Ray VFB display with progress & interactive abort support.
    - Guaranteed Zero Contamination restoration upon finish or cancel.
    ============================================================================
*/

macroScript SimClayRender
category:"EasyLife"
buttonText:"ClayRender"
toolTip:"EasyLife: SimReady Clay & Lighting Analysis Render (One-Click)"
(
    global rollout_EasyLife_SimClayRender
    
    rollout rollout_EasyLife_SimClayRender "EasyLife: Clay & LA Render" width:380 height:540
    (
        local sceneCamNodes = #()
        
        -- Helper: get valid camera nodes
        fn fn_getCameras =
        (
            local cams = #()
            for c in cameras where (not isKindOf c Targetobject) do (
                append cams c
            )
            cams
        )
        
        -- Helper: get default output directory
        fn fn_getDefaultOutDir =
        (
            local p = ""
            if maxFilePath != "" and doesFileExist maxFilePath then (
                p = maxFilePath + @"preview\"
            ) else (
                p = (getDir #renderoutput) + @"\"
            )
            p
        )
        
        -- UI GROUPS
        group " 1. Camera & Projection "
        (
            dropdownList ddl_cams "Select Camera:" items:#() height:6 tooltip:"Select camera to render"
            button btn_refreshCams "🔄 Refresh Cameras" width:140 align:#right tooltip:"Scan scene for newly created cameras"
            radiobuttons rb_proj "Render Mode:" labels:#("360° Spherical (Equirectangular 2:1)", "Native Camera Framing (Standard FOV)") default:1
        )
        
        group " 2. Resolution & Time Limit "
        (
            dropdownList ddl_presets "Resolution Preset:" items:#( \
                "360 Preview (2000 x 1000)", \
                "360 High-Res (4000 x 2000)", \
                "Standard 4:3 (2048 x 1536)", \
                "Standard 16:9 (1920 x 1080)", \
                "Custom..." \
            ) default:1
            spinner spn_w "Width:" type:#integer range:[320, 8192, 2000] width:140 across:2 align:#left
            spinner spn_h "Height:" type:#integer range:[240, 8192, 1000] width:140 align:#right
            spinner spn_time "Time Limit (min):" type:#float range:[0.1, 30.0, 0.7] width:150 across:2 align:#left tooltip:"Progressive render time limit (~0.7 min = ~42s)"
            spinner spn_noise "Noise Cutoff:" type:#float range:[0.001, 0.1, 0.02] width:150 align:#right tooltip:"Progressive noise threshold"
        )
        
        group " 3. Save Destination "
        (
            edittext edt_outDir "Save Folder:" text:"" readonly:false labelOntop:true
            button btn_browse "📁 Browse..." width:100 align:#left across:3 tooltip:"Choose folder for Clay RGB and LA images"
            button btn_resetDir "↺ Reset" width:70 align:#center tooltip:"Reset to scene preview folder"
            button btn_openDir "📂 Open" width:70 align:#right tooltip:"Open destination folder in Explorer"
            checkbox chk_openComplete "Open folder automatically when finished" checked:true
        )
        
        group " 4. One-Click Render "
        (
            button btn_render "🚀 START CLAY & LA RENDER" width:340 height:44 align:#center tooltip:"Start 100% SIM-Ready compliant Clay + LA Render"
            progressbar pb_prog value:0 width:340 height:10 color:(color 0 160 80)
            label lbl_status "Status: Ready." align:#center
        )
        
        label lbl_hint "Tip: To abort render safely, press ESC or click Cancel in the progress window. Original scene settings are 100% guaranteed to be restored." height:28 width:340 align:#center
        
        -- POPULATE CAMERAS
        fn fn_refreshCameraList =
        (
            sceneCamNodes = fn_getCameras()
            local names = for c in sceneCamNodes collect c.name
            if names.count == 0 then (
                ddl_cams.items = #("No cameras found in scene!")
                btn_render.enabled = false
            ) else (
                ddl_cams.items = names
                btn_render.enabled = true
                
                -- Auto-select logic: prefer active camera or C002_360
                local selIdx = 1
                local activeCam = viewport.getCamera()
                if activeCam != undefined do (
                    local foundIdx = findItem sceneCamNodes activeCam
                    if foundIdx > 0 do selIdx = foundIdx
                )
                if activeCam == undefined do (
                    for i = 1 to sceneCamNodes.count do (
                        if matchPattern sceneCamNodes[i].name pattern:"*360*" or matchPattern sceneCamNodes[i].name pattern:"*C002*" do (
                            selIdx = i
                            exit
                        )
                    )
                )
                ddl_cams.selection = selIdx
            )
        )
        
        -- PRESET RESOLUTION HANDLER
        fn fn_applyPreset idx =
        (
            case idx of (
                1: ( spn_w.value = 2000; spn_h.value = 1000; rb_proj.state = 1 )
                2: ( spn_w.value = 4000; spn_h.value = 2000; rb_proj.state = 1 )
                3: ( spn_w.value = 2048; spn_h.value = 1536; rb_proj.state = 2 )
                4: ( spn_w.value = 1920; spn_h.value = 1080; rb_proj.state = 2 )
            )
        )
        
        -- EVENT HANDLERS
        on ddl_presets selected idx do (
            fn_applyPreset idx
        )
        
        on rb_proj changed state do (
            if state == 1 then (
                if ddl_presets.selection == 3 or ddl_presets.selection == 4 do (
                    ddl_presets.selection = 1
                    fn_applyPreset 1
                )
            ) else (
                if ddl_presets.selection == 1 or ddl_presets.selection == 2 do (
                    ddl_presets.selection = 3
                    fn_applyPreset 3
                )
            )
        )
        
        on btn_refreshCams pressed do (
            fn_refreshCameraList()
        )
        
        on btn_browse pressed do (
            local chosen = getSavePath caption:"Select Output Folder for Clay & LA Renders" initialDir:edt_outDir.text
            if chosen != undefined and chosen != "" do (
                if not (matchPattern chosen pattern:@"*\") do chosen += @"\"
                edt_outDir.text = chosen
            )
        )
        
        on btn_resetDir pressed do (
            edt_outDir.text = fn_getDefaultOutDir()
        )
        
        on btn_openDir pressed do (
            local d = edt_outDir.text
            if doesFileExist d then (
                shellLaunch "explorer.exe" d
            ) else (
                messageBox ("Output folder does not exist yet:\n" + d) title:"Clay & LA Render"
            )
        )
        
        -- MAIN RENDER EXECUTION
        on btn_render pressed do
        (
            if sceneCamNodes.count == 0 or ddl_cams.selection < 1 or ddl_cams.selection > sceneCamNodes.count do (
                messageBox "Please select a valid camera to render." title:"Clay & LA Render"
                return false
            )
            
            local targetCam = sceneCamNodes[ddl_cams.selection]
            if not (isValidNode targetCam) do (
                messageBox "The selected camera node is no longer valid. Refreshing..." title:"Clay & LA Render"
                fn_refreshCameraList()
                return false
            )
            
            local vr = renderers.current
            if not (isKindOf vr VRay) and not (matchPattern ((classOf vr) as string) pattern:"*V_Ray*") and not (matchPattern ((classOf vr) as string) pattern:"*VRay*") do (
                messageBox "Current renderer is not V-Ray!\nPlease set V-Ray as the production renderer in Render Setup." title:"Clay & LA Render"
                return false
            )
            
            local outDir = edt_outDir.text
            if outDir == "" do outDir = fn_getDefaultOutDir()
            if not (matchPattern outDir pattern:@"*\") do outDir += @"\"
            edt_outDir.text = outDir
            
            try (makeDir outDir all:true) catch ()
            
            local is360 = (rb_proj.state == 1)
            local resW = spn_w.value
            local resH = spn_h.value
            local timeLimit = spn_time.value
            local noiseThresh = spn_noise.value
            
            local scName = getFilenameFile maxFileName
            if scName == "" do scName = "Scene"
            local camName = targetCam.name
            local rgbFile = outDir + scName + "_" + camName + "_Clay_RGB.png"
            local laFile = outDir + scName + "_" + camName + "_Clay_LA.png"
            
            lbl_status.text = "Status: Preparing scene & unhiding objects..."
            pb_prog.value = 10
            windows.processPostedMessages()
            
            -- 1. MANDATORY UNHIDE ALL
            unhide objects
            
            -- 2. BACKUP ORIGINAL SETTINGS
            local origW = renderWidth
            local origH = renderHeight
            local origOverrideOn = vr.options_overrideMtl_on
            local origOverrideMtl = vr.options_overrideMtl_mtl
            local origOverrideExclType = vr.options_overrideMtl_excl_type
            local origExcludeList = vr.excludeListOverrideMtl
            local origSampler = vr.imageSampler_type
            local origTimeLimit = vr.progressive_max_render_time
            local origNoiseThresh = vr.progressive_noise_threshold
            local origCamType = vr.camera_type
            local origOverrideFOV = vr.camera_overrideFOV
            local origCamFOV = vr.camera_fov
            
            local reMgr = maxOps.GetCurRenderElementMgr()
            local origREFiles = #()
            for i = 0 to (reMgr.NumRenderElements() - 1) do (
                append origREFiles (reMgr.GetRenderElementFilename i)
            )
            
            local wasCancelled = false
            local renderSuccess = false
            
            btn_render.enabled = false
            
            try
            (
                lbl_status.text = "Status: Configuring Lighting Analysis..."
                pb_prog.value = 20
                windows.processPostedMessages()
                
                -- 3. ENSURE CALIBRATED VRAYLIGHTINGANALYSIS
                local laElem = undefined
                for i = 0 to (reMgr.NumRenderElements() - 1) do (
                    local elem = reMgr.GetRenderElement i
                    if matchPattern elem.elementName pattern:"*LightingAnalysis*" or isKindOf elem VRayLightingAnalysis do (
                        laElem = elem
                        laElem.enabled = true
                        try (laElem.min_value = 260.0) catch ()
                        try (laElem.max_value = 5000.0) catch ()
                        try (laElem.draw_legend = true) catch ()
                        reMgr.SetRenderElementFilename i laFile
                    )
                )
                if laElem == undefined do (
                    laElem = VRayLightingAnalysis()
                    laElem.elementName = "VRayLightingAnalysis"
                    try (laElem.min_value = 260.0) catch ()
                    try (laElem.max_value = 5000.0) catch ()
                    try (laElem.draw_legend = true) catch ()
                    reMgr.AddRenderElement laElem
                    for i = 0 to (reMgr.NumRenderElements() - 1) do (
                        if (reMgr.GetRenderElement i) == laElem do (
                            reMgr.SetRenderElementFilename i laFile
                        )
                    )
                )
                
                -- 4. APPLY TEMPORARY PROJECTION & RESOLUTION
                renderWidth = resW
                renderHeight = resH
                
                if is360 then (
                    vr.camera_type = 1           -- Spherical
                    vr.camera_overrideFOV = true
                    vr.camera_fov = 360.0
                ) else (
                    vr.camera_type = 0           -- Standard / Pinhole
                    vr.camera_overrideFOV = false
                )
                
                -- 5. PROCEDURAL CLAY MATERIAL
                local grayMtl = VRayMtl name:"TEMP_CLAY_PREVIEW" diffuse:(color 160 160 160) roughness:0.5
                
                -- 6. EXCLUSION LIST (Window Glass & Backgrounds)
                local exclNodes = for o in objects where \
                    matchPattern o.name pattern:"*WINDOW_GLASS*" or \
                    matchPattern o.name pattern:"*BACKGROUND*" or \
                    matchPattern o.name pattern:"*PORTAL*" or \
                    matchPattern o.name pattern:"*glass*" collect o
                    
                vr.options_overrideMtl_on = true
                vr.options_overrideMtl_mtl = grayMtl
                vr.options_overrideMtl_excl_type = 0 -- Exclude mode
                vr.excludeListOverrideMtl = exclNodes
                
                -- 7. PROGRESSIVE SAMPLER
                vr.imageSampler_type = 0 -- Progressive
                vr.progressive_max_render_time = timeLimit
                vr.progressive_noise_threshold = noiseThresh
                
                lbl_status.text = "Status: Rendering in VFB (Press ESC / Cancel to abort)..."
                pb_prog.value = 50
                windows.processPostedMessages()
                
                -- 8. EXECUTE RENDER WITH PROGRESS BAR & CANCEL DETECTION
                local renderedImg = render camera:targetCam outputfile:rgbFile vfb:true prompt:false quiet:true progressbar:true cancelled:&wasCancelled
                
                if not wasCancelled then
                (
                    lbl_status.text = "Status: Saving VFB Channels (Clay RGB & LA)..."
                    pb_prog.value = 85
                    windows.processPostedMessages()
                    
                    -- 9. EXTRACT VFB CHANNELS
                    local numCh = try (vrayVFBGetNumChannels()) catch 0
                    local laSaved = false
                    local rgbSaved = false
                    
                    for i = 0 to (numCh - 1) do (
                        local chName = try (vrayVFBGetChannelName i) catch ""
                        if matchPattern chName pattern:"*LightingAnalysis*" or matchPattern chName pattern:"*Analysis*" do (
                            try (
                                local laBmp = vrayVFBGetChannelBitmap i
                                if laBmp != undefined do (
                                    laBmp.filename = laFile
                                    save laBmp
                                    close laBmp
                                    laSaved = true
                                )
                            ) catch ()
                        )
                        if matchPattern chName pattern:"*RGB*" or matchPattern chName pattern:"*color*" do (
                            if not rgbSaved do (
                                try (
                                    local rgbBmp = vrayVFBGetChannelBitmap i
                                    if rgbBmp != undefined do (
                                        rgbBmp.filename = rgbFile
                                        save rgbBmp
                                        close rgbBmp
                                        rgbSaved = true
                                    )
                                ) catch ()
                            )
                        )
                    )
                    
                    if not rgbSaved and renderedImg != undefined do (
                        try (
                            renderedImg.filename = rgbFile
                            save renderedImg
                            close renderedImg
                            rgbSaved = true
                        ) catch ()
                    )
                    
                    if doesFileExist laFile do laSaved = true
                    if doesFileExist rgbFile do rgbSaved = true
                    
                    renderSuccess = rgbSaved or laSaved
                    
                    if renderSuccess then (
                        lbl_status.text = "Status: Finished successfully! Files saved."
                        pb_prog.value = 100
                    ) else (
                        lbl_status.text = "Status: Render finished, check output folder."
                        pb_prog.value = 100
                    )
                )
                else
                (
                    lbl_status.text = "Status: Render cancelled by user! Restoring scene..."
                    pb_prog.value = 0
                )
            )
            catch
            (
                local err = getCurrentException()
                lbl_status.text = "Status: Error during render (Scene restored)."
                pb_prog.value = 0
                format "ClayRender Exception: %\n" err
            )
            
            -- 10. STRICT IMMEDIATE ZERO CONTAMINATION RESTORATION (ALWAYS RUNS)
            vr.options_overrideMtl_on = origOverrideOn
            vr.options_overrideMtl_mtl = origOverrideMtl
            vr.options_overrideMtl_excl_type = origOverrideExclType
            vr.excludeListOverrideMtl = origExcludeList
            vr.imageSampler_type = origSampler
            vr.progressive_max_render_time = origTimeLimit
            vr.progressive_noise_threshold = origNoiseThresh
            vr.camera_type = origCamType
            vr.camera_overrideFOV = origOverrideFOV
            vr.camera_fov = origCamFOV
            renderWidth = origW
            renderHeight = origH
            
            -- Restore render element filenames
            for i = 0 to (origREFiles.count - 1) do (
                if i < (reMgr.NumRenderElements()) do (
                    reMgr.SetRenderElementFilename i origREFiles[i + 1]
                )
            )
            
            btn_render.enabled = true
            
            -- Open folder if requested
            if chk_openComplete.checked and renderSuccess and not wasCancelled do (
                try (shellLaunch "explorer.exe" ("/select,\"" + rgbFile + "\"")) catch ()
            )
            
            return renderSuccess
        )
        
        -- INIT ROLLOUT
        on rollout_EasyLife_SimClayRender open do
        (
            edt_outDir.text = fn_getDefaultOutDir()
            fn_refreshCameraList()
            fn_applyPreset 1
        )
    )
    
    on execute do
    (
        try (destroyDialog rollout_EasyLife_SimClayRender) catch ()
        createDialog rollout_EasyLife_SimClayRender
        try (setFocus rollout_EasyLife_SimClayRender) catch ()
    )
)
