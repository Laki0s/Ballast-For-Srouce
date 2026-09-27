--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Vérificateur de style : suit l'ouverture et la fermeture des blocs pour
-- repérer les fonctions et la profondeur d'imbrication (C-C1).
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local MAX_DEPTH = 3
local HEADER = "^function%s*([%w_%.:]*)%s*(%b())"

local M = {}

--- Lit nom, nombre de paramètres et portée de la fonction ouverte à pos.
local function parse_header(code, pos, line)
    local name, params = code:match(HEADER, pos)
    local inner = params and params:sub(2, -2):gsub("%s", "") or ""
    local count = 0

    if inner ~= "" then
        count = select(2, inner:gsub(",", "")) + 1
    end
    return {
        line = line,
        name = name or "",
        params = count,
        is_local = code:sub(1, pos - 1):match("local%s+$") ~= nil,
    }
end

--- Empile un bloc de contrôle et signale une imbrication trop profonde.
local function push_control(state, line)
    local top = state.stack[#state.stack]
    local depth = (top and top.depth or 0) + 1

    state.stack[#state.stack + 1] = { depth = depth }
    if depth >= MAX_DEPTH then
        state.report(line, "C-C1", "imbrication de profondeur " .. depth)
    end
end
