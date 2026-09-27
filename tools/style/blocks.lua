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

--- Empile une boucle for ou while, dont le do n'ouvre pas de bloc.
local function push_loop(state, line)
    state.pending = state.pending + 1
    push_control(state, line)
end

--- Ouvre un bloc do seul, ou consomme le do d'une boucle.
local function push_do(state, line)
    if state.pending > 0 then
        state.pending = state.pending - 1
        return
    end
    push_control(state, line)
end

--- Empile une fonction : sa profondeur de contrôle repart de zéro.
local function push_function(state, line, code, pos)
    local info = parse_header(code, pos, line)

    state.stack[#state.stack + 1] = { depth = 0, info = info }
    state.functions[#state.functions + 1] = info
    state.open[#state.open + 1] = info
end

--- C-C1 : un elseif compte un niveau de plus que son if.
local function check_elseif(state, line)
    local top = state.stack[#state.stack]
    local depth = (top and top.depth or 0) + 1

    if depth >= MAX_DEPTH then
        state.report(line, "C-C1", "elseif de profondeur " .. depth)
    end
end

--- Dépile le bloc fermé ; une fonction retient sa ligne de fin.
local function pop_block(state, line)
    local frame = table.remove(state.stack)

    if frame and frame.info then
        frame.info.last = line
        table.remove(state.open)
    end
end

--- Traitement associé à chaque mot-clé qui ouvre ou ferme un bloc.
local HANDLERS = {
    ["function"] = push_function,
    ["if"] = push_control,
    ["repeat"] = push_control,
    ["for"] = push_loop,
    ["while"] = push_loop,
    ["do"] = push_do,
    ["elseif"] = check_elseif,
    ["end"] = pop_block,
    ["until"] = pop_block,
}

--- Traite dans l'ordre les mots-clés de bloc d'une ligne de code.
local function scan_line(state, code, line)
    state.owners[line] = state.open[#state.open]
    for pos, word in code:gmatch("()([%a_][%w_]*)") do
        if HANDLERS[word] then
            HANDLERS[word](state, line, code, pos)
        end
    end
end

--- Repère les fonctions (file.functions) et la fonction qui possède
--- chaque ligne (file.owners), en signalant les imbrications.
function M.check(file, report)
    local state = {
        stack = {},
        open = {},
        functions = {},
        owners = {},
        pending = 0,
        report = report,
    }

    for n, code in ipairs(file.code) do
        scan_line(state, code, n)
    end
    for _, info in ipairs(state.functions) do
        info.last = info.last or #file.code
    end
    file.functions = state.functions
    file.owners = state.owners
end

return M
