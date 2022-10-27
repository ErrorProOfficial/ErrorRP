Config = Config or {}

Config.RepeatTimeout = 2000
Config.CallRepeats = 10
Config.OpenPhone = 297	--244
Config.AnonymousPrice = 0.2
Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Телефон",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Съобщения",
        tooltipPos = "top",
        style = "font-size: 2.8vh";
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Настройки",
        tooltipPos = "top",
        style = "padding-right: .08vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
    },
    ["twitter"] = {
        app = "twitter",
        color = "#1da1f2",
        icon = "fab fa-twitter",
        tooltipText = "Twitter",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 3,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#575fcf",
        icon = "fas fa-warehouse",
        tooltipText = "Гараж",
        job = false,
        blockedjobs = {},
        slot = 5,
        Alerts = 0,
    },
    ["mail"] = {
        app = "mail",
        color = "#ff002f",
        icon = "fas fa-envelope",
        tooltipText = "Имейл",
        job = false,
        blockedjobs = {},
        slot = 6,
        Alerts = 0,
    },
    ["advert"] = {
        app = "advert",
        color = "#ff8f1a",
        icon = "fas fa-ad",
        tooltipText = "Обяви",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Банка",
        job = false,
        blockedjobs = {},
        slot = 8,
        Alerts = 0,
    },
    ["racing"] = {
        app = "racing",
        color = "#25d366",
        icon = "fas fa-flag-checkered",
        tooltipText = "Състезания",
        style = "font-size: 2.3vh";
        job = false,
        blockedjobs = {
            "police"
        },
        slot = 12,
        Alerts = 0,
    },
--   ["crypto"] = {
--       app = "crypto",
--       color = "#b94fe3",
--       icon = "fas fa-chart-pie",
--       tooltipText = "Crypto",
--       job = false,
--       blockedjobs = {},
--       slot = 13,
--       Alerts = 0,
--   },
    ["houses"] = {
        app = "houses",
        color = "#27ae60",
        icon = "fas fa-home",
        tooltipText = "Имоти",
        job = false,
        blockedjobs = {},
        slot = 10,
        Alerts = 0,
    },
--[[    ["occasion"] = {
        app = "occasion",
        color = "#f1c40f",
        icon = "fas fa-car-side",
        tooltipText = "Mobile.bg",
        job = false,
        blockedjobs = {},
        slot = 11,
        Alerts = 0,
    },]]
    ["meos"] = {
        app = "meos",
        color = "#004682",
        icon = "fas fa-ad",
        tooltipText = "МЕОС",
        job = "police",
        blockedjobs = {},
        slot = 11,
        Alerts = 0,
    },
    ["lawyers"] = {
        app = "lawyers",
        color = "#26d4ce",
        icon = "fas fa-user-tie",
        tooltipText = "Услуги",
        tooltipPos = "bottom",
        job = false,
        blockedjobs = {},
        slot = 9,
        Alerts = 0,
    },
}

Config.MaxSlots = 20

Config.StoreApps = {
    ["territory"] = {
        app = "territory",
        color = "#353b48",
        icon = "fas fa-globe-europe",
        tooltipText = "Territorium",
        tooltipPos = "right",
        style = "";
        job = false,
        blockedjobs = {},
        slot = 15,
        Alerts = 0,
        password = true,
        creator = "",
        title = "Territory",
    },
}