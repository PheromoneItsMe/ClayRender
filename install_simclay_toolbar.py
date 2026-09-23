import os
import shutil

src_mcr = r"c:\Projects\3ds max scripting\ClayRender\EasyLife_SimClayRender.mcr"
usermacros_dir = r"C:\Users\SoloFun\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\usermacros"
dst_mcr = os.path.join(usermacros_dir, "EasyLife-SimClayRender.mcr")

# 1. Copy MCR to usermacros
if not os.path.exists(usermacros_dir):
    os.makedirs(usermacros_dir, exist_ok=True)
shutil.copyfile(src_mcr, dst_mcr)
print(f"Copied {src_mcr} -> {dst_mcr}")

# 2. CUIX button XML
clay_item = '                <Item typeID="2" type="CTB_MACROBUTTON" width="68" height="0" controlID="0" macroTypeID="3" macroType="MB_TYPE_ACTION" actionTableID="647394" imageID="-1" imageName="" actionID="SimClayRender`EasyLife" tip="EasyLife: SimReady Clay &amp; Lighting Analysis Render (One-Click)" label="ClayRender" />\n'

cuix_files = [
    r"C:\Users\SoloFun\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\UI\Workspaces\Workspace1.cuix",
    r"C:\Users\SoloFun\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\UI\Workspaces\usersave\Workspace1__usersave__.cuix",
    r"C:\Users\SoloFun\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\UI\MaxStartUI.cuix"
]

for fp in cuix_files:
    if not os.path.exists(fp):
        print(f"File not found: {fp}")
        continue
    # Backup
    shutil.copyfile(fp, fp + ".bak_clay")
    print(f"Backed up {fp} -> {fp}.bak_clay")
    
    with open(fp, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
        
    full_text = "".join(lines)
    if 'actionID="SimClayRender`EasyLife"' in full_text:
        print(f"SimClayRender already present in {fp}")
        continue
        
    new_lines = []
    added_count = 0
    for line in lines:
        new_lines.append(line)
        if 'actionID="PhysicDrop`EasyLife"' in line:
            new_lines.append(clay_item)
            added_count += 1
            
    if added_count > 0:
        with open(fp, "w", encoding="utf-8") as f:
            f.writelines(new_lines)
        print(f"Added {added_count} ClayRender button(s) right next to PhysicDrop in {fp}")
    else:
        print(f"Warning: PhysicDrop actionID not found in {fp}")

# 3. Update TopCustomToolbar_Permanent.ms
perm_script = r"c:\Projects\3ds max scripting\scripts\TopCustomToolbar_Permanent.ms"
if os.path.exists(perm_script):
    with open(perm_script, "r", encoding="utf-8") as f:
        perm_content = f.read()
    
    if "EasyLife-SimClayRender.mcr" not in perm_content:
        # Insert loading code
        insert_marker = 'local foxMacro = (getDir #userMacros) + @"\\EasyLife-FoxRenderfarm.mcr"\n        if doesFileExist foxMacro do fileIn foxMacro'
        replacement = insert_marker + '\n        \n        local clayMacro = (getDir #userMacros) + @"\\EasyLife-SimClayRender.mcr"\n        if doesFileExist clayMacro do fileIn clayMacro'
        
        if insert_marker in perm_content:
            perm_content = perm_content.replace(insert_marker, replacement)
        else:
            # Fallback append before cui.showToolbar
            perm_content = perm_content.replace(
                'cui.showToolbar "Visual Pivot" true',
                'local clayMacro = (getDir #userMacros) + @"\\EasyLife-SimClayRender.mcr"\n        if doesFileExist clayMacro do fileIn clayMacro\n        \n        cui.showToolbar "Visual Pivot" true'
            )
            
        with open(perm_script, "w", encoding="utf-8") as f:
            f.write(perm_content)
        print("Updated TopCustomToolbar_Permanent.ms with EasyLife-SimClayRender.mcr loading logic")
    else:
        print("TopCustomToolbar_Permanent.ms already has EasyLife-SimClayRender.mcr")

print("Toolbar installation script completed successfully!")
