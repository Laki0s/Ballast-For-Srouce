--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : environnement GMod simulé (réalm serveur, constantes, horloge,
-- console). Rechargé avant chaque cas de test.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

Mock = {
    root = "",
    clock = 0,
    output = {},
    edicts = 0,
    players = 0,
}

SERVER = true
CLIENT = false
FCVAR_ARCHIVE = 128
FCVAR_NOTIFY = 256
HUD_PRINTCONSOLE = 2

--- Horloge haute précision, avancée à la main par Mock.advance.
function SysTime()
    return Mock.clock
end

--- Avance l'horloge simulée de dt secondes.
function Mock.advance(dt)
    Mock.clock = Mock.clock + dt
end

--- Capture les lignes de la console serveur dans Mock.output.
function MsgN(...)
    Mock.output[#Mock.output + 1] = table.concat({ ... })
end

--- Vrai pour un objet valide (joueur simulé), faux pour nil.
function IsValid(value)
    return value ~= nil and value.IsValid ~= nil and value:IsValid()
end
