--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Lanceur des tests, depuis la racine du dépôt :
-- luajit tests/run.lua tests/test_*.lua
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local DIR = arg[0]:match("^(.*)[/\\]") or "."
local MOCKS = {
    "env.lua",
    "engine.lua",
    "player.lua",
    "hook.lua",
    "timer.lua",
    "convar.lua",
    "concommand.lua",
}

--- Recharge l'API GMod simulée puis l'addon, pour partir d'un état neuf.
local function load_addon()
    Ballast = nil
    for _, name in ipairs(MOCKS) do
        dofile(DIR .. "/mock/" .. name)
    end
    Mock.root = DIR .. "/../"
    dofile(Mock.root .. "lua/autorun/ballast_init.lua")
end

--- Exécute un cas de test après avoir rechargé l'addon.
local function run_isolated(fn)
    load_addon()
    fn()
end

--- Exécute un cas de test ; renvoie vrai s'il réussit.
local function run_case(case)
    local ok, err = pcall(run_isolated, case.fn)

    print((ok and "  ok     " or "  ÉCHEC  ") .. case.name)
    if not ok then
        print("         " .. tostring(err))
    end
    return ok
end

--- Exécute les cas d'un fichier de tests ; renvoie le nombre d'échecs.
local function run_suite(path)
    local failed = 0

    Check.cases = {}
    dofile(path)
    print(path)
    for _, case in ipairs(Check.cases) do
        failed = failed + (run_case(case) and 0 or 1)
    end
    return failed
end

--- Lance les fichiers de tests donnés ; code de sortie 1 en cas d'échec.
local function main(paths)
    local failed = 0

    dofile(DIR .. "/check.lua")
    for _, path in ipairs(paths) do
        failed = failed + run_suite(path)
    end
    if failed > 0 then
        print(failed .. " test(s) en échec.")
        os.exit(1)
    end
    print("Tous les tests passent.")
end

main(arg)
