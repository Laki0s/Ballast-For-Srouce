--
-- BALLAST FOR SOURCE PROJECT, 2026
-- ballast_for_source
-- File description:
-- Tests : timers simulés, déclenchés à la main par Mock.fire_timer.
-- Auteur : Laki0s_ (contributeurs : voir CREDITS.md)
--

local timers = {}

timer = {}

--- Crée ou remplace le timer name.
function timer.Create(name, delay, reps, fn)
    timers[name] = { delay = delay, reps = reps, fn = fn }
end

--- Supprime le timer name.
function timer.Remove(name)
    timers[name] = nil
end

--- Indique si le timer name existe.
function timer.Exists(name)
    return timers[name] ~= nil
end

--- Déclenche une fois le timer name, comme si son délai était écoulé.
function Mock.fire_timer(name)
    timers[name].fn()
end
