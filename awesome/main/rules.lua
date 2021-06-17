-- Standard awesome library
local awful     = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

local _M = {}

-- reading
-- https://awesomewm.org/apidoc/libraries/awful.rules.html

function _M.get(clientkeys, clientbuttons)
  local rules = {

    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width  = beautiful.border_width,
            border_color  = beautiful.border_normal,
            focus         = awful.client.focus.filter,
            raise         = true,
            keys          = clientkeys,
            buttons       = clientbuttons,
            screen        = awful.screen.preferred,
            titlebars_enabled = true
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
            "pinentry"
            },
            class = {
              "Arandr",
              "Pcmanfm",
              "Sxiv",
              "connman-gtk",
              "connman-gtk",
              "simplescreenrecorder",
              "xdman-Main"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
              "Event Tester",  -- xev.
            },
            role = {
              "AlarmWindow",  -- Thunderbird's calendar.
              "ConfigManager",  -- Thunderbird's about:config.
              "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
      properties = {
        floating = true
      }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = {
            titlebars_enabled = true
        }
    },

    {
        rule_any = {
            class = {
                "Chromium",
            },
        },
        properties = {
            border_width = 0,
            titlebars_enabled = false
        }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

  }

  return rules
end

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
