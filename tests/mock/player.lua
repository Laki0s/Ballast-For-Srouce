--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : joueur simulé, avec ses droits et sa console.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

--- Un joueur simulé est toujours valide.
local function is_valid()
    return true
end

--- Droits superadmin du joueur simulé.
local function is_super_admin(self)
    return self.superadmin
end

--- Retient les lignes envoyées à la console du joueur.
local function print_message(self, _, text)
    self.messages[#self.messages + 1] = text
end

--- Crée un joueur simulé, superadmin ou non.
function Mock.new_player(superadmin)
    return {
        superadmin = superadmin,
        messages = {},
        IsValid = is_valid,
        IsSuperAdmin = is_super_admin,
        PrintMessage = print_message,
    }
end
