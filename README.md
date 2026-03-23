# NecroUI Library V2 Pro

A highly aesthetic, modular, and optimized user interface library for Roblox script developers. Inspired by premium UI designs with a deep focus on custom themes, liquid gradient animations, and pixel-perfect element alignments.

![NecroUI](necro_ui_logo_.png)

##  Особенности (Features)

NecroUI построена на продвинутой модульной архитектуре, которая берет всё управление на себя:
- 🎨 **Liquid Neon Engine:** Математически плавная анимация градиентов.
- 📐 **Responsive Safe-Grid:** Принудительные колонки предотвращают вылезание элементов (Overlapping).
- 🔥 **Вкладки внутри Установщика:** Группировка элементов по правой и левой колонке через `CreateGroup`.
- ⚙️ **Тематические пресеты:** Интерфейс плавно подстраивается под смену темы (`Color3:lerp()`).
-  **Cloud Auto-Update:** Валяющаяся на GitHub библиотека обновляется "на лету".
- 🛡️ **Обработка Ошибок:** Встроенная валидация конфигов JSON через `pcall` защищает ваш скрипт от крашей.

---

##  Продвинутое Использование (Advanced Usage)

### Зависимости элементов (Dependencies)
Вы можете сцеплять элементы между собой. Если `Aim Enabled` сброшен, ползунок станет неактивным:
```lua
AimGroup:CreateToggle("Aim Enabled", false, function(v) end)
AimGroup:CreateSlider("FOV", 1, 100, 50, function(v) end):AddDependency("Aim Enabled", true)
```

### Динамические Keybinds:
```lua
AimGroup:CreateToggle("Aim Enabled", false, function() end):AddKeybind(Enum.KeyCode.F)
```

---

##  Таблица для Разработчиков: (Developer API)

### Инициализация Библиотеки
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/NecroUI-Library/main/init.lua?t=" .. tostring(tick())))()

local Window = Library.new("NecroUI V2 Pro", Color3.fromRGB(155, 89, 182))
```

### Создание Вкладки (Tab)
Вкладки автоматически добавляются в вертикальное меню навигации слева.
```lua
local CombatTab = Window:CreateTab("Combat")
```

### Создание Группы (Groupbox)
Элементы группируются по граням интерфейса ложась либо слева (`"Left"`), либо справа (`"Right"`).
```lua
local AimbotGroup = CombatTab:CreateGroup("Aimbot Settings", "Left")
local ESPGroup = CombatTab:CreateGroup("ESP Settings", "Right")
```

### Элементы управления (UI Elements)

#### 1. Переключатель (Toggle)
```lua
AimbotGroup:AddToggle("Enabled", {
    Text = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot State: ", value)
    end
})
```

#### 2. Ползунок (Slider)
```lua
AimbotGroup:AddSlider("FOV", {
    Text = "Aimbot FOV",
    Default = 50,
    Min = 0,
    Max = 360,
    Rounding = 1,
    Callback = function(value)
        print("New FOV: ", value)
    end
})
```

#### 3. Кнопка (Button)
```lua
AimbotGroup:AddButton("Reset Settings", function()
    print("Reset button clicked!")
end)
```

#### 4. Выпадающий список (Dropdown)
```lua
AimbotGroup:AddDropdown("TargetPart", {
    Text = "Target Part",
    Default = 1,
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Callback = function(value)
        print("Selected Part: ", value)
    end
})
```

#### 5. Выбор цвета (ColorPicker)
```lua
ESPGroup:AddColorPicker("ESPColor", {
    Text = "Box Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(value)
        print("New ESP Color set!")
    end
})
```

---

##  Безопасность и Обновления (Security & Updates)
- **Обновления:** Библиотека не требует ручного скачивания обновлений. Загрузка через `game:HttpGet` по ссылке с окончанием `?t=tick()` обходит кэш и всегда подгружает новейшие исправления напрямую с GitHub (Continuous Delivery).
- **Безопасность:** Конфигурации сохраняются локально (`writefile`) на устройстве пользователя. Подробности читайте в файле `SECURITY.md`.
- **Ошибки:** Встроенная валидация загрузки и парсинга JSON (`pcall`) защищает скрипт от непредвиденных крашей при повреждении конфигураций.

## 📄 Лицензия (License)
Проект распространяется по лицензии **MIT License**. Подробнее см. в файле `LICENSE`.

**Отказ от ответственности**: Данный проект предоставляется (as is), без каких-либо гарантий. Автор не несет ответственности за любые возможные последствия, возникшие в результате использования данного проекта. Вся ответственность за использование полностью лежит на вас.
